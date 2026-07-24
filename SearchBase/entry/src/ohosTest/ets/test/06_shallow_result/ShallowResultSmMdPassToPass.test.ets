import { afterAll, beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver } from '@kit.TestKit';
import { JSON } from '@kit.ArkTS';
import {
  expectComponentAbsent,
  expectVisible,
  getBoundsById,
  SEARCH_RESULT_ITEM_IDS,
  setShallowWindowParam,
  startAbility,
} from '../common/TestHelper';
import { expectBreakpointIn } from '../common/DeviceHelper';
import { focusSearchInput, openResultState } from '../common/SearchActionHelper';

// 方法说明：浅层窗口结果页 sm/md PassToPass，保护小断点结果页仍按完整页逻辑展示。
export default function shallowResultSmMdPassToPassTest() {
  describe('ShallowResultSmMdPassToPassTest', () => {
    let driver: Driver;
    let bundleName: string;

    beforeAll(async () => {
      driver = Driver.create();
      bundleName = abilityDelegatorRegistry.getArguments().bundleName;
      setShallowWindowParam(true);
      await startAbility(driver, bundleName, 'EntryAbility');
      await expectBreakpointIn(driver, bundleName, ['sm', 'md']);
      await openResultState(driver);
    })

    afterAll(async () => {
      setShallowWindowParam(false);
      await driver.waitForIdle(2000, 3000);
    })

    // 用例说明：sm/md 断点结果页搜索栏获焦后仍停留完整结果页，不展示浅层首页或联想内容。
    it('should_not_open_result_popup_on_sm_md', Level.LEVEL1, async (done: Function) => {
      try {
        await focusSearchInput(driver);
        expectVisible(await getBoundsById(driver, SEARCH_RESULT_ITEM_IDS[0]));
        await expectComponentAbsent(driver, 'history-section');
        await expectComponentAbsent(driver, 'guess-like-section');
        await expectComponentAbsent(driver, 'hot-search-section');
        await expectComponentAbsent(driver, 'autocomplete-section');
      } catch (e) {
        console.error('should_not_open_result_popup_on_sm_md error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })
  })
}
