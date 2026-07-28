import { beforeAll, describe, expect, it, Level } from "@package:pkg_modules/.ohpm/@ohos+hypium@1.0.25/pkg_modules/@ohos/hypium/index";
import type { Driver } from "@ohos:UiTest";
import { captureGuiEvidence, getDriver, pointInBounds, readNativeGuiState, startGuiTestSession, waitForNativeGuiState } from "@bundle:com.thirdparty.validation.sdl2/entry_test/ets/test/GuiTestHelper";
import type { GuiTestSession, NativeGuiState } from "@bundle:com.thirdparty.validation.sdl2/entry_test/ets/test/GuiTestHelper";
export default function SdlPointerUiSuite(): void {
    describe('SdlPointerUiSuite', () => {
        let driver: Driver;
        beforeAll(async () => {
            driver = getDriver();
        });
        it('routes relative pointer input through SDL and mirrors native state', Level.LEVEL3, async () => {
            const session: GuiTestSession = await startGuiTestSession(driver);
            const baseline: NativeGuiState = await readNativeGuiState(session.driver);
            const bounds = await session.surface.getBounds();
            const button: number[] = pointInBounds(bounds, 0.25, 0.35);
            await session.driver.click(button[0], button[1]);
            const clicked: NativeGuiState = await waitForNativeGuiState(session.driver, (state: NativeGuiState): boolean => state.buttonClicks >= baseline.buttonClicks + 1, 'SDL button click was not reflected by nativeStatus');
            expect(clicked.buttonClicks).assertLargerOrEqual(baseline.buttonClicks + 1);
            const sliderStart: number[] = pointInBounds(bounds, 0.20, 0.60);
            // The SDL slider track spans 20%-80% of the surface, so 65% maps to 75%.
            const sliderEnd: number[] = pointInBounds(bounds, 0.65, 0.60);
            await session.driver.drag(sliderStart[0], sliderStart[1], sliderEnd[0], sliderEnd[1], 600);
            const dragged: NativeGuiState = await waitForNativeGuiState(session.driver, (state: NativeGuiState): boolean => state.slider >= 0.70 && state.slider <= 0.80, 'SDL slider did not reach the expected relative position');
            expect(dragged.slider).assertLargerOrEqual(0.70);
            expect(dragged.slider).assertLessOrEqual(0.80);
            const screenshotPath: string = await captureGuiEvidence(session.driver, 'sdl2-pointer-ui.png');
            expect(screenshotPath.length).assertLarger(0);
        });
    });
}
