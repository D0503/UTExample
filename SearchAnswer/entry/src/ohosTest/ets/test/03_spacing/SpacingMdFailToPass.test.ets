import { afterAll, beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver } from '@kit.TestKit';
import { JSON } from '@kit.ArkTS';
import {
  getBoundsById,
  getBoundsListByIds,
  GUESS_LIKE_ITEM_IDS,
  startAbility,
} from '../common/TestHelper';
import { expectBreakpointIn, getWindowBounds } from '../common/DeviceHelper';
import { expectGapNear, expectHorizontalMarginNear } from '../common/LayoutAssertHelper';
import { openFullSearchPage } from '../common/SearchActionHelper';

// 方法说明：md 间距 FailToPass，验证折叠屏展开态页面边距和模块间距放大。
export default function spacingMdFailToPassTest() {
  describe('SpacingMdFailToPassTest', () => {
    let driver: Driver;
    let bundleName: string;

    beforeAll(async () => {
      driver = Driver.create();
      bundleName = abilityDelegatorRegistry.getArguments().bundleName;
      await startAbility(driver, bundleName, 'EntryAbility');
      await expectBreakpointIn(driver, bundleName, ['md']);
    })

    afterAll(async () => {
      await driver.waitForIdle(2000, 3000);
    })

    // 用例说明：md 断点页面左右边距应从 16vp 增大到 24vp。
    it('should_set_page_margin_24vp_on_md', Level.LEVEL1, async (done: Function) => {
      try {
        await openFullSearchPage(driver);
        const windowRect = await getWindowBounds(driver, bundleName);
        const historySection = await getBoundsById(driver, 'history-section');
        expectHorizontalMarginNear(windowRect, historySection, 24);
      } catch (e) {
        console.error('should_set_page_margin_24vp_on_md error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：md 断点“猜你想搜”列间距应为 12vp。
    it('should_set_guess_like_column_gap_12vp_on_md', Level.LEVEL1, async (done: Function) => {
      try {
        await openFullSearchPage(driver);
        const rects = await getBoundsListByIds(driver, GUESS_LIKE_ITEM_IDS);
        expect(rects.length).assertLarger(1);
        expectGapNear(rects[0], rects[1], 12);
      } catch (e) {
        console.error('should_set_guess_like_column_gap_12vp_on_md error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })
  })
}
