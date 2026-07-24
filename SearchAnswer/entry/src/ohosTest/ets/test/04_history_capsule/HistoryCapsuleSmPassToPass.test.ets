import { afterAll, beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver } from '@kit.TestKit';
import { JSON } from '@kit.ArkTS';
import {
  getBoundsById,
  getBoundsListByIds,
  HISTORY_CHIP_IDS,
  startAbility,
} from '../common/TestHelper';
import { expectBreakpointIn } from '../common/DeviceHelper';
import { getHistoryChipGridInfo } from '../common/HistoryGridHelper';
import { expectGapNear, expectWidthNear } from '../common/LayoutAssertHelper';
import { openFullSearchPage } from '../common/SearchActionHelper';

// 方法说明：历史胶囊 sm PassToPass，保护直板机历史胶囊栅格宽度和 8vp 间距。
export default function historyCapsuleSmPassToPassTest() {
  describe('HistoryCapsuleSmPassToPassTest', () => {
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

    // 用例说明：sm 断点历史胶囊最小 1 栅格、最大 2 栅格加 1 个 gutter，胶囊间距为 8vp。
    it('should_keep_history_chip_grid_layout_on_sm', Level.LEVEL1, async (done: Function) => {
      try {
        const breakpoint = await expectBreakpointIn(driver, bundleName, ['sm']);
        await openFullSearchPage(driver);
        const container = await getBoundsById(driver, 'search-bar-row');
        const chips = await getBoundsListByIds(driver, HISTORY_CHIP_IDS);
        expect(chips.length).assertLarger(1);
        const grid = getHistoryChipGridInfo(container, breakpoint);
        expectWidthNear(chips[1], grid.minChipWidth, 5);
        expectWidthNear(chips[0], grid.maxChipWidth, 5);
        expectGapNear(chips[0], chips[1], grid.gutter);
      } catch (e) {
        console.error('should_keep_history_chip_grid_layout_on_sm error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })
  })
}
