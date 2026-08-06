@Entry
@Component
struct WidgetCard2X4 {
  /*
   * The action type.
   */
  readonly actionType: string = 'router';
  /*
   * The ability name.
   */
  readonly abilityName: string = 'EntryAbility';
  /*
   * The message.
   */
  readonly message: string = 'add detail';
  /*
   * The width percentage setting.
   */
  readonly fullWidthPercent: string = '100%';
  /*
   * The height percentage setting.
   */
  readonly fullHeightPercent: string = '100%';
  @LocalStorageProp('id') videoId:string = '';
  @LocalStorageProp('title') title:string = '';
  @LocalStorageProp('updateCount') updateCount: number = 1;
  @LocalStorageProp('imgName') imgName: string  = ''
  @LocalStorageProp('isHistory') hasHistory: boolean = false;
  @LocalStorageProp('videoType') videoType: number = 0 // 0视频1音频
  @LocalStorageProp('param') param:string = '';

  build() {
    Row({space:12}) {
      Stack() {
        Image(`memory://${this.imgName}`)
          .width(this.fullWidthPercent)
          .height(this.fullHeightPercent)

        Column() {
          Blank()

          Column() {
            if (this.hasHistory) {
              Row() {
                Image($r('app.media.play_btn'))
                  .width(24)
                  .height(24)
                  .margin({
                    right:4
                  })

                Text('最近播放')
                  .fontColor('#FFFFFF')
                  .fontSize(12)
                  .fontWeight(500)
                  .lineHeight(16)

              }
              .alignItems(VerticalAlign.Center)
              .width(this.fullWidthPercent)
              .height(this.fullHeightPercent)
            } else {
              Text(this.title)
                .fontColor('#FFFFFF')
                .fontSize(12)
                .fontWeight(500)
                .lineHeight(16)
                .maxLines(1)
                .textOverflow({
                  overflow:TextOverflow.Ellipsis
                })
                .margin({
                  bottom:2
                })
              Text(`观看至第${this.updateCount}集`)
                .fontColor('#FFFFFF')
                .fontSize(10)
                .fontWeight(400)
                .lineHeight(13)
            }
          }
          .width(this.fullWidthPercent)
          .height(40)
          .padding({
            top:0,
            left:8,
            right:8,
          })
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Start)
          .linearGradient({
            angle: 180,
            colors: [['transparent',0],['#000000',1]],
          })
        }
        .width(this.fullWidthPercent)
        .height(this.fullHeightPercent)

      }
      .borderRadius(8)
      .width(116)
      .height(this.fullHeightPercent)
      .clip(true)

      Column({space:12}) {
        Row() {
          Image($r('app.media.hot'))
            .width(24)
            .height(24)
            .margin({right:8})
          Text('热门推荐')
            .fontColor('#000000')
            .fontSize(14)
            .fontWeight(500)
            .lineHeight(19)
        }
        .width(this.fullWidthPercent)
        .borderRadius(8)
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .onClick(() => {
          postCardAction(this, {
            action: this.actionType,
            abilityName: this.abilityName,
            params: {
              message: 'HotAnimationListView'
            }
          });
        })
        Row() {
          Image($r('app.media.clock_fill'))
            .width(24)
            .height(24)
            .margin({right:8})
          Text('观看历史')
            .fontColor('#000000')
            .fontSize(14)
            .fontWeight(500)
            .lineHeight(19)
        }
        .width(this.fullWidthPercent)
        .borderRadius(8)
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .onClick(() => {
          postCardAction(this, {
            action: this.actionType,
            abilityName: this.abilityName,
            params: {
              message: 'ViewHistory'
            }
          });
        })
      }
      .layoutWeight(1)
    }
    .height(this.fullHeightPercent)
    .padding(12)
    .backgroundColor($r('sys.color.comp_background_primary'))
    .onClick(() => {
      postCardAction(this, {
        action: this.actionType,
        abilityName: this.abilityName,
        params: {
          message: this.videoType === 0?'VideoPlayPage':'AudioPlayPage',
          param: this.param
        }
      });
    })
  }
}