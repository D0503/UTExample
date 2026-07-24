import { afterAll, beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, DisplayRotation, Driver } from '@kit.TestKit';
import { JSON } from '@kit.ArkTS';
import {
  expectVisible,
  getBoundsById,
  SEARCH_RESULT_ITEM_IDS,
  setShallowWindowParam,
  startAbility,
} from '../common/TestHelper';
import { expectBreakpointIn, getBreakpointName, getWindowVpWidth, rotateTablet } from '../common/DeviceHelper';
import { expectColumnCount, expectWidthAtLeast, expectWidthAtMost } from '../common/LayoutAssertHelper';
import { inputKeyword, openResultState } from '../common/SearchActionHelper';

// 方法说明：结果页横竖屏 FailToPass，验证浅层联想状态在断点变化后正确关闭和恢复。
export default function resultPageRotationFailToPassTest() {
  describe('ResultPageRotationFailToPassTest', () => {
    let driver: Driver;
    let bundleName: string;

    beforeAll(async () => {
      driver = Driver.create();
      bundleName = abilityDelegatorRegistry.getArguments().bundleName;
      setShallowWindowParam(true);
      await startAbility(driver, bundleName, 'EntryAbility');
    })

    afterAll(async () => {
      setShallowWindowParam(false);
      await driver.delayMs(500);
    })

    // 用例说明：结果页横屏浅层联想切到竖屏 md 后应回到正常结果页。
    it('should_close_result_popup_after_portrait_rotation', Level.LEVEL1, async (done: Function) => {
      try {
        await expectBreakpointIn(driver, bundleName, ['lg', 'xl']);
        await openResultState(driver);

        await rotateTablet(driver, DisplayRotation.ROTATION_90);
        const breakpoint = getBreakpointName(await getWindowVpWidth(driver, bundleName));
        if (breakpoint === 'md') {
          await expectColumnCount(driver, SEARCH_RESULT_ITEM_IDS, 2);
          await inputKeyword(driver);
          const portraitAutocomplete = await getBoundsById(driver, 'autocomplete-section');
          expectVisible(portraitAutocomplete);
          expectWidthAtLeast(portraitAutocomplete, 480);
        }
      } catch (e) {
        console.error('should_close_result_popup_after_portrait_rotation error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：竖屏再切回横屏后，重新聚焦搜索框才应再次打开浅层联想窗口。
    it('should_reopen_result_popup_after_landscape_keyword_input', Level.LEVEL1, async (done: Function) => {
      try {
        const breakpoint = getBreakpointName(await getWindowVpWidth(driver, bundleName));
        if (['lg', 'xl'].includes(breakpoint)) {
          await rotateTablet(driver, DisplayRotation.ROTATION_90);
        }

        const breakpoint_rotation = getBreakpointName(await getWindowVpWidth(driver, bundleName));
        if (breakpoint_rotation === 'md') {
          await openResultState(driver);
          await rotateTablet(driver, DisplayRotation.ROTATION_0);
          await expectColumnCount(driver, SEARCH_RESULT_ITEM_IDS, 3);

          await inputKeyword(driver, '苹果');
          const autocomplete = await getBoundsById(driver, 'autocomplete-section');
          expectWidthAtMost(autocomplete, 400);
        }
      } catch (e) {
        console.error('should_reopen_result_popup_after_landscape_keyword_input error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })
  })
}
