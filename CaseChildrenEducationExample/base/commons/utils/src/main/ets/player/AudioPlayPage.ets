import { TitleShare } from '../uicomponents/TitleShare';
import { PlayConstants } from './common/constants/PlayConstants';
import { GlobalContext } from '../utils/GlobalContext';
import { User, VideoCardDetail, VideoCollection, VipRecord } from '@ohos_agcit/children_education_datasource';
import { AppStorageV2, CustomContentDialog } from '@kit.ArkUI';
import { TimeControl } from './common/util/TimeControl';
import { DateFormatUtil } from '../utils/DateFormatUtil';
import { CommonConstants } from '../constants/CommonConstants';
import { historyRecord } from './PlayControl';
import { QuickLoginUtil } from '../quicklogin/QuickLoginUtil';
import { AvoidArea } from '../model/AvoidArea';
import { GlobalInfoModel } from '../model/GlobalInfoModel';


@ComponentV2
export struct AudioPlayPage {
  @Consumer(CommonConstants.USER_INFO) user: User = new User();
  @Consumer(CommonConstants.VIP_RECORD) vipRecord: VipRecord = new VipRecord();
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;
  @Local title: string = '';
  @Local imageUrl: string = '';
  @Local index: number = 1;
  @Local totalTime: number = 0;
  @Local currentTime: number = 0;
  @Local audioUrl: string = '';
  @Local status: number = PlayConstants.STATUS_START;
  private audioDetailInfo = GlobalContext.getContext().getObject(CommonConstants.GLOBAL_VIDEO_LIST) as VideoCollection;
  private jumpReturnPlayState: number = PlayConstants.STATUS_PAUSE;
  controller: VideoController = new VideoController();
  private uiContext: UIContext = this.getUIContext() as UIContext;
  private audioInfo: VideoCardDetail = {
    id: '',
    cardId: '',
    title: '',
    imageUrl: '',
    videoNumber: 0,
    iconUrl: '',
    videoUrl: '',
    isVip: false
  };
  private currentAudioInfo: VideoCardDetail = {
    id: '',
    cardId: '',
    title: '',
    imageUrl: '',
    videoNumber: 0,
    iconUrl: '',
    videoUrl: '',
    isVip: false
  };

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Top }) {
        Video({
          src: this.audioUrl,
          controller: this.controller,
        })
          .autoPlay(this.status === PlayConstants.STATUS_START)
          .visibility(Visibility.Hidden)
          .onPrepared((e) => {
            this.currentTime = 0;
            this.totalTime = e.duration;
          })
          .onUpdate((e) => {
            this.currentTime = e.time;
            console.info('onUpdate is ' + e.time);
          })
          .onFinish(() => {
            this.playNextAudio();
          })
          .zIndex(0)

          Scroll() {

            Column() {
              Blank().height(56)

              Image(this.imageUrl)
                .id('audio-cover')
                .width(160)
                .height(160)
                .borderRadius(10)
                .padding({
                  bottom: '5%'
                })

              Text(this.title)
                .id('audio-title')
                .fontSize(14)
                .lineHeight(19)
                .fontWeight(FontWeight.Regular)
                .margin({ top: 16 })
                .width(288)
                .height(19)
                .textAlign(TextAlign.Center)

              Blank()
                .height(289)

              Column() {
                this.playTimeControl();

                this.playStatusControl();
              }
              .id('audio-control-area')
              .margin({ bottom: 24 })
            }
            .justifyContent(FlexAlign.Start)
            .alignItems(HorizontalAlign.Center)
            .width(CommonConstants.FULL_PERCENT)
            .zIndex(1);
          }
      }
      .id('audio-player-root')
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
    }
    .padding({
      top: this.getUIContext().px2vp(this.avoidArea.topRectHeight),
      bottom: this.getUIContext().px2vp(this.avoidArea.bottomRectHeight),
    })
    .onReady((cxt: NavDestinationContext) => {
      let audioCardDetail = cxt.pathInfo.param as VideoCardDetail;
      this.title = audioCardDetail.title;
      this.imageUrl = audioCardDetail.imageUrl;
      this.audioUrl = audioCardDetail.videoUrl;
      this.index = audioCardDetail.videoNumber - 1;
    })
    .onShown(() => {
      if (TimeControl.timeControl(this.uiContext)) {
        this.globalInfo.navStack.pop();
        return;
      }
      if (this.totalTime !== 0 && this.currentTime === this.totalTime) {
        let globalVideoList = this.audioDetailInfo.videoCardDetailList;
        let curIndex = this.index + PlayConstants.CONTROL_NEXT;
        this.audioInfo = globalVideoList[curIndex];
        let isVip = this.audioInfo.isVip;
        if (isVip && !this.vipRecord.isVip) {
          return;
        }

        this.index = curIndex;
        this.title = this.audioInfo.title;
        this.imageUrl = this.audioInfo.imageUrl;
        this.audioUrl = this.audioInfo.videoUrl;

        this.controller.reset();
        this.switchPlayOrPause();
        return;
      }
      if (this.status === PlayConstants.STATUS_PAUSE && this.jumpReturnPlayState === PlayConstants.STATUS_START) {
        this.switchPlayOrPause();
      }
    })
    .onHidden(() => {
      if (this.status === PlayConstants.STATUS_START) {
        this.controller.pause();
        this.status = PlayConstants.STATUS_PAUSE;
        this.jumpReturnPlayState = PlayConstants.STATUS_START;
      } else {
        this.jumpReturnPlayState = PlayConstants.STATUS_PAUSE;
      }
    })
    .title(TitleShare(this.title, this.imageUrl))
    .onBackPressed(() => {
      this.status = PlayConstants.STATUS_PAUSE;
      this.controller.pause();
      this.controller.stop();
      // 异步执行历史记录保存，不阻塞返回
      void historyRecord(this.audioDetailInfo, this.index, 1).then(() => {
        this.globalInfo.navStack.pop();
      });
      return true;
    });
  }

  playNextAudio() {
    if (TimeControl.timeControl(this.uiContext)) {
      this.globalInfo.navStack.pop();
      return;
    }

    let globalVideoList = this.audioDetailInfo.videoCardDetailList;
    let curIndex = this.index + PlayConstants.CONTROL_NEXT;
    if (curIndex === globalVideoList.length) {
      if (this.currentTime === this.totalTime) {
        this.switchPlayOrPause();
      }
      try {
        this.uiContext.getPromptAction().showToast({
          message: PlayConstants.LAST_NUMBER,
          alignment: Alignment.Center,
        });
      } catch (error) {
      }
      return;
    }

    this.audioInfo = globalVideoList[curIndex];
    let isVip = this.audioInfo.isVip;

    if (isVip && !this.vipRecord.isVip) {
      this.switchPlayOrPause()
      this.dialogController.open();
      return;
    }

    this.index = curIndex;
    this.title = this.audioInfo.title;
    this.imageUrl = this.audioInfo.imageUrl;
    this.audioUrl = this.audioInfo.videoUrl;
    this.controller.reset();
  }

  playPreviousAudio() {
    if (TimeControl.timeControl(this.uiContext)) {
      this.globalInfo.navStack.pop();
      return;
    }
    let globalVideoList = this.audioDetailInfo.videoCardDetailList;
    let curIndex = this.index - PlayConstants.CONTROL_NEXT;

    if (curIndex < 0) {
      try {
        this.uiContext.getPromptAction().showToast({
          message: PlayConstants.FIRST_NUMBER,
          alignment: Alignment.Center,
        });
      } catch (error) {
      }
      return;
    }

    this.audioInfo = globalVideoList[curIndex];
    this.index = curIndex;
    this.title = this.audioInfo.title;
    this.imageUrl = this.audioInfo.imageUrl;
    this.audioUrl = this.audioInfo.videoUrl;
    this.controller.reset();
  }

  switchPlayOrPause() {
    if (this.status === PlayConstants.STATUS_START) {
      this.controller.pause();
      this.status = PlayConstants.STATUS_PAUSE;
    } else {
      this.controller.start();
      this.status = PlayConstants.STATUS_START;
    }
  }

  @Builder
  playStatusControl() {
    Row({ space: '30' }) {
      Stack({ alignContent: Alignment.Center }) {
        Row() {
        }
        .width('50')
        .height('50')
        .borderRadius(100)
        .backgroundColor('#fff6f3f3');

        SymbolGlyph($r('sys.symbol.backward_end_fill'))
          .fontColor(this.index === 0 ? [Color.Gray] : [Color.Black])
          .fontSize('30vp');
      }
      .onClick(() => {
        this.playPreviousAudio();
      });

      Stack({ alignContent: Alignment.Center }) {
        Row() {
        }
        .width('65')
        .height('65')
        .borderRadius(100)
        .backgroundColor('#FFD15D');

        SymbolGlyph(this.status === PlayConstants.STATUS_START ? $r('sys.symbol.pause') :
          $r('sys.symbol.play_fill'))
          .fontColor([$r('sys.color.white')])
          .fontSize('30vp');
      }
      .id('audio-play-pause')
      .onClick(() => {
        this.switchPlayOrPause();
      });

      Stack({ alignContent: Alignment.Center }) {
        Row() {
        }
        .width('50')
        .height('50')
        .borderRadius(100)
        .backgroundColor('#fff6f3f3');

        SymbolGlyph($r('sys.symbol.forward_end_fill'))
          .fontColor(this.index === this.audioDetailInfo.videoCardDetailList.length - 1 ? [Color.Gray] : [Color.Black])
          .fontSize('30vp');
      }
      .onClick(() => {
        this.playNextAudio();
      });
    }
    .padding({
      top: '5%',
    });
  }

  @Builder
  playTimeControl() {
    Row({ space: 5 }) {
      Text(DateFormatUtil.secondToTime(this.currentTime));
      Slider({
        value: this.currentTime,
        min: 0,
        max: this.totalTime,
        step: 1,
        style: SliderStyle.OutSet,
      })
        .id('audio-progress')
        .trackColor($r('sys.color.comp_background_secondary'))
        .selectedColor($r('sys.color.comp_background_emphasize'))
        .trackThickness(PlayConstants.PROGRESS_TRACK_THICKNESS)
        .layoutWeight(1)
        .onChange((value: number, mode: SliderChangeMode) => {
          this.currentTime = value;
          this.controller.setCurrentTime(value, SeekMode.PreviousKeyframe);
        });
      Text(DateFormatUtil.secondToTime(this.totalTime));
    }
    .padding({
      left: '5%',
      right: '5%',
    });
  }

  @Builder
  buildContent(): void {
    Column() {
      Text('下一内容需要开通VIP，即将跳转到' + (this.user.isLogin ? 'VIP' : '登录') + '页面');
    }
    .width(CommonConstants.FULL_PERCENT);
  }

  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomContentDialog({
      primaryTitle: '温馨提示',
      contentBuilder: () => {
        this.buildContent();
      },
      buttons: [
        {
          value: '取消',
          buttonStyle: ButtonStyleMode.TEXTUAL,
          action: () => {
          },
        },
        {
          value: '前往开通',
          buttonStyle: ButtonStyleMode.TEXTUAL,
          role: ButtonRole.ERROR,
          action: () => {
            if (!this.user.isLogin) {
              QuickLoginUtil.getQuickLoginAnonymousPhone(this.getUIContext(), this.globalInfo.navStack)
              return
            }
            let pathInfo: NavPathInfo = new NavPathInfo(CommonConstants.VIP_PAGE_VIEW, this.audioInfo);
            this.globalInfo.navStack.pushDestination(pathInfo, true);
          },
        },
      ],
    }),
    autoCancel: false
  });
}
