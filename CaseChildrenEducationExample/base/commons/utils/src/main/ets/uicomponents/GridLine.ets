import { DataGenerator, VideoCard, VideoCollection } from '@ohos_agcit/children_education_datasource';
import { CommonConstants } from '../constants/CommonConstants';
import { GlobalInfoModel } from '../model/GlobalInfoModel';
import { AppStorageV2 } from '@kit.ArkUI';

import { TagLabelCard } from './TagLabelCard';


@ComponentV2
export struct CompactCardComponent {
  @Param @Once @Require videoCardArray: Array<VideoCard>;
  @Param showVideoType: boolean = false
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;

  build() {
    Grid() {
      ForEach(this.videoCardArray, (item: VideoCard, index: number) => {
        GridItem() {
          Column() {
            Column() {
              Image(item.imageUrl)
                .aspectRatio(1.78)
                .borderRadius(10)
                .id(CommonConstants.IMAGE)
                .zIndex(0);
            }
            .height('auto')
            .width('auto');

            Column({ space: 4 }) {
              Row() {
                if (this.showVideoType) {
                  Text(item.videoType === 0 ? '视频' : '音频')
                    .fontSize(10)
                    .fontColor('#FF783F')
                    .fontWeight(FontWeight.Regular)
                    .lineHeight(13)
                    .border({ width: 1, color: '#FF783F' })
                    .borderRadius(4)
                    .margin({ right: 4 })
                }
                Text(item.title)
                  .textAlign(TextAlign.Start)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
                  .fontSize('14fp')
                  .width(CommonConstants.FULL_PERCENT)
                  .fontWeight(FontWeight.Medium);
              }
              .justifyContent(FlexAlign.Start)

              Text(item.describe)
                .textAlign(TextAlign.Start)
                .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .fontSize('12fp')
                .width(CommonConstants.FULL_PERCENT);
            }
            .padding({ top: '8vp' });
          };
        }
        .onClick(() => {
          let detail: VideoCollection = DataGenerator.getVideoDetail(this.getUIContext());
          detail.videoCard = item;
          this.globalInfo.navStack.pushPathByName('VideoDetailListView', detail);
        });
      }, (item: VideoCard) => JSON.stringify(item));
    }
    .rowsGap(8)
    .columnsGap(8)
    .columnsTemplate('1fr '.repeat(2))
    .width(CommonConstants.FULL_PERCENT)
  }
}

@ComponentV2
export struct StandardCardComponent {
  @Param @Once @Require videoArray: Array<VideoCard>
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;

  build() {
    Grid() {
      ForEach(this.videoArray, (item: VideoCard, index: number) => {
        GridItem() {
          Column() {
            Image(item.imageUrl)
              .borderRadius(12)
              .onClick(() => {
                let detail: VideoCollection = DataGenerator.getVideoDetail(this.getUIContext());
                detail.videoCard = item;
                this.globalInfo.navStack.pushPathByName('VideoDetailListView', detail);
              })

            Row() {
              Text(item.title)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .lineHeight(21)
                .freeze(true)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })

              Blank();
              ForEach(item.tags, (item: string) => {
                TagLabelCard(item);
              }, (item: string) => item);
            }
            .margin({ top: 8 })
            .width(CommonConstants.FULL_PERCENT)
            .justifyContent(FlexAlign.SpaceAround)

            Row() {
              Text(item.describe)
                .fontSize(12)
                .lineHeight(16)
                .fontColor('#ff969191');
            }
            .margin({ top: 2 })
            .width(CommonConstants.FULL_PERCENT)
            .justifyContent(FlexAlign.Start);
          }
        }
      }, (item: VideoCard, index) => JSON.stringify(item) + index)
    }
    .width('100%')
    .rowsGap(8)
    .columnsGap(8)
    .columnsTemplate('1fr '.repeat(1))
    .scrollBar(BarState.Off)
  }
}
