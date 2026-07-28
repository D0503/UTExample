import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';

export default class TestAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage): void {
    try {
      windowStage.loadContent('testability/pages/Index');
    } catch (error) {
      console.error(`Failed to load tinyxml2 test page: ${JSON.stringify(error)}`);
    }
  }
}
