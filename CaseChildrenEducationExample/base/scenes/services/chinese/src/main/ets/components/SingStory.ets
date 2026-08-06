import { DataGenerator, VideoCard, VideoCollection } from '@ohos_agcit/children_education_datasource';
import { CommonConstants, GlobalInfoModel, TagLabelCard } from '@ohos_agcit/children_education_utils';
import { AppStorageV2 } from '@kit.ArkUI';

@ComponentV2
export struct SingStory {
  @Param @Once @Require singStory: Array<VideoCard>;
  @Local textWidth: number = 0;
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;

  build() {
    Grid() {
      ForEach(this.singStory, (item: VideoCard, index: number) => {
        GridItem() {
          Column() {
            Row() {
              Stack({ alignContent: Alignment.TopStart }) {
                Image(item.imageUrl)
                  .height(54)
                  .borderRadius(10)
                  .aspectRatio(16 / 9)
                  .id(CommonConstants.IMAGE);
                Image($r('app.media.icon_vip_top_start'))
                  .width(32)
                  .height(16)
              }

              Column() {
                Text(item.title)
                  .fontWeight(FontWeight.Medium)
                  .fontSize(14)
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .align(Alignment.TopStart);

                Row() {
                  ForEach(item.tags, (tag: string) => {
                    TagLabelCard(tag);
                  }, (tag: string) => tag);
                }
                .align(Alignment.BottomStart);
              }
              .layoutWeight(1)
              .alignSelf(ItemAlign.Center)
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.SpaceBetween)
              .height(56)
              .margin({ left: 10 })
            }
            .width('100%')

            Row() {
              Divider().width('70%')
            }
            .justifyContent(FlexAlign.End)
            .height(16)
            .width('100%')
          }
        }
        .onClick(() => {
          let collection: VideoCollection = {
            videoCard: item,
            videoCardDetailList: DataGenerator.getVideoDetail(this.getUIContext()).videoCardDetailList
          }
          this.globalInfo.navStack.pushPathByName('VideoDetailListView', collection);
        });
      }, (item: VideoCollection) => JSON.stringify(item));
    }
    .width('100%')
    .rowsGap(8)
    .columnsGap(8)
    .columnsTemplate('1fr '.repeat(1))
  }
}