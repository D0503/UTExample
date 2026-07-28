import { abilityDelegatorRegistry, TestRunner } from '@kit.TestKit';
import { UIAbility } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'Sdl2TestRunner';
const DOMAIN: number = 0x0000;
const UNLOCK_ERROR: number = -3;

let delegator: abilityDelegatorRegistry.AbilityDelegator;

async function onAbilityCreate(data: UIAbility): Promise<void> {
  hilog.info(DOMAIN, TAG, 'TestAbility created: %{public}s', JSON.stringify(data));
}

async function onMonitorAdded(error: BusinessError): Promise<void> {
  if (error) {
    hilog.error(DOMAIN, TAG, 'addAbilityMonitor failed: %{public}s', JSON.stringify(error));
  }
}

export default class OpenHarmonyTestRunner implements TestRunner {
  onPrepare(): void {
    hilog.info(DOMAIN, TAG, 'OpenHarmonyTestRunner onPrepare');
  }

  async onRun(): Promise<void> {
    const argumentsValue = abilityDelegatorRegistry.getArguments();
    delegator = abilityDelegatorRegistry.getAbilityDelegator();
    const moduleName: string = argumentsValue.parameters['-m'];
    const bundleName: string = argumentsValue.bundleName;
    const abilityName: string = 'TestAbility';
    const isDebug: boolean = argumentsValue.parameters['-D'] === 'true';
    const monitor: abilityDelegatorRegistry.AbilityMonitor = {
      abilityName,
      moduleName,
      onAbilityCreate
    };
    delegator.addAbilityMonitor(monitor, onMonitorAdded);

    let command: string = `aa start -b ${bundleName} -a ${abilityName} -m ${moduleName}`;
    if (isDebug) {
      command += ' -D';
    }
    try {
      const result = await delegator.executeShellCommand(command);
      if (result.stdResult.includes('error: unlock screen failed in developer mode') ||
        result.stdResult.includes('10106102')) {
        delegator.finishTest(result.stdResult, UNLOCK_ERROR, () => {
        });
      }
    } catch (error) {
      hilog.error(DOMAIN, TAG, 'start TestAbility failed: %{public}s', JSON.stringify(error));
      delegator.finishTest(JSON.stringify(error), UNLOCK_ERROR, () => {
      });
    }
  }
}
