import { User, VideoCardDetail, VideoCollection, VipRecord } from '@ohos_agcit/children_education_datasource';
import {
  AvoidArea,
  CommonConstants,
  GlobalContext,
  GlobalInfoModel,
  TagLabelCard,
  TimeControl,
  Title,
  VideoCover
} from '@ohos_agcit/children_education_utils';
import { AppStorageV2 } from '@kit.ArkUI';

@Builder
export function VideoDetailBuilder() {
  VideoDetailListView();
}


@ComponentV2
export struct VideoDetailListView {
  @Consumer(CommonConstants.USER_INFO) user: User = new User();
  @Consumer(CommonConstants.VIP_RECORD) vipRecord: VipRecord = new VipRecord();
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;
  @Local navigationTitle: string = ''
  @Local videoDetail: VideoCollection = {
    videoCard: {
      id: CommonConstants.EMPTY_STRING,
      title: CommonConstants.EMPTY_STRING,
      describe: CommonConstants.EMPTY_STRING,
      tags: [],
      videoType: 0,
      updateCount: 0,
      totalCount: 0,
      imageUrl: CommonConstants.EMPTY_STRING,
      isVip: false,
    },
    videoCardDetailList: [],
  };
  private imageHeight: number = 80

  build() {
    NavDestination() {
      Column() {
        Column() {
          Row() {
            Row() {
              VideoCover({
                imageUrl: this.videoDetail.videoCard.imageUrl,
                isVip: this.videoDetail.videoCard.isVip,
                updateCount: this.videoDetail.videoCard.updateCount,
                totalCount: this.videoDetail.videoCard.totalCount,
                ratio: 16 / 9,
              })
            }
            .width(142)
            
            Blank(12)

            Column() {
              Text(this.videoDetail.videoCard.title)
                .fontSize(16)
                .lineHeight(21)
                .fontWeight(FontWeight.Bold)

              Blank().height(4)

              Text(this.videoDetail.videoCard.describe)
                .fontSize(12)
                .lineHeight(16)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .fontColor('#ffb8b1b1')

              Blank()

              Row() {
                ForEach(this.videoDetail.videoCard.tags, (item: string) => {
                  TagLabelCard(item);
                }, (item: string) => item);
              }
            }
            .height(this.imageHeight)
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start);
          }
          .height(104)
          .padding(12)
          .alignItems(VerticalAlign.Top)
        }
        .width(CommonConstants.FULL_PERCENT)
        .height(104)
        .id('video-card')
        .borderRadius(12)
        .backgroundColor($r('sys.color.white'))
        .justifyContent(FlexAlign.Center)
        .shadow(ShadowStyle.OUTER_DEFAULT_SM)
        .margin({ top: 8 })

        Blank().height(16)

        Grid() {
          ForEach(this.videoDetail.videoCardDetailList, (item: VideoCardDetail, index ?: number) => {
            GridItem() {
              Column() {
                VideoCover({
                  imageUrl: item.imageUrl,
                  isVip: item.isVip,
                  ratio: 16 / 9,
                  layoutWeightNum: 1
                })

                Text(item.title)
                  .fontWeight(FontWeight.Medium)
                  .fontSize(16)
                  .width('100%')
                  .textAlign(TextAlign.Start)
                  .margin({ top: 8 })
              }
              .onClick(() => {
                if (TimeControl.timeControl(this.getUIContext())) {
                  return;
                }
                GlobalContext.getContext().setObject(CommonConstants.GLOBAL_VIDEO_LIST, this.videoDetail);
                let pathInfo: NavPathInfo = new NavPathInfo(CommonConstants.VIDEO_PLAY_PAGE, item);
                this.globalInfo.navStack.pushDestination(pathInfo, true);
              });
            }
            .id(`detail-recommend-item-${index}`)
          }, (item: VideoCardDetail) => JSON.stringify(item));
        }
        .scrollBar(BarState.Off)
        .id('content-detail-root')
        .width(CommonConstants.FULL_PERCENT)
        .rowsGap(8)
        .columnsGap(8)
        .columnsTemplate('1fr '.repeat(2))
        .layoutWeight(1)
      }
      .width('100%')
      .padding({
        left: 16,
        right: 16
      })
    }
    .padding({
      top: this.getUIContext().px2vp(this.avoidArea.topRectHeight),
    })
    .onReady((cxt: NavDestinationContext) => {
      this.videoDetail = cxt.pathInfo.param as VideoCollection;
      this.navigationTitle = this.videoDetail.videoCard.title
    })
    .title(Title(this.navigationTitle))
    .onBackPressed(() => {
      this.globalInfo.navStack.pop();
      return true;
    })
  }
}

