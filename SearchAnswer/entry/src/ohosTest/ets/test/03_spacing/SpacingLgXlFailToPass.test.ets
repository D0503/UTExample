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

// 方法说明：lg/xl 间距 FailToPass，验证平板横屏边距和“猜你想搜”列间距放大。
export default function spacingLgXlFailToPassTest() {
  describe('SpacingLgXlFailToPassTest', () => {
    let driver: Driver;
    let bundleName: string;
    let breakpoint: string;

    beforeAll(async () => {
      driver = Driver.create();
      bundleName = abilityDelegatorRegistry.getArguments().bundleName;
      await startAbility(driver, bundleName, 'EntryAbility');
      breakpoint = await expectBreakpointIn(driver, bundleName, ['lg', 'xl']);
    })

    afterAll(async () => {
      await driver.waitForIdle(2000, 3000);
    })

    // 用例说明：lg/xl 断点页面左右边距应增大到 32vp。
    it('should_set_page_margin_32vp_on_lg_xl', Level.LEVEL1, async (done: Function) => {
      try {
        await openFullSearchPage(driver);
        const windowRect = await getWindowBounds(driver, bundleName);
        const historySection = await getBoundsById(driver, 'history-section');
        expectHorizontalMarginNear(windowRect, historySection, 32);
      } catch (e) {
        console.error('should_set_page_margin_32vp_on_lg_xl error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：lg/xl 断点“猜你想搜”列间距应增大到 16/20vp。
    it('should_set_guess_like_column_gap_on_lg_xl', Level.LEVEL1, async (done: Function) => {
      try {
        await openFullSearchPage(driver);
        const rects = await getBoundsListByIds(driver, GUESS_LIKE_ITEM_IDS);
        expect(rects.length).assertLarger(1);
        expectGapNear(rects[0], rects[1], breakpoint === 'lg' ? 16 : 20);
      } catch (e) {
        console.error('should_set_guess_like_column_gap_on_lg_xl error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })
  })
}
