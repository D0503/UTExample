import { UIAbility } from '@kit.AbilityKit';
import { UIContext, window } from '@kit.ArkUI';

export default class EntryAbility extends UIAbility {
  private storage: LocalStorage = new LocalStorage();

  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.getMainWindow()
      .then((mainWindow: window.Window) => {
        const windowId: number = mainWindow.getWindowProperties().id;
        this.storage.setOrCreate<UIContext | null>('uiContext', null);
        this.storage.setOrCreate<number>('windowId', windowId);
        return windowStage.loadContent('pages/Index', this.storage)
          .then(() => {
            const uiContext: UIContext = mainWindow.getUIContext();
            this.storage.setOrCreate<UIContext>('uiContext', uiContext);
          });
      })
      .catch((error: object) => {
        console.error(`Failed to load SDL2 GUI page: ${JSON.stringify(error)}`);
      });
  }
}
