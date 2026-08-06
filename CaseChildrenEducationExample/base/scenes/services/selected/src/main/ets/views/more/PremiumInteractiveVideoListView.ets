import { DataGenerator, VideoCard, VideoCollection } from '@ohos_agcit/children_education_datasource';
import {
  AvoidArea,
  CommonConstants,
  GlobalInfoModel,
  TagLabelCard,
  Title,
  VideoCover
} from '@ohos_agcit/children_education_utils';
import { AppStorageV2 } from '@kit.ArkUI';

@Builder
export function PremiumInteractiveVideoListBuilder() {
  PremiumInteractiveVideoListView();
}


@ComponentV2
export struct PremiumInteractiveVideoListView {
  @Local title: string = '';
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;
  private videoArray: Array<VideoCard> = [];

  aboutToAppear(): void {
    this.videoArray = DataGenerator.getPremiumInteractiveVideoData(this.getUIContext());
  }

  build() {
    NavDestination() {
      Grid() {
        ForEach(this.videoArray, (item: VideoCard, index: number) => {
          GridItem() {
            PremiumInteractiveVideoListItem({
              videoCard: item,
            })
          }
          .id(`premium-more-item-${index}`)
        }, (item: VideoCard) => JSON.stringify(item));
      }
      .id('premium-more-content')
      .padding({
        top: 8,
        left: 16,
        right: 17
      })
      .width(CommonConstants.FULL_PERCENT)
      .rowsGap(8)
      .columnsGap(8)
      .columnsTemplate('1fr '.repeat(1))
    }
    .title(Title(this.title))
    .onReady((cxt: NavDestinationContext) => {
      this.title = cxt.pathInfo.param as string
    })
    .onBackPressed(() => {
      this.globalInfo.navStack.pop();
      return true;
    })
    .padding({
      top: this.getUIContext().px2vp(this.avoidArea.topRectHeight),
      bottom: this.getUIContext().px2vp(this.avoidArea.bottomRectHeight),
    })
  }
}


@ComponentV2
struct PremiumInteractiveVideoListItem {
  @Param @Once @Require videoCard: VideoCard;
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;

  build() {
    Column() {
      VideoCover({
        imageUrl: this.videoCard.imageUrl,
        isVip: this.videoCard.isVip,
        updateCount: this.videoCard.updateCount,
        totalCount: this.videoCard.totalCount,
        ratio: 16 / 9
      })
        .onClick(() => {
          let detail: VideoCollection = DataGenerator.getVideoDetail(this.getUIContext());
          detail.videoCard = this.videoCard;
          this.globalInfo.navStack.pushPathByName('VideoDetailListView', detail);
        })

      Blank().height(8)

      Column() {
        Text(this.videoCard.title)
          .fontSize(16)
          .lineHeight(21)
          .width('100%')

        Blank().height(2)

        Row() {
          ForEach(this.videoCard.tags, (item: string) => {
            TagLabelCard(item);
          }, (item: string) => item);
        }
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .width(CommonConstants.FULL_PERCENT)
    }
    .alignItems(HorizontalAlign.Start)
    .borderRadius($r('sys.float.corner_radius_level8'))
    .backgroundColor($r('sys.color.comp_background_list_card'))
  }
}
