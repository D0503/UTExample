@ComponentV2
export struct CoreButtons {
  build() {
    Row({ space: 16 }) {
      this.animeCircle('超级汽车', $r('app.media.drawing_board_1'))
      this.animeCircle('国学', $r('app.media.drawing_board_2'))
      this.animeCircle('科普百科', $r('app.media.drawing_board_3'))
      this.animeCircle('多米', $r('app.media.drawing_board_4'))
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .height(96)
    .width('100%')
  }

  @Builder
  animeCircle(title: string, imageResource: Resource) {
    Column({ space: 10 }) {
      Image(imageResource)
      Text(title)
        .fontSize(12)
        .fontFamily('鸿蒙黑体')
        .fontWeight(FontWeight.Regular)
        .fontColor($r('sys.color.black'))
        .opacity(0.9)
    }
    .width(65)
    .height(65)
  }
}