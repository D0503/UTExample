import { AvoidArea, CommonConstants, DateUtil, GlobalInfoModel, Title } from '@ohos_agcit/children_education_utils';
import { User } from '@ohos_agcit/children_education_datasource';
import { ApiHandler, DataType, GenderType, PersonalInfo, PersonalInfoView, SwitchInfo } from 'collect_personal_info';
import { emitter } from '@kit.BasicServicesKit';
import { AppStorageV2 } from '@kit.ArkUI';

@Builder
export function PersonalInformationBuilder() {
  PersonalInformationPage();
}

@ComponentV2
export struct PersonalInformationPage {
  @Consumer(CommonConstants.USER_INFO) user: User = new User();
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;
  @Local switchInfo: SwitchInfo = {
    showAvatar: true,
    showNickName: true,
    showFullName: true,
    showGender: true,
    showBirthDate: true,
    showPhoneNumber: true,
    showIntroDesc: false,
  };
  @Local personalInfo: PersonalInfo = {};
  @Local apiInfo: ApiHandler = {
    updateAvatar: (param: Object) => new Promise((resolve) => resolve()),
    updateNickName: (param: Object) => new Promise((resolve) => resolve()),
    updateGender: (param: Object) => new Promise((resolve) => resolve()),
    updateBirth: (param: Object) => new Promise((resolve) => resolve()),
    updateFullName: (param: Object) => new Promise((resolve) => resolve()),
    updateIntro: (param: Object) => new Promise((resolve) => resolve()),
    updatePhoneInfo: {
      codeLength: 6,
      sendCode: (phone: string) => {
        return new Promise((resolve, reject) => {
          setTimeout(() => {
            resolve()
          }, 1000)
        })
      },
      verifyCode: (phone: string, code: string) => {
        return new Promise((resolve, reject) => {
          setTimeout(() => {
            resolve()
          }, 1000)
        })
      },
    },
  };

  aboutToAppear(): void {
    this.personalInfo = toPersonalInfo(this.user)
  }

  build() {
    NavDestination() {
      Column() {
        PersonalInfoView({
          switchInfo: this.switchInfo,
          personalInfo: this.personalInfo,
          apiInfo: this.apiInfo,
          onChange: (type: DataType, data: PersonalInfo) => {
            let userInfo: emitter.EventData = {
              data: {
                isLogin: true,
                userName: data.nickName,
                fullName: data.fullName,
                avatarUrl: data.avatar,
                phone: data.phoneNumber,
                gender: data.gender === GenderType.MALE ? 0 : data.gender === GenderType.FEMALE ? 1 : 2,
                birthDate: DateUtil.getFormatDateStr(data.birthDate as Date, 'yyyy-MM-dd'),
                introDesc: data.introDesc
              },
            };
            emitter.emit(CommonConstants.USER_INFO, userInfo);
          },
        })
      }
      .backgroundColor($r('sys.color.background_secondary'))
      .height('100%')
      .padding({
        top: 16,
        left: 16,
        right: 16,
      });
    }
    .title(Title($r('app.string.personalInformation')))
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({
      top: this.getUIContext().px2vp(this.avoidArea.topRectHeight),
    })
    .onReady(() => {

    })
    .onBackPressed(() => {
      this.globalInfo.navStack.pop();
      return true;
    })
  }
}

function toPersonalInfo(user: User): PersonalInfo {
  return {
    avatar: user.userAvatar,
    nickName: user.userName,
    fullName: user.fullName,
    gender: user.gender === 0 ? GenderType.MALE : user.gender === 1 ? GenderType.FEMALE : GenderType.CONFIDENTIALITY,
    birthDate: new Date(user.birthDate),
    phoneNumber: user.phone,
    introDesc: user.introDesc
  }
}