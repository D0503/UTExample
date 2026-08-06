import { DataGenerator, VideoCard } from '@ohos_agcit/children_education_datasource';
import {
  AvoidArea,
  CommonConstants,
  GlobalInfoModel,
  StandardCardComponent,
  Title
} from '@ohos_agcit/children_education_utils';
import { AppStorageV2 } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

@Builder
export function HotAnimationBuilder() {
  HotAnimationListView();
}


@ComponentV2
struct HotAnimationListView {
  @Local title: string = '';
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;
  private hotAnimationArray: Array<VideoCard> = [];

  aboutToAppear(): void {
    const uiContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.hotAnimationArray = DataGenerator.getHotAnimationData(uiContext);
  }

  build() {
    NavDestination() {
      Column() {
        StandardCardComponent({
          videoArray: this.hotAnimationArray
        })
      }
      .id('hot-animation-more-content')
      .width(CommonConstants.FULL_PERCENT)
      .padding({
        left: 16,
        right: 16
      })
    }
    .padding({
      top: this.getUIContext().px2vp(this.avoidArea.topRectHeight),
      bottom: this.getUIContext().px2vp(this.avoidArea.bottomRectHeight),
    })
    .title(Title(this.title))
    .onReady((cxt: NavDestinationContext) => {
      this.title = cxt.pathInfo.param as string
    })
    .onBackPressed(() => {
      this.globalInfo.navStack.pop();
      return true;
    });
  }
}
