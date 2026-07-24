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

// 方法说明：lg/xl 断点列表列数 FailToPass，验证大屏首页列表的信息密度。
export default function listLgXlFailToPassTest() {
  describe('ListLgXlFailToPassTest', () => {
    let driver: Driver;
    let bundleName: string;

    beforeAll(async () => {
      driver = Driver.create();
      bundleName = abilityDelegatorRegistry.getArguments().bundleName;
      await startAbility(driver, bundleName, 'EntryAbility');
      await expectBreakpointIn(driver, bundleName, ['lg', 'xl']);
    })

    afterAll(async () => {
      await driver.waitForIdle(2000, 3000);
    })

    // 用例说明：lg/xl 断点“猜你想搜”应展示 3 列。
    it('should_show_guess_like_three_columns_on_lg_xl', Level.LEVEL1, async (done: Function) => {
      try {
        await openFullSearchPage(driver);
        await expectColumnCount(driver, GUESS_LIKE_ITEM_IDS, 3);
      } catch (e) {
        console.error('should_show_guess_like_three_columns_on_lg_xl error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：lg/xl 断点热搜榜应展示 3 列。
    it('should_show_hot_search_three_columns_on_lg_xl', Level.LEVEL1, async (done: Function) => {
      try {
        await openFullSearchPage(driver);
        await expectColumnCount(driver, HOT_SEARCH_ITEM_IDS, 3);
      } catch (e) {
        console.error('should_show_hot_search_three_columns_on_lg_xl error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：lg/xl 断点搜索结果应提升为 3 列。
    it('should_show_result_three_columns_on_lg_xl', Level.LEVEL1, async (done: Function) => {
      try {
        await openResultState(driver);
        await expectColumnCount(driver, SEARCH_RESULT_ITEM_IDS, 3);
      } catch (e) {
        console.error('should_show_result_three_columns_on_lg_xl error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })
  })
}
