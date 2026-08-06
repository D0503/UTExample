
@Entry
@Component
struct WidgetCard2X2 {
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
  @LocalStorageProp('isHistory') isHistory: boolean = false;
  @LocalStorageProp('videoType') videoType: number = 0 // 0视频1音频
  @LocalStorageProp('param') param:string = '';

  build() {
    Row() {
      Column() {
        Stack() {
          Image(`memory://${this.imgName}`)
            .width(this.fullWidthPercent)
            .height(this.fullHeightPercent)

          Column() {
            Blank()
            Image($r('app.media.play_btn'))
              .width(40)
              .height(40)
              .margin({
                bottom:15
              })
            Column() {
              Text(this.title)
                .fontColor('#FFFFFF')
                .fontSize(14)
                .fontWeight(500)
                .lineHeight(19)
                .maxLines(1)
                .textOverflow({
                  overflow:TextOverflow.Ellipsis
                })
              Text(`${this.isHistory?'观看至':'更新至'}第${this.updateCount}集`)
                .fontColor('#FFFFFF')
                .fontSize(12)
                .fontWeight(400)
                .lineHeight(16)
            }
            .width(this.fullWidthPercent)
            .height(56)
            .padding({
              top:7,
              left:12,
              right:12,
              bottom:12
            })
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.Center)
            .linearGradient({
              angle: 180,
              colors: [['transparent',0],['#000000',1]],
            })
          }
          .width(this.fullWidthPercent)
          .height(this.fullHeightPercent)
          .backgroundColor('transparent')

        }
      }
      .width(this.fullWidthPercent)
    }
    .height(this.fullHeightPercent)
    .width(this.fullWidthPercent)
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