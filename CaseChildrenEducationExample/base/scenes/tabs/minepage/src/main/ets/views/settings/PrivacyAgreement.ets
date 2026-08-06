import { webview } from '@kit.ArkWeb';
import { CommonConstants, GlobalInfoModel } from '@ohos_agcit/children_education_utils';
import { common } from '@kit.AbilityKit';
import { AppStorageV2 } from '@kit.ArkUI';

@Builder
export function PrivacyAgreementBuilder() {
  PrivacyAgreement();
}

@ComponentV2
export struct PrivacyAgreement {
  topRectHeight: number = 0;
  controller: webview.WebviewController = new webview.WebviewController();
  hostContext: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  @Local privacyAgreementPath : string = '';
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;

  build() {
    NavDestination() {
      Web({ src: this.privacyAgreementPath, controller: this.controller })
        .verticalScrollBarAccess(false)
        .fileAccess(false)
        .geolocationAccess(false)
    }
    .hideTitleBar(true)
    .padding({
      top: this.getUIContext().px2vp(this.topRectHeight+50)
    })
    .onReady((cxt: NavDestinationContext) => {
      let param = cxt.pathInfo.param as string;
      this.privacyAgreementPath = param
    })
    .onBackPressed(() => {
      this.globalInfo.navStack.pop();
      return true;
    })
  }
}