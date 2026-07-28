import { beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { Driver } from '@kit.TestKit';
import {
  captureGuiEvidence,
  getDriver,
  GuiTestSession,
  NativeGuiState,
  pointInBounds,
  readNativeGuiState,
  startGuiTestSession,
  waitForNativeGuiState
} from './GuiTestHelper';

const KEYCODE_A: number = 2017;
const SDL_KEYCODE_A: number = 97;

export default function SdlKeyboardUiSuite(): void {
  describe('SdlKeyboardUiSuite', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = getDriver();
    });

    it('routes a simulated A key through SDL and mirrors native state', Level.LEVEL3, async () => {
      const session: GuiTestSession = await startGuiTestSession(driver);
      const baseline: NativeGuiState = await readNativeGuiState(session.driver);
      const bounds = await session.surface.getBounds();

      const inputArea: number[] = pointInBounds(bounds, 0.50, 0.80);
      await session.driver.click(inputArea[0], inputArea[1]);
      await session.driver.triggerKey(KEYCODE_A);
      const keyed: NativeGuiState = await waitForNativeGuiState(
        session.driver,
        (state: NativeGuiState): boolean =>
          state.keyboardEvents >= baseline.keyboardEvents + 1 &&
          state.lastKeyCode === SDL_KEYCODE_A,
        'SDL A key event was not reflected by nativeStatus'
      );
      expect(keyed.keyboardEvents).assertLargerOrEqual(baseline.keyboardEvents + 1);
      expect(keyed.lastKeyCode).assertEqual(SDL_KEYCODE_A);

      const screenshotPath: string =
        await captureGuiEvidence(session.driver, 'sdl2-keyboard-ui.png');
      expect(screenshotPath.length).assertLarger(0);
    });
  });
}
