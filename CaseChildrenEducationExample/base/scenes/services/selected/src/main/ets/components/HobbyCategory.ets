import { DataGenerator, VideoCard, VideoCollection } from '@ohos_agcit/children_education_datasource';
import { CommonConstants, GlobalInfoModel } from '@ohos_agcit/children_education_utils';
import { AppStorageV2 } from '@kit.ArkUI';

@ComponentV2
export struct HobbyCategory {
  @Param @Once @Require hobbyCategory: Array<VideoCard>;
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;

  build() {
    Row() {
      ForEach(this.hobbyCategory, (item: VideoCard, index: number) => {
        if (index === 0) {
          this.hobbyCardBuilder(item, index, $r('app.media.hobby_icon_1'), $r('app.media.hobby_background_1'))
        }
        if (index !== this.hobbyCategory.length - 1) {
          Blank().width(12)
        }
        if (index === 1) {
          this.hobbyCardBuilder(item, index, $r('app.media.hobby_icon_2'), $r('app.media.hobby_background_2'))
        }
      }, (item: VideoCard) => JSON.stringify(item))
    }
    .id('hobby-section')
    .height(64)
  }

  @Builder
  hobbyCardBuilder(card: VideoCard, index: number, image: Resource, background: Resource) {
    Row() {
      Text(card.title)
        .fontSize(16)
        .fontWeight(FontWeight.Medium);

      Image(image)
        .height(48)
        .width(48);
    }
    .id(`hobby-card-${index}`)
    .layoutWeight(0.5)
    .borderRadius(12)
    .backgroundImage(background)
    .backgroundImageSize(ImageSize.FILL)
    .justifyContent(FlexAlign.SpaceBetween)
    .height('100%')
    .padding({
      left: 16,
      right: 16
    })
    .onClick(() => {
      let detail: VideoCollection = DataGenerator.getVideoDetail(this.getUIContext());
      detail.videoCard = card;
      this.globalInfo.navStack.pushPathByName('VideoDetailListView', detail);
    });
  }
}
