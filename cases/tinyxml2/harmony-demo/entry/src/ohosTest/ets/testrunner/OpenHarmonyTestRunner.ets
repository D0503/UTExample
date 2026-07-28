import { abilityDelegatorRegistry, TestRunner } from '@kit.TestKit';
import { Hypium } from '@ohos/hypium';
import testsuite from '../test/List.test';

export default class OpenHarmonyTestRunner implements TestRunner {
  onPrepare(): void {
  }

  onRun(): void {
    const delegator = abilityDelegatorRegistry.getAbilityDelegator();
    const argumentsValue = abilityDelegatorRegistry.getArguments();
    Hypium.hypiumTest(delegator, argumentsValue, testsuite);
  }
}
