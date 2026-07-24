import { afterAll, beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver } from '@kit.TestKit';
import { JSON } from '@kit.ArkTS';
import {
  GUESS_LIKE_ITEM_IDS,
  getBoundsById,
  getBoundsListByIds,
  startAbility,
} from '../common/TestHelper';
import { expectBreakpointIn, getWindowBounds } from '../common/DeviceHelper';
import { expectGapNear, expectHorizontalMarginNear } from '../common/LayoutAssertHelper';
import { openFullSearchPage } from '../common/SearchActionHelper';

// 方法说明：手机 sm 间距 PassToPass，保护直板机边距和结果列表密度不退化。
export default function spacingSmPassToPassTest() {
  describe('SpacingSmPassToPassTest', () => {
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

    // 用例说明：sm 断点页面左右边距应保持 16vp。
    it('should_keep_page_margin_16vp_on_sm', Level.LEVEL1, async (done: Function) => {
      try {
        await openFullSearchPage(driver);
        const windowRect = await getWindowBounds(driver, bundleName);
        const historySection = await getBoundsById(driver, 'history-section');
        expectHorizontalMarginNear(windowRect, historySection, 16);

      } catch (e) {
        console.error('should_keep_page_margin_16vp_on_sm error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })

    // 用例说明：sm 断点“猜你想搜”列间距应保持手机 8vp。
    it('should_keep_guess_like_column_gap_8vp_on_sm', Level.LEVEL1, async (done: Function) => {
      try {
        await openFullSearchPage(driver);
        const rects = await getBoundsListByIds(driver, GUESS_LIKE_ITEM_IDS);
        expect(rects.length).assertLarger(1);
        expectGapNear(rects[0], rects[1], 8);
      } catch (e) {
        console.error('should_keep_guess_like_column_gap_8vp_on_sm error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })
  })
}
