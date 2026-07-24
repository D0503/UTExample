import { afterAll, beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver } from '@kit.TestKit';
import { JSON } from '@kit.ArkTS';
import {
  getBoundsById,
  getBoundsListByIds,
  HISTORY_CHIP_IDS,
  startAbility,
  Rect
} from '../common/TestHelper';
import { expectBreakpointIn } from '../common/DeviceHelper';
import { getHistoryChipGridInfo, HistoryChipGridInfo } from '../common/HistoryGridHelper';
import { expectGapNear, expectWidthNear } from '../common/LayoutAssertHelper';
import { openFullSearchPage } from '../common/SearchActionHelper';

// 方法说明：历史胶囊 FailToPass，验证中大屏下胶囊宽度和间距使用栅格约束。
export default function historyCapsuleMdLgXlFailToPassTest() {
  describe('HistoryCapsuleMdLgXlFailToPassTest', () => {
    let driver: Driver;
    let bundleName: string;
    let grid: HistoryChipGridInfo;
    let chips: Rect[];

    beforeAll(async () => {
      driver = Driver.create();
      bundleName = abilityDelegatorRegistry.getArguments().bundleName;
      await startAbility(driver, bundleName, 'EntryAbility');
      const breakpoint = await expectBreakpointIn(driver, bundleName, ['md', 'lg', 'xl']);
      await openFullSearchPage(driver);
      const container = await getBoundsById(driver, 'search-bar-row');
      chips = await getBoundsListByIds(driver, HISTORY_CHIP_IDS);
      expect(chips.length).assertLarger(1);
      grid = getHistoryChipGridInfo(container, breakpoint);
    })

    afterAll(async () => {
      await driver.waitForIdle(2000, 3000);
    })

    // 用例说明：md/lg/xl 断点历史胶囊最小宽度不应低于一栅格。
    it('should_keep_history_chip_min_width_at_least_one_grid_on_large_screen', Level.LEVEL1, async (done: Function) => {
      try {
        expectWidthNear(chips[1], grid.minChipWidth, 5);
      } catch (e) {
        console.error('should_keep_history_chip_min_width_at_least_one_grid_on_large_screen error' +
          JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：md/lg/xl 断点历史胶囊最大宽度应按断点限制为 3 或 4 栅格加对应 gutter。
    it('should_keep_history_chip_max_width_within_breakpoint_grid_span_on_large_screen',
      Level.LEVEL1, async (done: Function) => {
        try {
          expectWidthNear(chips[0], grid.maxChipWidth, 5);
        } catch (e) {
          console.error('should_keep_history_chip_max_width_within_breakpoint_grid_span_on_large_screen error' +
            JSON.stringify(e));
          expect(false).assertTrue();
        }
        done();
      })

    // 用例说明：md/lg/xl 断点历史胶囊间距应分别为 12vp、16vp、20vp。
    it('should_match_history_chip_gap_to_breakpoint_gutter_on_large_screen', Level.LEVEL1, async (done: Function) => {
      try {
        expectGapNear(chips[0], chips[1], grid.gutter);
      } catch (e) {
        console.error('should_match_history_chip_gap_to_breakpoint_gutter_on_large_screen error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })
  })
}
