import { afterAll, beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver } from '@kit.TestKit';
import { JSON } from '@kit.ArkTS';
import {
  expectVisible,
  getBoundsById,
  startAbility,
} from '../common/TestHelper';
import { expectBreakpointIn } from '../common/DeviceHelper';
import { expectSquareNear } from '../common/LayoutAssertHelper';

// 方法说明：入口形态 PassToPass，验证 sm 首页入口保持手机圆形搜索图标。
export default function entryPhoneSmPassToPassTest() {
  describe('EntryPhoneSmPassToPassTest', () => {
    let driver: Driver;
    let bundleName: string;

    beforeAll(async () => {
      driver = Driver.create();
      bundleName = abilityDelegatorRegistry.getArguments().bundleName;
      await startAbility(driver, bundleName, 'EntryAbility');
    })

    afterAll(async () => {
      await driver.waitForIdle(2000, 3000);
    })

    // 用例说明：sm 断点首页入口应展示手机圆形搜索图标，不展示大屏完整搜索框。
    it('should_show_search_icon_on_sm', Level.LEVEL1, async (done: Function) => {
      try {
        await expectBreakpointIn(driver, bundleName, ['sm']);
        const icon = await getBoundsById(driver, 'search-entry-icon');
        expectVisible(icon);
        expectSquareNear(icon);
      } catch (e) {
        console.error('should_show_search_icon_on_sm error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })
  })
}
