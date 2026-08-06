import { CommonConstants } from '../constants/CommonConstants';

@Builder
export function FeedTitle(imgUrl: string, title: string, callback: Callback<void>) {
  Column() {
    Column().height(24)
    Row() {
      Image($r(imgUrl))
        .height(30)
        .alignSelf(ItemAlign.Center)
        .padding({ right: 5 });

      Text(title)
        .fontSize($r('sys.float.Subtitle_L'))
        .alignSelf(ItemAlign.Center)
        .fontWeight(FontWeight.Bold);

      Blank();

      Row() {
        Text('更多')
          .fontSize(14)
          .fontWeight(FontWeight.Regular)
          .opacity(0.6);
        rightArrow();
      }
      .alignSelf(ItemAlign.Center)
      .onClick(() => {
        callback();
      })
    }
    .justifyContent(FlexAlign.Start)
    .height(24)
    .width(CommonConstants.FULL_PERCENT);
  }
  .height(56)
  .width(CommonConstants.FULL_PERCENT);
}

@Builder
export function rightArrow() {
  SymbolGlyph($r('sys.symbol.chevron_right'))
    .fontColor([$r('sys.color.ohos_id_color_foreground')])
    .opacity(0.3)
    .fontSize('24vp');
}
