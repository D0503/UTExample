import { CommonConstants } from '../constants/CommonConstants';


@Builder
export function TagLabelCard(text: string) {
  Text(text)
    .fontSize(10)
    .fontColor($r('sys.color.font_primary'))
    .opacity(0.9)
    .textAlign(TextAlign.Center)
    .fontWeight(FontWeight.Regular)
    .fontFamily(CommonConstants.HARMONY_HEITI_MEDIUM_FONT_FAMILY)
    .borderRadius(4)
    .backgroundColor($r('app.color.ffeeebeb'))
    .height(16)
    .padding({
      left: $r('app.float.8vp'),
      right: $r('app.float.8vp'),
    })
    .margin({ right: 5 })
}