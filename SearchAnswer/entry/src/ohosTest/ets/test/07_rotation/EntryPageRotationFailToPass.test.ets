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
import { tapById } from '../common/SearchActionHelper';

// 方法说明：入口页横竖屏 FailToPass，验证从 lg/xl 切回 md 后入口形态恢复。
export default function entryPageRotationFailToPassTest() {
  describe('EntryPageRotationFailToPassTest', () => {
    let driver: Driver;
    let bundleName: string;

    beforeAll(async () => {
      driver = Driver.create();
      bundleName = abilityDelegatorRegistry.getArguments().bundleName;
      setShallowWindowParam(true);
      await startAbility(driver, bundleName, 'EntryAbility');
    })

    afterAll(async () => {
      await driver.waitForIdle(2000, 3000);
    })

    // 用例说明：平板横屏入口搜索框切到竖屏 md 后，应恢复为圆形搜索图标。
    it('should_change_entry_search_box_to_icon_after_portrait_rotation', Level.LEVEL1, async (done: Function) => {
      try {
        await expectBreakpointIn(driver, bundleName, ['lg', 'xl']);
        expectVisible(await getBoundsById(driver, 'search-entry-box'));

        await rotateTablet(driver, DisplayRotation.ROTATION_90);
        const breakpoint = getBreakpointName(await getWindowVpWidth(driver, bundleName));
        if (breakpoint === 'md') {
          expectVisible(await getBoundsById(driver, 'search-entry-box'));

          await tapById(driver, 'search-entry-box');
          await expectComponentAbsent(driver, 'search-entry-page');
        }
      } catch (e) {
        console.error('should_change_entry_search_box_to_icon_after_portrait_rotation error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })
  })
}
