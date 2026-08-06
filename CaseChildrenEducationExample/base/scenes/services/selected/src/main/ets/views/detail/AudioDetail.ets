import { User, VideoCardDetail, VideoCollection, VipRecord } from '@ohos_agcit/children_education_datasource';
import {
  AvoidArea,
  CommonConstants,
  GlobalContext,
  GlobalInfoModel,
  QuickLoginUtil,
  TimeControl,
  Title,
  VideoCover
} from '@ohos_agcit/children_education_utils';
import { AppStorageV2 } from '@kit.ArkUI';

@Builder
export function AudioDetailBuilder() {
  AudioDetailListView();
}


@ComponentV2
export struct AudioDetailListView {
  @Consumer(CommonConstants.USER_INFO) user: User = new User();
  @Consumer(CommonConstants.VIP_RECORD) vipRecord: VipRecord = new VipRecord();
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;
  @Local audioDetail: VideoCollection = {
    videoCard: {
      id: CommonConstants.EMPTY_STRING,
      title: CommonConstants.EMPTY_STRING,
      describe: CommonConstants.EMPTY_STRING,
      tags: [],
      videoType: 1,
      updateCount: 0,
      totalCount: 0,
      imageUrl: CommonConstants.EMPTY_STRING,
      isVip: false,
    },
    videoCardDetailList: [],
  };

  build() {
    NavDestination() {
      Scroll() {
        // 专辑图片
        Column() {
          Row() {
            Row() {
              VideoCover({
                imageUrl: this.audioDetail.videoCard.imageUrl,
                isVip: this.audioDetail.videoCard.isVip,
                updateCount: this.audioDetail.videoCard.updateCount,
                totalCount: this.audioDetail.videoCard.totalCount,
                ratio: 1,
              })
            }
            .margin({ left: 12 })
            .width(104)

            Blank().width(12)

            Column() {
              Text(this.audioDetail.videoCard.title)
                .fontSize(16)
                .fontWeight(FontWeight.Medium);
              Blank().height(4)
              Text(this.audioDetail.videoCard.describe)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .fontColor('#ff949191')
                .fontSize(12);
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start);
          }
          .width(CommonConstants.FULL_PERCENT)
          .height(130)
          .backgroundColor($r('sys.color.comp_background_list_card'))
          .borderRadius(12)
          .shadow(ShadowStyle.OUTER_DEFAULT_SM);

          Blank().height(16)

          // 列表
          Grid() {
            ForEach(this.audioDetail.videoCardDetailList, (item: VideoCardDetail, index: number) => {
              GridItem() {
                AudioListItem({
                  audioItem: item,
                  index: index,
                })
                  .id(`audio-detail-item-${index}`)
                  .onClick(() => {
                    // 是否登录
                    if (item.isVip && this.user.isLogin === false) {
                      QuickLoginUtil.getQuickLoginAnonymousPhone(this.getUIContext(), this.globalInfo.navStack)
                      return
                    }

                    // 是否开通VIP
                    if (item.isVip && !this.vipRecord.isVip) {
                      let pathInfo: NavPathInfo = new NavPathInfo(CommonConstants.VIP_PAGE_VIEW, item);
                      this.globalInfo.navStack.pushDestination(pathInfo, true);
                      return;
                    }
                    if (TimeControl.timeControl(this.getUIContext())) {
                      return;
                    }
                    GlobalContext.getContext().setObject(CommonConstants.GLOBAL_VIDEO_LIST, this.audioDetail);
                    let pathInfo: NavPathInfo = new NavPathInfo(CommonConstants.AUDIO_PLAY_PAGE, item);
                    this.globalInfo.navStack.pushDestination(pathInfo, true);
                  })
              }
            }, (item: VideoCardDetail) => JSON.stringify(item));
          }
          .columnsGap(8)
          .columnsTemplate('1fr '.repeat(1))
        }
        .id('audio-list')
      }
      .scrollBar(BarState.Off)
      .width('100%')
      .padding({
        left: 16,
        right: 16
      })
    }
    .padding({
      top: this.getUIContext().px2vp(this.avoidArea.topRectHeight)
    })
    .onReady((cxt: NavDestinationContext) => {
      this.audioDetail = cxt.pathInfo.param as VideoCollection;
    })
    .title(Title(this.audioDetail.videoCard.title))
    .onBackPressed(() => {
      this.globalInfo.navStack.pop();
      return true;
    })
  }
}

@ComponentV2
export struct AudioListItem {
  @Param @Once @Require audioItem: VideoCardDetail;
  @Param @Once @Require index: number;

  build() {
    Column() {
      Row() {
        Text(this.calcSequence())
          .fontColor(Color.Gray)
          .width(24)
          .height(24)
          .textAlign(TextAlign.Center)
          .margin({ left: 5, top: 17 })

        Column({ space: 4 }) {
          Row() {
            Image(this.audioItem.isVip ? $r('app.media.icon_vip') : $r('app.media.icon_free'))
              .width(36).height(16)
            Text(this.audioItem.title)
              .fontWeight(FontWeight.Regular)
              .fontColor(Color.Black)
              .fontSize(12)
              .margin({ left: 4 })
          }
          .height(16)

          Row() {
            Image($r('app.media.icon_block'))
              .width('5%');
            Text('03:34')
              .fontColor(Color.Gray)
              .fontSize(10)
              .margin({ left: 4 })
          }
          .height(14)
        }
        .layoutWeight(1)
        .margin({
          top: 12,
          left: 12
        })
        .alignItems(HorizontalAlign.Start)
        .height('100%')
      }
      .height(54)
      .alignItems(VerticalAlign.Top)

      Divider().width('100%').strokeWidth('1px')
    }
    .height(55)
  }

  private calcSequence(): string {
    let sequence = this.index + 1
    if (sequence < 10) {
      return '0' + sequence
    }
    return this.index + 1 + CommonConstants.EMPTY_STRING;
  }
}
