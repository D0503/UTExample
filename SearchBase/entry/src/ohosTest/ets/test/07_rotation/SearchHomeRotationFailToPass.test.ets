import { afterAll, beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, DisplayRotation, Driver } from '@kit.TestKit';
import { JSON } from '@kit.ArkTS';
import {
  expectComponentAbsent,
  expectVisible,
  getBoundsById,
  setShallowWindowParam,
  startAbility,
} from '../common/TestHelper';
import { expectBreakpointIn, getBreakpointName, getWindowVpWidth, rotateTablet } from '../common/DeviceHelper';
import { openFullSearchPage, tapById } from '../common/SearchActionHelper';
import { expectWidthAtLeast, expectWidthAtMost } from '../common/LayoutAssertHelper';

// 方法说明：搜索首页横竖屏 FailToPass，验证浅层窗口在 md 断点关闭并恢复入口页。
export default function searchHomeRotationFailToPassTest() {
  describe('SearchHomeRotationFailToPassTest', () => {
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
      await driver.waitForIdle(2000, 3000);
    })

    // 用例说明：横屏已打开的首页浅层窗口切到竖屏 md 后应关闭，回到普通入口页。。
    it('should_close_home_popup_after_portrait_rotation', Level.LEVEL1, async (done: Function) => {
      try {
        await expectBreakpointIn(driver, bundleName, ['lg', 'xl']);
        await tapById(driver, 'search-entry-box');
        const history = await getBoundsById(driver, 'history-section');
        expectVisible(history);
        expectWidthAtMost(history, 400);

        await rotateTablet(driver, DisplayRotation.ROTATION_90);
        const breakpoint = getBreakpointName(await getWindowVpWidth(driver, bundleName));
        if (breakpoint === 'md') {
          expectVisible(await getBoundsById(driver, 'search-entry-box'));

          await tapById(driver, 'search-entry-box');
          await expectComponentAbsent(driver, 'search-entry-page');
          const history = await getBoundsById(driver, 'history-section');
          expectVisible(history);
          expectWidthAtLeast(history, 480);
        }
      } catch (e) {
        console.error('should_close_home_popup_after_portrait_rotation error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：竖屏再切回横屏时应停留入口页，没有浅层窗口。
    it('should_return_to_landscape_entry_without_popup_after_landscape_rotation', Level.LEVEL1, async (done: Function) => {
      try {
        const breakpoint = getBreakpointName(await getWindowVpWidth(driver, bundleName));
        if (['lg', 'xl'].includes(breakpoint)) {
          await rotateTablet(driver, DisplayRotation.ROTATION_90);
        }

        const breakpoint_rotation = getBreakpointName(await getWindowVpWidth(driver, bundleName));
        if (breakpoint_rotation === 'md') {
          await openFullSearchPage(driver);

          await rotateTablet(driver, DisplayRotation.ROTATION_0);
          await expectBreakpointIn(driver, bundleName, ['lg', 'xl']);
          expectVisible(await getBoundsById(driver, 'search-entry-page'));
          expectVisible(await getBoundsById(driver, 'search-entry-box'));
          await expectComponentAbsent(driver, 'history-section');
        }
      } catch (e) {
        console.error('should_return_to_landscape_entry_without_popup_after_landscape_rotation error' +
          JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })
  })
}
