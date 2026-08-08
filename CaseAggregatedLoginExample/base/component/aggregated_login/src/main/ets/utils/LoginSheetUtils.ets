import { LoginChannelType } from '../common/Constant';
import { Channel, LoginFailError, PrivacyContent } from '../model/Index';
import { PopViewUtils } from './PopViewUtils';
import { LoginController, ApiController } from './Utils';

@Builder
function loginSheetBuilder(params: LoginInfoOptions) {
  loginSheet({ params })
}

@ComponentV2
export struct loginSheet {
  @Param params: LoginInfoOptions = new LoginInfoOptions();
  @Local sheetStack: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    this.sheetStack.pushPathByName('AggregatedLoginPage', this.params as LoginInfoOptions,
      undefined,
      true,
    );
  }

  build() {
    Navigation(this.sheetStack) {

    }
    .hideNavBar(true)
    .hideTitleBar(true)
  }
}

@ObservedV2
export class LoginInfoOptions {
  @Trace routerModule?: NavPathStack = new NavPathStack()
  @Trace icon: ResourceStr = '';
  @Trace themeColor: ResourceColor = '#0A59F7';
  @Trace isSheet: boolean = true
  @Trace autoSheet: boolean = true
  @Trace isPersistence: boolean = false
  @Trace loginTypes: Channel[] = [];
  @Trace privacyContent: PrivacyContent[] = []
  @Trace apiController: ApiController = new ApiController(
    () => new Promise(() => {
    }), () => new Promise(() => {
  }), () => new Promise(() => {
  })
  )
  @Trace loginController: LoginController = new LoginController();
  handleLoginFail: (loginChannelType: LoginChannelType, error: LoginFailError) => void = () => {
  }
  obtainVerifyCode: () => Promise<void> = () => new Promise(() => {
  });
}

/**
 * 统一登录半模态弹窗
 */
export class LoginSheetUtils {
  static open(uiContext: UIContext, params: LoginInfoOptions) {
    PopViewUtils.showSheet(uiContext, wrapBuilder(loginSheetBuilder), {
      showClose: true,
      backgroundColor: $r('sys.color.background_secondary'),
      dragBar: true,
    }, params);
  }

  static close() {
    PopViewUtils.closeSheet()
  }
}
