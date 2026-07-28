import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { abilityDelegatorRegistry } from '@kit.TestKit';
import { Hypium } from '@ohos/hypium';
import testsuite from '../test/List.test';

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
    hilog.info(DOMAIN, TAG, 'TestAbility onCreate: %{public}s',
      JSON.stringify({ want, launchParam }));
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
