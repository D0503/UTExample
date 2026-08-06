import { bundleManager, common, Want } from '@kit.AbilityKit';
import { LayeredDrawableDescriptor } from '@kit.ArkUI';
import { AppGalleryUtils } from '../common/AppGalleryUtils';
import { TelephoneUtils } from '../common/TelephoneUtils';
import { BaseViewModel } from '../models/BaseViewModel';
import { hilog } from '@kit.PerformanceAnalysisKit';

@ObservedV2
export class SettingAboutVM extends BaseViewModel {
  logTag: string = 'SettingAboutVM';
  domainId: number = 0x0000;
  @Trace appName: string = '';
  @Trace appVersionName: string = '';
  @Trace appIcon: ResourceStr | PixelMap = '';
  @Trace hasNewVersion: boolean = false;
  @Trace updateLabel: string = '检查更新'
  @Trace hotline: string = '000000';
  @Trace loading: boolean = false;
  private uiContext: UIContext;
  private context: common.UIAbilityContext;
  private url: string = '';

  constructor(ctx: UIContext) {
    super();
    this.uiContext = ctx
    this.context = ctx.getHostContext() as common.UIAbilityContext;
    this.getBundleInfo();
    
    try {
      this.url = this.uiContext.getHostContext()!.resourceManager.getStringSync($r('app.string.example_website').id)
    } catch (error) {
      hilog.error(this.domainId, this.logTag,
        `Load url fail. errCode is ${error.code}, errMessage is ${error.message}`);
    }
  }

  async getBundleInfo() {

    try {
      const resource = this.context.resourceManager;
      const bundleInfo =
        await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      // 获取应用名称
      this.appName = resource.getStringSync(bundleInfo.appInfo.labelId);
      // 获取版本信息
      this.appVersionName = bundleInfo.versionName;
      // 获取应用图标
      const draw = resource.getDrawableDescriptor(bundleInfo.appInfo.iconId);
      const isLayered = draw instanceof LayeredDrawableDescriptor;
      if (isLayered) {
        let layered = draw as LayeredDrawableDescriptor;
        this.appIcon = layered.getPixelMap();
      } else {
        this.appIcon = resource.getMediaContentBase64Sync(bundleInfo.appInfo.iconId);
      }
    } catch (error) {
      hilog.error(this.domainId, this.logTag,
        `Error occurred. errCode is ${error.code}, errMessage is ${error.message}`);
    }
  }

  checkUpdate() {
    this.loading = true;
    AppGalleryUtils.checkAppUpdate(this.context).then((resp: boolean) => {
      this.hasNewVersion = resp;
      this.updateLabel = this.hasNewVersion ? '存在新版本' : '已是最新版本';
      if (this.hasNewVersion) {
        AppGalleryUtils.showUpdateDialog(this.context);
      } else {
        try {
          this.uiContext.getPromptAction().showToast({ message: this.updateLabel });
        } catch (error) {
        }
      }
    }).finally(() => {
      this.loading = false;
    })
  }

  callHotline() {
    TelephoneUtils.callPhone(this.hotline);
  }

  goWebsite() {
    let want: Want = {
      action: 'ohos.want.action.viewData',
      entities: ['entity.system.browsable'],
      uri: this.url,
    }
    this.context.startAbility(want).catch((error: BusinessError) => {
      hilog.error(this.domainId, this.logTag,
        `Error occurred. errCode is ${error.code}, errMessage is ${error.message}`);
    });
  }
}
