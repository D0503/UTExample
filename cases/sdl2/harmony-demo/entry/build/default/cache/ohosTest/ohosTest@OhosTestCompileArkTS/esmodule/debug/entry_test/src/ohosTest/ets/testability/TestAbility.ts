import type AbilityConstant from "@ohos:app.ability.AbilityConstant";
import UIAbility from "@ohos:app.ability.UIAbility";
import type Want from "@ohos:app.ability.Want";
import type window from "@ohos:window";
import hilog from "@ohos:hilog";
import abilityDelegatorRegistry from "@ohos:app.ability.abilityDelegatorRegistry";
import { Hypium } from "@package:pkg_modules/.ohpm/@ohos+hypium@1.0.25/pkg_modules/@ohos/hypium/index";
import testsuite from "@bundle:com.thirdparty.validation.sdl2/entry_test/ets/test/List.test";
const TAG: string = 'Sdl2TestAbility';
const DOMAIN: number = 0x0000;
const ON_DESTROY_ERROR: number = -2;
export default class TestAbility extends UIAbility {
    private readonly delegator: abilityDelegatorRegistry.AbilityDelegator;
    constructor() {
        super();
        this.delegator = abilityDelegatorRegistry.getAbilityDelegator();
    }
    onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
        hilog.info(DOMAIN, TAG, 'TestAbility onCreate: %{public}s', JSON.stringify({ want, launchParam }));
        const argumentsValue = abilityDelegatorRegistry.getArguments();
        Hypium.hypiumTest(this.delegator, argumentsValue, testsuite);
    }
    onDestroy(): void {
        this.delegator.finishTest('TestAbility onDestroy unexpectedly', ON_DESTROY_ERROR, () => {
        });
    }
    onWindowStageCreate(windowStage: window.WindowStage): void {
        windowStage.loadContent('testability/pages/Index', (error) => {
            if (error.code) {
                hilog.error(DOMAIN, TAG, 'Failed to load test page: %{public}s', JSON.stringify(error));
            }
        });
    }
}
