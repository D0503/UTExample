import { Channel, NavParam } from '../model/Index';
import { Constants, LoginType } from '../common/Constant';
import { AggregatedLoginVM } from '../viewmodel/AggregatedLoginVM';
import { AgreePrivacyBox } from './AgreePrivacyBox';

@Builder
export function OtherLoginPageBuilder() {
  OtherLoginPage()
}

@ComponentV2
export struct OtherLoginPage {
  vm: AggregatedLoginVM = AggregatedLoginVM.getInstance(false);
  @Local routerModule: NavPathStack = new NavPathStack();
  pageParam: NavParam = new NavParam();

  aboutToAppear(): void {
    this.vm.registerOnWXRespCallback();
  }

  aboutToDisappear(): void {
    this.vm.unregisterOnWXRespCallback();
  }

  @Builder
  coreInfo() {
    Column() {
      Column() {
        if (this.pageParam.isSheet) {
          Column().height(Constants.SHEET_TITLE_H)
        } else {
          Column()
            .layoutWeight(1)
            .constraintSize({
              minHeight: Constants.MIN_HEIGHT_8
            })
        }

        Image(this.pageParam.icon)
          .width(Constants.ICON_WIDTH)
          .height(Constants.ICON_HEIGHT)
          .draggable(false)
          .copyOption(CopyOptions.None)

        TextInput({
          placeholder: $r('app.string.mobile_number'),
          text: this.pageParam.isPersistence ? this.vm.persistenceData.phoneNumber : this.vm.phoneNum
        })
          .id('phone-input')
          .width(Constants.FULL_PERCENT)
          .height(Constants.INPUT_HEIGHT)
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.font_primary'))
          .borderRadius($r('app.float.radius_20'))
          .backgroundColor($r('sys.color.background_primary'))
          .placeholderColor($r('sys.color.font_secondary'))
          .placeholderFont({ size: $r('sys.float.Body_L') })
          .onChange((value) => {
            if (this.pageParam.isPersistence) {
              this.vm.persistenceData.phoneNumber = value
            } else {
              this.vm.phoneNum = value
            }
          })
          .margin({ top: Constants.CONTENT_MARGIN_TOP })
          .padding({
            top: Constants.PADDING_INPUT,
            bottom: Constants.PADDING_INPUT,
            left: Constants.PADDING_L,
            right: Constants.PADDING_L
          })

        Stack({ alignContent: Alignment.End }) {
          TextInput({ text: $$this.vm.verifyCode, placeholder: $r('app.string.verification_code') })
            .layoutWeight(1)
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_primary'))
            .backgroundColor(Color.Transparent)
            .placeholderColor($r('sys.color.font_secondary'))
            .placeholderFont({ size: $r('sys.float.Body_L') })
            .onChange((value) => this.vm.verifyCode = value)
            .textAlign(TextAlign.Start)
            .padding({
              top: Constants.PADDING_INPUT,
              bottom: Constants.PADDING_INPUT,
              left: Constants.PADDING_L,
              right: Constants.PADDING_L
            })

          if (this.vm.verifyCodeTime === 0) {
            Text($r('app.string.obtaining_verification_code'))
              .fontColor($r('sys.color.warning'))
              .fontSize($r('sys.float.Body_L'))
              .textAlign(TextAlign.End)
              .padding({ right: Constants.PADDING_L })
              .onClick(() => {
                this.vm.getVerifyCode()
              });
          } else {
            Row() {
              Text(`${this.vm.verifyCodeTime}`)
                .fontColor($r('sys.color.warning'))
                .fontSize($r('sys.float.Body_L'))
              Text($r('app.string.obtain_in_seconds'))
                .fontColor($r('sys.color.warning'))
                .fontSize($r('sys.float.Body_L'))
            }
            .padding({ right: Constants.PADDING_L })
          }
        }
        .id('verify-code-input')
        .width(Constants.FULL_PERCENT)
        .height(Constants.INPUT_HEIGHT)
        .backgroundColor($r('sys.color.background_primary'))
        .borderRadius($r('app.float.radius_20'))
        .margin({
          top: Constants.PADDING_M,
        })

        Button() {
          Row({ space: Constants.SPACE_S }) {
            LoadingProgress()
              .width(Constants.BACK_WIDTH)
              .aspectRatio(1)
              .color($r('sys.color.icon_on_primary'))
              .visibility(this.vm.isLoading ? Visibility.Visible : Visibility.None)
            Text($r('app.string.login'))
              .fontSize($r('sys.float.Body_L'))
              .fontColor($r('sys.color.font_on_primary'))
              .fontWeight(FontWeight.Medium)
          }
        }
        .id('verify-login-button')
        .width(Constants.FULL_PERCENT)
        .height(Constants.BTN_HEIGHT)
        .backgroundColor(this.pageParam.themeColor)
        .fontColor($r('sys.color.font_on_primary'))
        .margin({ top: Constants.LOGIN_MARGIN_TOP })
        .enabled(!this.vm.isLoading)
        .onClick(() => {
          this.vm.clickLogInButton()
        })

        Text($r('app.string.login_in_other'))
          .height(Constants.TEXT_HEIGHT)
          .fontSize($r('app.float.fontsize_12'))
          .fontColor($r('sys.color.font_tertiary'))
          .margin({ top: Constants.BTN_HEIGHT })

        Row({ space: Constants.ROW_SPACE }) {
          Column({ space: Constants.PADDING_S }) {
            Image($r('app.media.huawei_count'))
              .width(Constants.IMAGE_WIDTH)
              .height(Constants.IMAGE_HEIGHT)
              .objectFit(ImageFit.Cover);
            Text($r('app.string.quickly_login'))
              .fontSize($r('app.float.fontsize_10'))
              .fontColor($r('sys.color.font_tertiary'))
          }
          .width(Constants.COMB_WIDTH)
          .onClick(() => {
            this.routerModule.pop();
          })

          ForEach(this.pageParam.loginTypes, (item: Channel) => {
            Column({ space: Constants.PADDING_S }) {
              Image(item.icon)
                .width(Constants.IMAGE_WIDTH)
                .height(Constants.IMAGE_HEIGHT)
                .objectFit(ImageFit.Cover);
              Text(item.name)
                .fontSize($r('app.float.fontsize_10'))
                .fontColor($r('sys.color.font_tertiary'))
            }
            .width(Constants.COMB_WIDTH)
            .onClick(() => {
              if (item.type === LoginType.WECHAT) {
                this.vm.wechatLogin(item.extraInfo);
              }
            })
          }, (item: Channel) => item.name)
        }
        .margin({ top: Constants.PADDING_M })

        Column().layoutWeight(3)
	  .constraintSize({ minHeight: Constants.MIN_HEIGHT_12 })
      }
      .layoutWeight(1)

      AgreePrivacyBox({
        themeColor: this.pageParam.themeColor,
        privacyContent: this.pageParam.privacyContent,
        routerModule: this.routerModule,
        isSheet: this.pageParam.isSheet,
      })
        .height(Constants.SHEET_TITLE_H)
        .width(Constants.FULL_PERCENT)
        .padding({
          top: Constants.PADDING_M,
          bottom: Constants.PADDING_M,
        })
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .alignItems(HorizontalAlign.Center)
    .padding({
      left: Constants.PADDING_L, right: Constants.PADDING_L
    })
    .layoutWeight(1)
  }

  build() {
    NavDestination() {
      Column() {
        if (!this.pageParam.isSheet) {
          Row() {
            Button({ type: ButtonType.Circle }) {
              SymbolGlyph($r('sys.symbol.chevron_backward'))
                .fontColor([$r('sys.color.icon_primary')])
                .fontSize(Constants.BACK_WIDTH)
            }
            .width(Constants.BACK_BACKGROUND_WIDTH)
            .height(Constants.BACK_BACKGROUND_HEIGHT)
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .onClick(() => {
              this.routerModule.pop();
            })
          }
          .padding({ left: Constants.PADDING_L, right: Constants.PADDING_L })
          .width(Constants.FULL_PERCENT)
          .height(Constants.SHEET_TITLE_H)
        }
        this.coreInfo()
      }
      .height(Constants.FULL_PERCENT)
      .width(Constants.FULL_PERCENT)
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.routerModule = ctx.pathStack;
      this.pageParam = ctx.pathInfo.param as NavParam;
    })
  }
}
