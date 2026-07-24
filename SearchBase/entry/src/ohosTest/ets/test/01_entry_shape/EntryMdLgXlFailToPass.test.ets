import { afterAll, beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver } from '@kit.TestKit';
import { JSON } from '@kit.ArkTS';
import {
  expectComponentAbsent,
  expectVisible,
  getBoundsById,
  startAbility,
} from '../common/TestHelper';
import { expectBreakpointIn } from '../common/DeviceHelper';

// 方法说明：入口形态 FailToPass，验证 md/lg/xl 首页入口应为完整搜索框。
export default function entryMdLgXlFailToPassTest() {
  describe('EntryMdLgXlFailToPassTest', () => {
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

    // 用例说明：lg/xl 断点首页搜索入口应展示完整搜索框。
    it('should_show_search_box_on_md_lg_xl', Level.LEVEL1, async (done: Function) => {
      try {
        await expectBreakpointIn(driver, bundleName, ['md', 'lg', 'xl']);
        const box = await getBoundsById(driver, 'search-entry-box');
        expectVisible(box);
      } catch (e) {
        console.error('should_show_search_box_on_md_lg_xl error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：lg/xl 断点不应继续展示手机圆形搜索图标。
    it('should_not_keep_phone_icon_on_lg_xl', Level.LEVEL1, async (done: Function) => {
      try {
        await expectBreakpointIn(driver, bundleName, ['lg', 'xl']);
        await expectComponentAbsent(driver, 'search-entry-icon');
      } catch (e) {
        console.error('should_not_keep_phone_icon_on_lg_xl error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })
  })
}
