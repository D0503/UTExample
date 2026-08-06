import { window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

@ObservedV2
export class WindowModel {
  logTag: string = 'WindowModel';
  domainId: number = 0x0000;
  @Trace windowBottomPadding: number = 0;
  /**
   * 获取底部避让区域高度
   */
  public getWindowBottomPadding: (uiContext: UIContext) => void = (uiContext: UIContext): void => {
    window.getLastWindow(uiContext.getHostContext()).then(currentWindow => {
      try {
        const area = currentWindow.getWindowAvoidArea(
          window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR
        );
        this.windowBottomPadding = uiContext.px2vp(area.bottomRect.height);
      } catch (error) {
      }
    }).catch((error: BusinessError) => {
      hilog.error(this.domainId, this.logTag,
        `Error occurred. errCode is ${error.code}, errMessage is ${error.message}`);
    })
  }

  /**
   * 监听底部避让区域变化
   */
  public registerWindowBottomPadding(uiContext: UIContext) {
    this.getWindowBottomPadding(uiContext);
    window.getLastWindow(uiContext.getHostContext()).then(currentWindow => {
      currentWindow.on('avoidAreaChange', () => {
        this.getWindowBottomPadding(uiContext)
      });
    }).catch((error: BusinessError) => {
      hilog.error(this.domainId, this.logTag,
        `Error occurred. errCode is ${error.code}, errMessage is ${error.message}`);
    })
  }

  /**
   * 取消监听底部避让区域变化
   */
  public unRegisterWindowBottomPadding(uiContext: UIContext) {
    window.getLastWindow(uiContext.getHostContext()).then(currentWindow => {
      currentWindow.off('avoidAreaChange', () => {
        this.getWindowBottomPadding(uiContext)
      });
    }).catch((error: BusinessError) => {
      hilog.error(this.domainId, this.logTag,
        `Error occurred. errCode is ${error.code}, errMessage is ${error.message}`);
    })
  }

  /**
   * 注册监听键盘区域变化
   */
  public registerKeyboardListener(uiContext: UIContext, callback: Callback<number>) {
    window.getLastWindow(uiContext.getHostContext()).then(currentWindow => {
      try {
        const keyboardH = currentWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_KEYBOARD).bottomRect.height;
        callback(keyboardH);
      } catch (error) {
      }
      currentWindow.on('keyboardHeightChange', callback);
    }).catch((error: BusinessError) => {
      hilog.error(this.domainId, this.logTag,
        `Error occurred. errCode is ${error.code}, errMessage is ${error.message}`);
    })
  }

  /**
   * 取消注册监听键盘区域变化
   */
  public unRegisterKeyboardListener(uiContext: UIContext, callback: Callback<number>) {
    window.getLastWindow(uiContext.getHostContext()).then(currentWindow => {
      currentWindow.off('keyboardHeightChange', callback);
    }).catch((error: BusinessError) => {
      hilog.error(this.domainId, this.logTag,
        `Error occurred. errCode is ${error.code}, errMessage is ${error.message}`);
    })
  }
}
