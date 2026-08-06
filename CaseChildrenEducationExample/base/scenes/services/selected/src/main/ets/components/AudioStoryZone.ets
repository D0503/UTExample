import { DataGenerator, VideoCard, VideoCollection } from '@ohos_agcit/children_education_datasource';
import {
  CommonConstants,
  GlobalInfoModel,
  VideoCover
} from '@ohos_agcit/children_education_utils';
import { AppStorageV2 } from '@kit.ArkUI';

@ComponentV2
export struct AudioStoryZone {
  @Param audioStoryArray: Array<VideoCard> = [];
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;

  build() {
    Grid() {
      ForEach(this.audioStoryArray, (item: VideoCard, index: number) => {
        GridItem() {
          VideoCover({
            imageUrl: item.imageUrl,
            isVip: item.isVip,
            updateCount: item.updateCount,
            totalCount: item.totalCount,
            ratio: 1
          })
        }
        .id(`audio-story-item-${index}`)
        .aspectRatio(1)
        .onClick(() => {
          let detail: VideoCollection = DataGenerator.getAudioDetail(this.getUIContext());
          detail.videoCard = item;
          this.globalInfo.navStack.pushPathByName('AudioDetailListView', detail);
        });
      }, (item: VideoCard) => JSON.stringify(item));
    }
    .rowsGap(8)
    .columnsGap(8)
    .columnsTemplate('1fr '.repeat(3))
    .width(CommonConstants.FULL_PERCENT)
  }
}
