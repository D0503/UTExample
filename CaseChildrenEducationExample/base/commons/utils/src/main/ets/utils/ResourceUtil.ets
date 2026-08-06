import { hilog } from '@kit.PerformanceAnalysisKit';

export class ResourceUtil {
  private static logTag: string = 'SettingsPage';
  private static domainId: number = 0x0000;

  static getString(uiContext: UIContext, resName: string): string {
    try {
      return uiContext.getHostContext()!.resourceManager.getStringByNameSync(resName)
    } catch (error) {
      hilog.error(ResourceUtil.domainId, ResourceUtil.logTag,
        `Load url fail. errCode is ${error.code}, errMessage is ${error.message}`);
      return ''
    }
  }
}