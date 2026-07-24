import { afterAll, beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver } from '@kit.TestKit';
import { JSON } from '@kit.ArkTS';
import {
  GUESS_LIKE_ITEM_IDS,
  HOT_SEARCH_ITEM_IDS,
  SEARCH_RESULT_ITEM_IDS,
  startAbility,
} from '../common/TestHelper';
import { expectBreakpointIn } from '../common/DeviceHelper';
import { expectColumnCount } from '../common/LayoutAssertHelper';
import { openFullSearchPage, openResultState } from '../common/SearchActionHelper';

// 方法说明：手机 sm 列数 PassToPass，保护直板机列表仍按手机列数展示。
export default function listPhoneSmPassToPassTest() {
  describe('ListPhoneSmPassToPassTest', () => {
    let driver: Driver;
    let bundleName: string;

    beforeAll(async () => {
      driver = Driver.create();
      bundleName = abilityDelegatorRegistry.getArguments().bundleName;
      await startAbility(driver, bundleName, 'EntryAbility');
      await expectBreakpointIn(driver, bundleName, ['sm']);
    })

    afterAll(async () => {
      await driver.waitForIdle(2000, 3000);
    })

    // 用例说明：sm 断点“猜你想搜”应保持 2 列。
    it('should_keep_guess_like_two_columns_on_sm', Level.LEVEL1, async (done: Function) => {
      try {
        await openFullSearchPage(driver);
        await expectColumnCount(driver, GUESS_LIKE_ITEM_IDS, 2);
      } catch (e) {
        console.error('should_keep_guess_like_two_columns_on_sm error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：sm 断点热搜榜应保持单列。
    it('should_keep_hot_search_one_column_on_sm', Level.LEVEL1, async (done: Function) => {
      try {
        await openFullSearchPage(driver);
        await expectColumnCount(driver, HOT_SEARCH_ITEM_IDS, 1);
      } catch (e) {
        console.error('should_keep_hot_search_one_column_on_sm error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：sm 断点搜索结果列表应保持单列，保护直板机结果页不被大屏列数影响。
    it('should_keep_search_result_one_column_on_sm', Level.LEVEL1, async (done: Function) => {
      try {
        await openResultState(driver, '苹果');
        await expectColumnCount(driver, SEARCH_RESULT_ITEM_IDS, 1);
      } catch (e) {
        console.error('should_keep_search_result_one_column_on_sm error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })
  })
}
