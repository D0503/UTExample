import { afterAll, beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { JSON } from '@kit.ArkTS';
import {
  expectComponentAbsent,
  expectVisible,
  getBoundsById,
  HOT_SEARCH_ITEM_IDS,
  SEARCH_RESULT_ITEM_IDS,
  setShallowWindowParam,
  startAbility,
} from '../common/TestHelper';
import { expectBreakpointIn } from '../common/DeviceHelper';
import { expectWidthAtMost, expectWidthNear } from '../common/LayoutAssertHelper';
import { closeKeyBoard, inputKeyword, openHomePopup, submitSearch, tapBlankArea } from '../common/SearchActionHelper';

// 方法说明：浅层窗口首页 lg/xl FailToPass，验证平板横屏搜索入口弹窗交互。
export default function shallowHomeLgXlFailToPassTest() {
  describe('ShallowHomeLgXlFailToPassTest', () => {
    let driver: Driver;
    let bundleName: string;

    beforeAll(async () => {
      driver = Driver.create();
      bundleName = abilityDelegatorRegistry.getArguments().bundleName;
      setShallowWindowParam(true);
      await startAbility(driver, bundleName, 'EntryAbility');
      await expectBreakpointIn(driver, bundleName, ['lg', 'xl']);
      await openHomePopup(driver);
    })

    afterAll(async () => {
      setShallowWindowParam(false);
      await driver.waitForIdle(2000, 3000);
    })

    // 用例说明：lg/xl 断点点击首页搜索框应停留当前页并打开浅层搜索承载, 浅层搜索框宽度应接近 400vp。
    it('should_keep_home_entry_search_box_width_400vp_on_lg_xl', Level.LEVEL1, async (done: Function) => {
      try {
        const entryPage = await getBoundsById(driver, 'search-entry-page');
        expectVisible(entryPage);
        const entryBox = await getBoundsById(driver, 'search-entry-box');
        expectVisible(entryBox);
        expectWidthNear(entryBox, 400);
      } catch (e) {
        console.error('should_keep_home_entry_search_box_width_400vp_on_lg_xl error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：lg/xl 首页浅层窗口内应展示输入、历史、猜你喜欢、热搜和联想等核心内容，且限制在400vp。
    it('should_keep_home_popup_sections_within_400vp_on_lg_xl', Level.LEVEL1, async (done: Function) => {
      try {
        await closeKeyBoard(driver);
        const history = await getBoundsById(driver, 'history-section');
        const guess = await getBoundsById(driver, 'guess-like-section');
        const hot = await getBoundsById(driver, 'hot-search-section');
        expectVisible(history);
        expectVisible(guess);
        expectVisible(hot);
        expectWidthAtMost(history, 400);
        expectWidthAtMost(guess, 400);
        expectWidthAtMost(hot, 400);
      } catch (e) {
        console.error('should_keep_home_popup_sections_within_400vp_on_lg_xl error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：lg/xl 首页浅层窗口内容应由可滚动组件承载，并可滚动到底部显示最后一条热搜。
    it('should_scroll_home_popup_to_show_last_hot_search_item_on_lg_xl', Level.LEVEL1, async (done: Function) => {
      try {
        await closeKeyBoard(driver);
        const scrollableComponent = await driver.findComponent(ON.type('Scroll'));
        expect(scrollableComponent !== null).assertTrue();
        if (scrollableComponent !== null) {
          await scrollableComponent.scrollToBottom(600);
          await driver.delayMs(500);
        }
        const lastHotSearchId = HOT_SEARCH_ITEM_IDS[HOT_SEARCH_ITEM_IDS.length - 1];
        const lastHotSearchItem = await getBoundsById(driver, lastHotSearchId);
        expectVisible(lastHotSearchItem);
      } catch (e) {
        console.error('should_scroll_home_popup_to_show_last_hot_search_item_on_lg_xl error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：lg/xl 首页浅层窗口点击空白区域后应关闭。
    it('should_close_home_popup_after_blank_click_on_lg_xl', Level.LEVEL1, async (done: Function) => {
      try {
        await closeKeyBoard(driver);
        await tapBlankArea(driver, bundleName);
        await expectComponentAbsent(driver, 'history-section');
        await expectComponentAbsent(driver, 'hot-search-section');
        const entryPage = await getBoundsById(driver, 'search-entry-page');
        expectVisible(entryPage);
      } catch (e) {
        console.error('should_close_home_popup_after_blank_click_on_lg_xl error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：lg/xl 首页浅层窗口联想内容应限制在 400vp 内。
    it('should_keep_home_popup_autocomplete_within_400vp_on_lg_xl', Level.LEVEL1, async (done: Function) => {
      try {
        await inputKeyword(driver, '苹果');
        const autocomplete = await getBoundsById(driver, 'autocomplete-section');
        expectVisible(autocomplete);
        expectWidthAtMost(autocomplete, 400);
      } catch (e) {
        console.error('should_keep_home_popup_autocomplete_within_400vp_on_lg_xl error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：lg/xl 首页浅层窗口提交搜索后应关闭，并进入或刷新结果状态。
    it('should_show_result_section_after_home_popup_submit_on_lg_xl', Level.LEVEL1, async (done: Function) => {
      try {
        await submitSearch(driver);
        const resultItem = await getBoundsById(driver, SEARCH_RESULT_ITEM_IDS[0]);
        expectVisible(resultItem);
      } catch (e) {
        console.error('should_show_result_section_after_home_popup_submit_on_lg_xl error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })
  })
}
