import { afterAll, beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver } from '@kit.TestKit';
import { JSON } from '@kit.ArkTS';
import {
  AUTOCOMPLETE_ITEM_IDS,
  expectVisible,
  getBoundsById,
  getBoundsListByIds,
  SEARCH_RESULT_ITEM_IDS,
  startAbility,
  tryGetBoundsById,
} from '../common/TestHelper';
import { getWindowBounds } from '../common/DeviceHelper';
import { expectColumnCount, expectInWindow, expectNoOverlap } from '../common/LayoutAssertHelper';
import {
  openFullSearchPage,
  openResultState,
  openSuggestionState,
  tapHomeSearchEntry,
} from '../common/SearchActionHelper';

// 方法说明：全设备基础 PassToPass，用于保护搜索主流程和关键组件可用性。
export default function allDevicePassToPassTest() {
  describe('AllDevicePassToPassTest', () => {
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

    // 用例说明：启动应用后入口页必须可见，证明应用没有白屏或启动失败。
    it('should_start_ability_successfully', Level.LEVEL0, async (done: Function) => {
      try {
        const entryPage = await getBoundsById(driver, 'search-entry-page');
        expectVisible(entryPage);
      } catch (e) {
        console.error('should_start_ability_successfully error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：入口页至少存在一种可点击搜索入口，兼容手机图标和大屏搜索框，点击后应进入搜索页。
    it('should_open_search_flow_from_entry', Level.LEVEL0, async (done: Function) => {
      try {
        await tapHomeSearchEntry(driver);
        const windowRect = await getWindowBounds(driver, bundleName);
        const fullPage = await tryGetBoundsById(driver, 'search-result-page');
        if (fullPage !== null) {
          const back = await getBoundsById(driver, 'search-back-button');
          expectInWindow(windowRect, back);
          const searchInput = await getBoundsById(driver, 'search-input');
          expectInWindow(windowRect, searchInput);
        } else {
          expect(false).assertTrue();
        }
      } catch (e) {
        console.error('should_open_search_flow_from_entry error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：历史搜索胶囊应正常展示，彼此不遮挡。
    it('should_show_history_chips_without_overlap', Level.LEVEL1, async (done: Function) => {
      try {
        await openFullSearchPage(driver);
        const chips = await getBoundsListByIds(driver, ['history-chip-0', 'history-chip-1']);
        expect(chips.length).assertLarger(1);
        for (let index = 0; index < chips.length; index++) {
          expectVisible(chips[index]);
        }
        expectNoOverlap(chips[0], chips[1]);
      } catch (e) {
        console.error('should_show_history_chips_without_overlap error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：输入关键词后能展示联想词，且联想列表始终保持单列。
    it('should_show_suggestions_after_keyword_input', Level.LEVEL1, async (done: Function) => {
      try {
        await openSuggestionState(driver);
        await expectColumnCount(driver, AUTOCOMPLETE_ITEM_IDS, 1);
      } catch (e) {
        console.error('should_show_suggestions_after_keyword_input error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：提交搜索后搜索结果区域必须可见，保护基础搜索提交链路。
    it('should_show_result_after_submit', Level.LEVEL1, async (done: Function) => {
      try {
        await openResultState(driver, '苹果');
        const result = await getBoundsById(driver, SEARCH_RESULT_ITEM_IDS[0]);
        expectVisible(result);
      } catch (e) {
        console.error('should_show_result_after_submit error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：搜索栏输入框和返回按钮等关键组件必须在窗口内完整可见。
    it('should_keep_key_components_inside_window', Level.LEVEL1, async (done: Function) => {
      try {
        await openFullSearchPage(driver);
        const windowRect = await getWindowBounds(driver, bundleName);
        const input = await getBoundsById(driver, 'search-input');
        const fullPage = await tryGetBoundsById(driver, 'search-result-page');
        if (fullPage !== null) {
          const back = await getBoundsById(driver, 'search-back-button');
          expectInWindow(windowRect, back);
        }
        expectInWindow(windowRect, input);
      } catch (e) {
        console.error('should_keep_key_components_inside_window error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })
  })
}
