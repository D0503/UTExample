import {
  AuthUtil,
  AvoidArea,
  CommonConstants,
  GlobalInfoModel,
  ResourceUtil
} from '@ohos_agcit/children_education_utils';
import {
  AboutModel,
  SettingGroup,
  SettingItem,
  SettingType,
  SettingView,
  SupportedSetting
} from 'app_setting';
import { userAuth } from '@kit.UserAuthenticationKit';
import { AppStorageV2, CustomContentDialog } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';
import { AuthOptions } from '@ohos_agcit/children_education_utils/src/main/ets/model/AuthOptions';
import { User } from '@ohos_agcit/children_education_datasource';

@Builder
export function SettingsPageBuilder() {
  SettingsPage();
}


@ComponentV2
export struct SettingsPage {
  @Consumer(CommonConstants.USER_INFO) user: User = new User();
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;
  @Local group1: SettingGroup = new SettingGroup()
    .setList([
      new SettingItem()
        .setType(SettingType.ROUTER)
        .setLabel('个人信息')
        .setRouterParam({ routerName: 'PersonalInformation' }),
    ])
  @Local group2: SettingGroup = new SettingGroup()
    .setList([
      new SettingItem()
        .setType(SettingType.ROUTER)
        .setLabel('时长控制')
        .setClickEvent(() => {
          const options: AuthOptions = new AuthOptions();
          options.showTip = true
          options.uiContext = this.getUIContext()

          AuthUtil.onStartEasy(options, (result: userAuth.UserAuthResult) => {
            if (result.result === 12500000) {
              this.globalInfo.navStack.pushPathByName('TimeCtrl', undefined);
            } else if (result.result === 12500010) {
              this.dialogController.open();
              this.globalInfo.navStack.pushPathByName('TimeCtrl', undefined);
            }
          });
        })
    ])
  @Local group3: SettingGroup = new SettingGroup()
    .setList([
      new SettingItem()
        .setSupportedType(SupportedSetting.CLEAR_CACHE),
    ])
  @Local group5: SettingGroup = new SettingGroup()
    .setTitle('了解我们如何使用您的数据')
    .setList([
      new SettingItem()
        .setType(SettingType.ROUTER)
        .setLabel('业务与隐私的声明')
        .setClickEvent(() => {
          let url = ResourceUtil.getString(this.getUIContext(), 'privacyAgreementPath')
          this.globalInfo.navStack.pushPathByName('PrivacyAgreement', url);
        }),
      new SettingItem()
        .setSupportedType(SupportedSetting.WEB)
        .setLabel('第三方共享信息清单')
        .setClickEvent(() => {
          let url = ResourceUtil.getString(this.getUIContext(), 'example_website')
          this.globalInfo.navStack.pushPathByName('PrivacyAgreement', url);
        }),
      new SettingItem()
        .setSupportedType(SupportedSetting.WEB)
        .setLabel('第三方 SDK 列表')
        .setClickEvent(() => {
          let url = ResourceUtil.getString(this.getUIContext(), 'example_website')
          this.globalInfo.navStack.pushPathByName('PrivacyAgreement', url);
        }),
      new SettingItem()
        .setSupportedType(SupportedSetting.WEB)
        .setLabel('已收集个人信息清单')
        .setClickEvent(() => {
          let url = ResourceUtil.getString(this.getUIContext(), 'example_website')
          this.globalInfo.navStack.pushPathByName('PrivacyAgreement', url);
        }),
      new SettingItem()
        .setSupportedType(SupportedSetting.WEB)
        .setLabel('隐私声明摘要')
        .setClickEvent(() => {
          let url = ResourceUtil.getString(this.getUIContext(), 'example_website')
          this.globalInfo.navStack.pushPathByName('PrivacyAgreement', url);
        }),
    ])
  @Local group6: SettingGroup = new SettingGroup()
    .setTitle('更多')
    .setList([
      new SettingItem()
        .setSupportedType(SupportedSetting.CHECK_VERSION),
      new SettingItem()
        .setSupportedType(SupportedSetting.ABOUT)
        .setExtraParams({
          icpText: '苏ICP备17040376号-135A',
          copyrightText: '华为xx 版权所有 © 2019-2025',
          hotline: '00000000',
        } as AboutModel),
      new SettingItem()
        .setSupportedType(SupportedSetting.WEB)
        .setLabel('服务协议与规则')
        .setClickEvent(() => {
          let url = ResourceUtil.getString(this.getUIContext(), 'example_website')
          this.globalInfo.navStack.pushPathByName('PrivacyAgreement', url);
        })
    ])

  build() {
    NavDestination() {
      Column() {
        SettingView({
          pathStack: this.globalInfo.navStack,
          settingList: this.user.isLogin ?
            [this.group1, this.group2, this.group3, this.group5, this.group6] :
            [this.group2, this.group3, this.group5, this.group6],
          themeColor: $r('sys.color.confirm'),
          pagePadding: {
            bottom: 10,
          },
          isLogin: this.user.isLogin,
          signOutApi: () => {
            return new Promise((resolve) => {
              emitter.emit(CommonConstants.USER_INFO, {
                data: {
                  isLogin: false,
                  userName: '点击登录',
                  userAvatar: '',
                  phone: '',
                },
              });

              emitter.emit(CommonConstants.VIP_RECORD, {
                data: {
                  'isVip': false,
                  'validTime': '1970-01-01 00:00:00',
                },
              });

              this.globalInfo.navStack.pop();
              resolve();
            });
          }
        })
      }
      .backgroundColor('#F1F3F5')
      .width('100%')
      .height('100%')
    }
    .title('设置')
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({
      top: this.getUIContext().px2vp(this.avoidArea.topRectHeight),
      bottom: this.getUIContext().px2vp(this.avoidArea.bottomRectHeight),
    })
    .onBackPressed(() => {
      this.globalInfo.navStack.pop();
      return true;
    });
  }

  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomContentDialog({
      primaryTitle: '温馨提示',
      contentBuilder: () => {
        this.buildContent();
      },
      buttons: [
        {
          value: '确定',
          buttonStyle: ButtonStyleMode.TEXTUAL,
          role: ButtonRole.ERROR,
          action: () => {
          },
        },
      ],
    }),
    autoCancel: false,
  });

  @Builder
  buildContent(): void {
    Column() {
      Text('您的手机还未录入指纹、人脸识别、锁屏密码中的一种，建议前往 设置-生物识别和密码 进行添加');
    }
    .width(CommonConstants.FULL_PERCENT);
  }
}
