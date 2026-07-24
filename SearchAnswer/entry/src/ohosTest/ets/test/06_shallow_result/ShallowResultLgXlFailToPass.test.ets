import { afterAll, beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver } from '@kit.TestKit';
import { JSON } from '@kit.ArkTS';
import {
  AUTOCOMPLETE_ITEM_IDS,
  expectVisible,
  getBoundsById,
  SEARCH_RESULT_ITEM_IDS,
  setShallowWindowParam,
  startAbility,
} from '../common/TestHelper';
import { expectBreakpointIn, getWindowBounds } from '../common/DeviceHelper';
import {
  expectColumnCount,
  expectRightAlignedNear,
  expectWidthAtMost,
  expectWidthNear,
} from '../common/LayoutAssertHelper';
import { inputKeyword, openResultState } from '../common/SearchActionHelper';

// 方法说明：浅层窗口结果页 lg/xl FailToPass，验证右上角搜索栏和获焦弹窗。
export default function shallowResultLgXlFailToPassTest() {
  describe('ShallowResultLgXlFailToPassTest', () => {
    let driver: Driver;
    let bundleName: string;

    beforeAll(async () => {
      driver = Driver.create();
      bundleName = abilityDelegatorRegistry.getArguments().bundleName;
      setShallowWindowParam(true);
      await startAbility(driver, bundleName, 'EntryAbility');
      await expectBreakpointIn(driver, bundleName, ['lg', 'xl']);
      await openResultState(driver);
    })

    afterAll(async () => {
      setShallowWindowParam(false);
      await driver.waitForIdle(2000, 3000);
    })

    // 用例说明：lg/xl 结果页搜索框应固定在页面右上角，搜索框宽度应接近 400vp。。
    it('should_place_result_search_bar_at_top_right_on_lg_xl', Level.LEVEL1, async (done: Function) => {
      try {
        const windowRect = await getWindowBounds(driver, bundleName);
        const input = await getBoundsById(driver, 'search-input');
        expectVisible(input);
        expectRightAlignedNear(windowRect, input, 32, 10);
        expectWidthNear(input, 400);
      } catch (e) {
        console.error('should_place_result_search_bar_at_top_right_on_lg_xl error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：lg/xl 搜索框未聚焦、弹框未出现时，搜索结果应展示 3 列。
    it('should_show_result_three_columns_before_popup_on_lg_xl', Level.LEVEL1, async (done: Function) => {
      try {
        await expectColumnCount(driver, SEARCH_RESULT_ITEM_IDS, 3);
      } catch (e) {
        console.error('should_show_result_three_columns_before_popup_on_lg_xl error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：lg/xl 结果页搜索框获焦输入后，应打开 400vp 内的联想浅层窗口。
    it('should_show_result_popup_autocomplete_after_keyword_input_on_lg_xl', Level.LEVEL1, async (done: Function) => {
      try {
        await inputKeyword(driver, '苹果');
        const autocomplete = await getBoundsById(driver, 'autocomplete-section');
        expectVisible(autocomplete);
        expectWidthAtMost(autocomplete, 400);
        await expectColumnCount(driver, AUTOCOMPLETE_ITEM_IDS, 1);
      } catch (e) {
        console.error('should_show_result_popup_autocomplete_after_keyword_input_on_lg_xl error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })
  })
}
