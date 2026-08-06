import { window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

/**
 * 窗口持久化
 */
@ObservedV2
export class CustomWindowModel {
  logTag: string = 'CustomWindowModel';
  domainId: number = 0x0000;
  @Trace windowTopPadding: Length | undefined = undefined;
  @Trace windowBottomPadding: Length | undefined = undefined;
  @Trace windowLeftPadding: Length | undefined = undefined;
  @Trace windowRightPadding: Length | undefined = undefined;
  @Trace avoidBottomPadding: Length = 0;

  /**
   * 获取页面左边距
   * @returns
   */
  @Computed
  get pageLeftPadding() {
    if (this.windowLeftPadding !== undefined) {
      return this.windowLeftPadding;
    }
    return 16;
  }

  /**
   * 获取页面右边距
   * @returns
   */
  @Computed
  get pageRightPadding() {
    if (this.windowRightPadding !== undefined) {
      return this.windowRightPadding;
    }
    return 16;
  }

  /**
   * 获取页面下边距
   * @returns
   */
  @Computed
  get pageBottomPadding() {
    if (this.windowBottomPadding !== undefined) {
      return this.windowBottomPadding;
    }
    return this.avoidBottomPadding > 0 ? 0 : 16;
  }

  /**
   * 获取底部避让区域高度
   */
  public getAvoidBottomPadding = (uiContext: UIContext) => {
    window.getLastWindow(uiContext.getHostContext()).then(currentWindow => {
      try {
        const area = currentWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
        this.avoidBottomPadding = uiContext.px2vp(area.bottomRect.height);
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
  public onAvoidAreaChange(uiContext: UIContext) {
    this.getAvoidBottomPadding(uiContext);
    window.getLastWindow(uiContext.getHostContext()).then(currentWindow => {
      currentWindow.on('avoidAreaChange', () => this.getAvoidBottomPadding(uiContext));
    }).catch((error: BusinessError) => {
      hilog.error(this.domainId, this.logTag,
        `Error occurred. errCode is ${error.code}, errMessage is ${error.message}`);
    })
  }

  /**
   * 取消监听底部避让区域变化
   */
  public offAvoidAreaChange(uiContext: UIContext) {
    window.getLastWindow(uiContext.getHostContext()).then(currentWindow => {
      currentWindow.off('avoidAreaChange', () => this.getAvoidBottomPadding(uiContext));
    }).catch((error: BusinessError) => {
      hilog.error(this.domainId, this.logTag,
        `Error occurred. errCode is ${error.code}, errMessage is ${error.message}`);
    })
  }
}
