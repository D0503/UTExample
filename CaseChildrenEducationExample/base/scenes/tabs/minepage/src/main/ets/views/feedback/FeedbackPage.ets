import { AvoidArea, CommonConstants, GlobalInfoModel, Title } from '@ohos_agcit/children_education_utils';
import { Feedback, FeedbackItemType } from 'feed_back';
import { AppStorageV2 } from '@kit.ArkUI';

@Builder
export function FeedbackBuilder() {
  FeedbackPage();
}

@ComponentV2
export struct FeedbackPage {
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;

  build() {
    NavDestination() {
      Scroll() {
        Feedback({
          des: 100,
          num: 3,
          butOnClick: (val: FeedbackItemType) => {
            this.getUIContext().getPromptAction().showToast({ message: '提交成功', duration: 2000 });
            this.globalInfo.navStack.pop();
          }
        })
      }
    }
    .title(Title('意见反馈'))
    .padding({
      top: this.getUIContext().px2vp(this.avoidArea.topRectHeight),
    })
    .backgroundColor($r('sys.color.background_secondary'))
    .onBackPressed(() => {
      this.globalInfo.navStack.pop();
      return true;
    })
  }
}