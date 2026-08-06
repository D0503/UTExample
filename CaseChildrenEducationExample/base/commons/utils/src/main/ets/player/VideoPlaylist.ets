import { User, VideoCardDetail, VipRecord } from '@ohos_agcit/children_education_datasource';
import { CommonConstants } from '../constants/CommonConstants';
import { GlobalInfoModel } from '../model/GlobalInfoModel';
import { AppStorageV2 } from '@kit.ArkUI';


@ComponentV2
export struct VideoPlaylist {
  @Param testId: string = 'player-playlist-instance-0';
  @Param @Once @Require title: string;
  @Param @Once @Require globalVideoList: Array<VideoCardDetail>;
  @Consumer(CommonConstants.USER_INFO) user: User = new User();
  @Consumer(CommonConstants.VIP_RECORD) vipRecord: VipRecord = new VipRecord();
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;
  @Local paddingNum: number = 16

  build() {
    Column() {
      // title
      Row() {
        Text(this.title)
          .fontSize(16)
          .fontWeight(500)
          .lineHeight(21)
      }
      .height(48)
      .width(CommonConstants.FULL_PERCENT)
      .padding({
        left: this.paddingNum,
        right: this.paddingNum
      })
      .margin({top: 0})

      Blank()
        .height(8)
        .width(CommonConstants.FULL_PERCENT)
        .backgroundColor($r('sys.color.background_secondary'))


      // playlist
      Row() {
        Blank().height(24)
        Text('选集')
          .fontWeight(FontWeight.Bold)
          .fontSize(24)
        Blank()
      }
      .height(56)
      .padding({ left: this.paddingNum, right: this.paddingNum })

      Grid() {
        ForEach(this.globalVideoList, (item: VideoCardDetail) => {
          GridItem() {
            VideoCardDetailItem({
              title: item.title,
              imageUrl: item.imageUrl,
              isVip: item.isVip,
            });
          }
          .onClick(() => {
            if (!item.isVip) {
              let pathInfo: NavPathInfo = new NavPathInfo(CommonConstants.VIDEO_PLAY_PAGE, item);
              this.globalInfo.navStack.replacePath(pathInfo, true);
              return
            }
            let pathInfo: NavPathInfo = new NavPathInfo(CommonConstants.VIDEO_PLAY_PAGE, item);
            this.globalInfo.navStack.replacePath(pathInfo, true);
          });
        }, (item: VideoCardDetail) => JSON.stringify(item));
      }
      .scrollBar(BarState.Off)
      .width(CommonConstants.FULL_PERCENT)
      .padding({ left: this.paddingNum, right: this.paddingNum })
      .rowsGap(12)
      .columnsGap(12)
      .columnsTemplate('1fr '.repeat(2))
      .padding({ left: this.paddingNum, right: this.paddingNum })
    }
    .id(this.testId)
    .alignItems(HorizontalAlign.Start)
  }
}

@ComponentV2
struct VideoCardDetailItem {
  @Param @Require title: string;
  @Param @Require imageUrl: string;
  @Param @Require isVip: boolean;

  build() {
    Column({ space: 10 }) {
      Stack({ alignContent: Alignment.TopStart }) {
        Image(this.imageUrl)
          .aspectRatio(1.78)
          .borderRadius(10);
        Image(this.isVip ? $r('app.media.icon_vip_top_start') : $r('app.media.icon_free_top_start'))
          .width('20%');
      };

      Text(this.title)
        .fontWeight(FontWeight.Medium)
        .fontSize(16);
    }
    .alignItems(HorizontalAlign.Start);
  }
}
