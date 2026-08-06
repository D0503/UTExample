import {
  CommonConstants,
  GlobalInfoModel,
  QuickLoginUtil,
  rightArrow,
  StringUtil
} from '@ohos_agcit/children_education_utils';
import { User, VipRecord } from '@ohos_agcit/children_education_datasource';
import { AppStorageV2 } from '@kit.ArkUI';

@ComponentV2
export struct LoginState {
  logTag: string = 'LoginState';
  domainId: number = 0x0000;
  @Consumer(CommonConstants.VIP_RECORD) vipRecord: VipRecord = new VipRecord();
  @Consumer(CommonConstants.USER_INFO) user: User = new User();
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;

  build() {
    Column() {
      Row() {
        Row() {
          Image(this.user.isLogin && StringUtil.isNotEmpty(this.user.userAvatar) ? this.user.userAvatar :
            $r('app.media.avatar'))
            .width(48)
            .height(48)
            .borderRadius(100)

          Column() {
            if (this.user.isLogin) {
              Row() {
                Text(this.user.userName)
                  .titleStyle()

                Image(this.vipRecord.isVip ? $r('app.media.mine_vip_yes') : $r('app.media.mine_vip_no'))
                  .width(16)
                  .height(16)
                  .margin({ left: 8 })

                Text('会员')
                  .fontSize(12)
                  .lineHeight(16)
                  .fontColor(this.vipRecord.isVip ? $r('sys.color.font_primary') : 'rgba(0,0,0,0.4)')
                  .fontWeight(FontWeight.Regular)
                  .margin({ left: 2 })
              }
              .width(122)
              .height(24)
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Start)

              Row() {
                Image($r('app.media.mine_phone'))
                  .width(16)
                  .height(16)

                Text(this.user.phone)
                  .fontSize(12)
                  .lineHeight(16)
                  .fontColor('rgba(0,0,0,0.6)')
              }
              .width(93)
              .height(16)
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.SpaceBetween)
            } else {
              Text('点击登录')
                .titleStyle()
            }

          }
          .justifyContent(this.user.isLogin ? FlexAlign.SpaceBetween : FlexAlign.Center)
          .alignItems(HorizontalAlign.Start)
          .height(44)
          .width(122)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .height(48)
        .width(186)

        Blank()

        rightArrow()
      }
      .height(72)
      .width(CommonConstants.FULL_PERCENT)
      .onClick(() => {
        if (this.user.isLogin) {
          this.globalInfo.navStack.pushPathByName('PersonalInformation', undefined);
        } else {
          QuickLoginUtil.getQuickLoginAnonymousPhone(this.getUIContext(), this.globalInfo.navStack)
        }
      })

      if (this.user.isLogin) {
        Divider()

        Row() {
          Text(this.vipRecord.isVip ? '请查看您的会员权益' : '开通VIP后享受更多服务')
            .fontSize(14)
            .lineHeight(19)
            .height(20)
            .fontColor($r('sys.color.font_primary'))
          Button('会员中心')
            .backgroundColor('#D3B685')
            .fontColor($r('sys.color.font_primary'))
            .fontSize($r('sys.float.Body_M'))
            .width(90)
            .height(28)
            .onClick(() => {
              this.globalInfo.navStack.pushPathByName('MemberShipCenterPage', undefined);
            });
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .height(56)
        .width(CommonConstants.FULL_PERCENT)
      }
    }
    .height(this.user.isLogin ? 128 : 72)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .borderRadius(16)
    .padding({ left: 12, right: 12 })
    .width(CommonConstants.FULL_PERCENT);
  }
}

@Extend(Text)
function titleStyle() {
  .fontSize(18)
  .lineHeight(24)
  .fontWeight(FontWeight.Medium)
  .fontColor($r('sys.color.font_primary'))
  .maxLines(1)
}
