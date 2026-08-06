import { DataGenerator, VideoCard, VideoCollection } from '@ohos_agcit/children_education_datasource';
import {
  AvoidArea,
  CommonConstants,
  GlobalInfoModel,
  Title,
  VideoCover
} from '@ohos_agcit/children_education_utils';
import { AppStorageV2 } from '@kit.ArkUI';

@Builder
export function AudioSectionListBuilder() {
  AudioSectionListView();
}


@ComponentV2
export struct AudioSectionListView {
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;
  private audioList: Array<VideoCard> = [];

  aboutToAppear(): void {
    this.audioList = DataGenerator.getAudioListData(this.getUIContext());
  }

  build() {
    NavDestination() {
      Grid() {
        ForEach(this.audioList, (item: VideoCard) => {
          GridItem() {
            AudioSectionListItem({
              imageUrl: item.imageUrl,
              isVip: item.isVip,
              updateCount: item.updateCount,
              totalCount: item.totalCount,
              title: item.title,
              describe: item.describe,
            })
              .onClick(() => {
                let detail: VideoCollection = DataGenerator.getAudioDetail(this.getUIContext());
                detail.videoCard = item;
                this.globalInfo.navStack.pushPathByName('AudioDetailListView', detail);
              });
          };
        }, (item: VideoCard) => JSON.stringify(item));
      }
      .rowsGap(8)
      .columnsGap(8)
      .columnsTemplate('1fr '.repeat(1))
      .padding({
        left: 16,
        right: 16
      })
      .scrollBar(BarState.Off)
      .width(CommonConstants.FULL_PERCENT)
    }
    .title(Title('音频故事专区'))
    .onBackPressed(() => {
      this.globalInfo.navStack.pop();
      return true;
    })
    .padding({
      top: this.getUIContext().px2vp(this.avoidArea.topRectHeight),
    })
  }
}

@ComponentV2
struct AudioSectionListItem {
  @Param @Require imageUrl: string;
  @Param @Require isVip: boolean;
  @Param @Require updateCount: number;
  @Param @Require totalCount: number;
  @Param @Require title: string;
  @Param @Require describe: string;

  build() {
    Row() {
      Row() {
        VideoCover({
          imageUrl: this.imageUrl,
          isVip: this.isVip,
          updateCount: this.updateCount,
          totalCount: this.totalCount,
          ratio: 1,
        })
      }.width(104)

      Blank().width(12)

      Column() {
        Text(this.title)
          .fontWeight(FontWeight.Medium)
          .fontSize(16);

        Blank().height(4)

        Text(this.describe)
          .fontSize(12)
          .fontColor('#ff817e7e')
          .textAlign(TextAlign.Start)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(3)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
  }
}
