import abilityDelegatorRegistry from "@ohos:app.ability.abilityDelegatorRegistry";
import type TestRunner from "@ohos:application.testRunner";
import { Hypium } from "@package:pkg_modules/.ohpm/@ohos+hypium@1.0.25/pkg_modules/@ohos/hypium/index";
import testsuite from "@bundle:com.thirdparty.validation.libuv.golden/entry_test/ets/test/List.test";
export default class OpenHarmonyTestRunner implements TestRunner {
    onPrepare(): void {
    }
    onRun(): void {
        const delegator = abilityDelegatorRegistry.getAbilityDelegator();
        const argumentsValue = abilityDelegatorRegistry.getArguments();
        Hypium.hypiumTest(delegator, argumentsValue, testsuite);
    }
}
