import { CommonConstants } from '../constants/CommonConstants';

@ComponentV2
export struct VideoCover {
  @Param imageUrl: string = '';
  @Param isVip: boolean = true;
  @Param updateCount: number = 0;
  @Param totalCount: number = 0;
  @Param ratio: number = 16 / 9;
  @Param layoutWeightNum: number = 0;

  build() {
    RelativeContainer() {
      Image(this.imageUrl)
        .borderRadius(12)
        .aspectRatio(this.ratio)
        .id(CommonConstants.IMAGE)

      Image(this.isVip ? $r('app.media.icon_vip_top_start') : $r('app.media.icon_free_top_start'))
        .width(32)
        .height(16)
        .align(Alignment.TopStart)
        .alignRules({
          top: { anchor: CommonConstants.IMAGE, align: VerticalAlign.Top },
          left: { anchor: CommonConstants.IMAGE, align: HorizontalAlign.Start },
        })

      if (this.totalCount !== 0) {
        Stack({ alignContent: Alignment.Center }) {
          Text(`共${this.totalCount}集`)
            .fontColor($r('sys.color.white'))
            .fontSize(10)
            .lineHeight(13)
            .zIndex(2)
            .height(14)
            .textAlign(TextAlign.Center)
          Button()
            .fontColor(Color.White)
            .backgroundColor($r('sys.color.black'))
            .opacity(0.4)
            .width(52)
            .height(16)
        }
        .offset({ x: -2, y: -2 })
        .alignRules({
          bottom: { anchor: CommonConstants.IMAGE, align: VerticalAlign.Bottom },
          right: { anchor: CommonConstants.IMAGE, align: HorizontalAlign.End },
        })
      }
    }
    .layoutWeight(this.layoutWeightNum)
    .height('auto')
  }
}
