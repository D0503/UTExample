import { afterAll, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver } from '@kit.TestKit';
import { JSON } from '@kit.ArkTS';
import {
  expectComponentAbsent,
  expectVisible,
  getBoundsById,
  setShallowWindowParam,
  startAbility,
} from '../common/TestHelper';
import { expectBreakpointIn } from '../common/DeviceHelper';
import { tapHomeSearchEntry } from '../common/SearchActionHelper';

// 方法说明：浅层窗口首页 sm/md PassToPass，保护小断点仍走完整搜索页逻辑。
export default function shallowHomeSmMdPassToPassTest() {
  describe('ShallowHomeSmMdPassToPassTest', () => {
    let driver: Driver;
    let bundleName: string;

    beforeAll(async () => {
      driver = Driver.create();
      bundleName = abilityDelegatorRegistry.getArguments().bundleName;
      setShallowWindowParam(true);
      await startAbility(driver, bundleName, 'EntryAbility');
    })

    afterAll(async () => {
      setShallowWindowParam(false);
      await driver.waitForIdle(2000, 3000);
    })

    // 用例说明：sm/md 断点点击首页搜索入口应进入完整搜索页，用完整页形态证明未走浅层窗口。
    it('should_not_open_home_popup_on_sm_md', Level.LEVEL1, async (done: Function) => {
      try {
        await expectBreakpointIn(driver, bundleName, ['sm', 'md']);
        await tapHomeSearchEntry(driver);
        const page = await getBoundsById(driver, 'search-result-page');
        expectVisible(page);
        expectVisible(await getBoundsById(driver, 'search-back-button'));
        expectVisible(await getBoundsById(driver, 'search-input'));
        await driver.delayMs(500)
        await expectComponentAbsent(driver, 'search-entry-page');
      } catch (e) {
        console.error('should_not_open_home_popup_on_sm_md error' + JSON.stringify(e));
        expect(false).assertTrue();
      }
      done();
    })
  })
}
