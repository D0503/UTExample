import { AggregatedLogin, LoginInfoOptions } from 'aggregated_login';

@Builder
export function LoginPageBuilder(): void {
  LoginPage();
}

@ComponentV2
struct LoginPage {
  @Local options: LoginInfoOptions = new LoginInfoOptions();
  @Local navPathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      AggregatedLogin({
        routerModule: this.navPathStack,
        icon: this.options.icon,
        themeColor: this.options.themeColor,
        isSheet: false,
        autoSheet: this.options.autoSheet,
        isPersistence: this.options.isPersistence,
        loginTypes: this.options.loginTypes,
        privacyContent: this.options.privacyContent,
        apiController: this.options.apiController,
        handleLoginFail: this.options.handleLoginFail,
        obtainVerifyCode: this.options.obtainVerifyCode,
        loginController: this.options.loginController
      });
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.navPathStack = context.pathStack;
      this.options = context.pathInfo.param as LoginInfoOptions;
    })
  }
}
