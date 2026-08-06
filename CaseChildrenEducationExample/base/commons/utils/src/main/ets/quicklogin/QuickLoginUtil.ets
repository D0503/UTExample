import { authentication } from '@kit.AccountKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

export class QuickLoginUtil {
  static logTag: string = 'QuickLoginUtil';
  static domainId: number = 0x0000;

  // Obtain the anonymous mobile number.
  static getQuickLoginAnonymousPhone(uiContext: UIContext, appPathStack: NavPathStack) {
    // Create an authorization request.
    const authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
    // User information requested by the app.
    authRequest.scopes = ['quickLoginAnonymousPhone'];
    // In the one-tap sign-in scenario, forceAuthorization must be set to false.
    authRequest.forceAuthorization = false;
    const controller = new authentication.AuthenticationController();
    try {
      controller.executeRequest(authRequest).then((response: authentication.AuthorizationWithHuaweiIDResponse) => {
        // Obtain the UnionID, OpenID, and anonymous mobile number.
        const unionID = response.data?.unionID;
        const openID = response.data?.openID;
        const quickLoginAnonymousPhone = response.data?.extraInfo?.quickLoginAnonymousPhone as string;
        AppStorage.setOrCreate('quickLoginAnonymousPhone', quickLoginAnonymousPhone);
        QuickLoginUtil.jumpLoginPage(quickLoginAnonymousPhone, appPathStack);
        hilog.info(QuickLoginUtil.domainId, QuickLoginUtil.logTag,
          `Succeeded in authorizing. QuickLoginAnonymousPhone is ${quickLoginAnonymousPhone}`);
      }).catch((error: BusinessError) => {
        hilog.error(QuickLoginUtil.domainId, QuickLoginUtil.logTag,
          `Error occurred. errCode is ${error.code}, errMessage is ${error.message}`);
        uiContext.getPromptAction().showToast({
          message: '获取匿名手机号失败，使用mock登录'
        })
        const quickLoginAnonymousPhone = 'a00****0000';
        AppStorage.setOrCreate('quickLoginAnonymousPhone', quickLoginAnonymousPhone);
        QuickLoginUtil.jumpLoginPage(quickLoginAnonymousPhone, appPathStack);
        // dealAllError(error);
        // showToast(error);
      });
    } catch (error) {
      hilog.error(QuickLoginUtil.domainId, QuickLoginUtil.logTag,
        `Error occurred. errCode is ${error.code}, errMessage is ${error.message}`);
    }
  }

  // Redirect to another page.
  private static jumpLoginPage(quickLoginAnonymousPhone: string, appPathStack: NavPathStack) {
    if (quickLoginAnonymousPhone) {
      // Obtain the anonymous mobile number, pass it, and redirect to the one-tap sign-in screen.
      const params: Record<string, Object> = { 'anonymousPhone': quickLoginAnonymousPhone };
      appPathStack.pushPathByName('QuickLoginPage', params, true);
    } else {
      // If the anonymous mobile number cannot be obtained, an error message is displayed.
    }
  }
}