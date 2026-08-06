import { Title } from '../uicomponents/Title';
import { GlobalContext } from '../utils/GlobalContext';
import {
  DataGenerator,
  User,
  VideoCardDetail,
  VideoCollection,
  VipRecord
} from '@ohos_agcit/children_education_datasource';
import { AppStorageV2, display, window } from '@kit.ArkUI';
import { AbilityConstant, common } from '@kit.AbilityKit';
import { TimeControl } from './common/util/TimeControl';
import { CommonConstants } from '../constants/CommonConstants';
import { historyRecord } from './PlayControl';
import { MovieItem, PlayerComponent } from 'recorded_player';
import { SharePicker } from 'aggregated_share';
import { AvoidArea } from '../model/AvoidArea';
import { GlobalInfoModel } from '../model/GlobalInfoModel';

import { VideoPlaylist } from './VideoPlaylist';
import { emitter } from '@kit.BasicServicesKit';
import { DeviceUtil } from '../utils/DeviceUtil';
import { QuickLoginUtil } from '../quicklogin/QuickLoginUtil';
import {
  FinishStatus,
  MemberList,
  MemberParams,
  MemberSheetUtils,
  PRIVACY_CONTENT,
  PRODUCTS_INFO,
  ProductsInfoOptions
} from 'membership';
import { DateUtil } from '../utils/DateUtil';
import { DateConstants } from '../constants/DateConstants';
import { iap } from '@kit.IAPKit';
import { PipManager } from 'recorded_player/src/main/ets/tools/PipManager';
import { LogUtil } from '../utils/LogUtil';
import { media } from '@kit.MediaKit';
import { AVPlayerState } from 'recorded_player'


@ComponentV2
export struct VideoPlayPage {
  private videoDetailInfo = GlobalContext.getContext().getObject(CommonConstants.GLOBAL_VIDEO_LIST) as VideoCollection;
  private uiContext: UIContext = this.getUIContext() as UIContext;
  private hostContext: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;
  private windowClass = this.hostContext.windowStage.getMainWindowSync();
  @Consumer(CommonConstants.USER_INFO) user: User = new User();
  @Consumer(CommonConstants.VIP_RECORD) vipRecord: VipRecord = new VipRecord();
  @Local title: string = '';
  @Local index: number = 0;
  @Local totalTime: number = 0;
  @Local currentTime: number = 0;
  @Local aspect: number = 9 / 16; // default video height/width ratio value
  @Local playerWidth: number = this.getUIContext().px2vp(display.getDefaultDisplaySync().width);
  @Local playerHeight: number = this.getUIContext().px2vp(display.getDefaultDisplaySync().width * this.aspect);
  @Local isShowVip: boolean = false;
  @Local isLayoutFullScreen: boolean = false; // 是否全屏
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;
  private videoInfo: VideoCardDetail = {
    id: '',
    cardId: '',
    title: '',
    imageUrl: '',
    videoNumber: 0,
    iconUrl: '',
    videoUrl: '',
    isVip: false,
  };
  shareEvent = () => {
    const picker = new SharePicker({
      title: this.videoInfo.title,
      coverUrl: this.videoInfo.imageUrl
    });
    picker.show();
  };

  aboutToAppear(): void {
    let viewWidth = this.getUIContext().px2vp(display.getDefaultDisplaySync().width)
    let viewHeight = this.getUIContext().px2vp(display.getDefaultDisplaySync().height)
    this.resizeScreen(viewWidth, viewHeight)

    this.windowClass.on('windowSizeChange', (size) => {
      let viewWidth = this.getUIContext().px2vp(size.width);
      let viewHeight = this.getUIContext().px2vp(size.height);

      this.resizeScreen(viewWidth, viewHeight)
    })

    // 打开迁移能力
    const uiContext = (this.getUIContext().getHostContext() as common.UIAbilityContext);
    uiContext.setMissionContinueState(AbilityConstant.ContinueState.ACTIVE, (result) => {
      console.info('setMissionContinueState ACTIVE result: ', JSON.stringify(result));
    });
  }

  aboutToDisappear(): void {
    this.exitFullScreen();
  }

  exitFullScreen() {
    emitter.emit('exitFullScreen', undefined);
  }

  resizeScreen(viewWidth: number, viewHeight: number) {
    if (this.isLayoutFullScreen) {
      if (DeviceUtil.isLandSpace()) {
        this.playerWidth = viewWidth
        this.playerHeight = viewHeight
      } else {
        this.playerWidth = viewWidth
        this.playerHeight = viewHeight - this.getUIContext().px2vp(this.avoidArea.topRectHeight) -
        this.getUIContext().px2vp(this.avoidArea.bottomRectHeight)
      }

      this.windowClass.setWindowSystemBarProperties({
        statusBarColor: '#000000',
        statusBarContentColor: '#FFFFFF',
      });
      return
    }

    this.playerWidth = viewWidth
    this.playerHeight = this.playerWidth * this.aspect
    this.windowClass.setWindowSystemBarProperties({
      statusBarColor: '#FFFFFF',
      statusBarContentColor: '#000000',
    })
  }

  private showPlaylistVisibility(): Visibility {
    if (this.isLayoutFullScreen) {
      return Visibility.None
    }
    return Visibility.Visible;
  }

  getBackgroundColor(): Resource {
    if (this.isLayoutFullScreen) {
      return $r('sys.color.comp_foreground_primary')
    }
    return $r('sys.color.background_primary');
  }

  private needRotationToLandSpace(): boolean {
    let isDeviceComplies = DeviceUtil.isPhone();
    let isStatusComplies = DeviceUtil.isPortrait()
    if (isDeviceComplies && isStatusComplies) {
      return true
    }
    return false;
  }

  private hasAuth() {
    if (!this.videoInfo.isVip) {
      return true
    }
    return this.vipRecord.isVip
  }

  private needRotationToPortrait(): boolean {
    let isDeviceComplies = DeviceUtil.isPhone();
    let isStatusComplies = DeviceUtil.isLandSpace()
    if (isDeviceComplies && isStatusComplies) {
      return true
    }
    return false;
  }

  // 购买会员商品结果回调函数
  private subscribeEvent = async (params: MemberParams): Promise<void> => {
    this.getUIContext().getPromptAction().showToast({ message: this.getSubscribeMsg(params) });
    if (params.type === iap.ProductType.NONRENEWABLE && params.status === FinishStatus.FINISHED) {
      // mock计算商品到期时间
      let today = DateUtil.getTodayStr(DateConstants.DATE_FORMAT4);
      let validDate = '';
      if (params.productId === '20254') {
        validDate = DateUtil.getAmountDayStr(today, 365, DateConstants.DATE_FORMAT4);
      } else if (params.productId === '20253') {
        validDate = DateUtil.getAmountDayStr(today, 92, DateConstants.DATE_FORMAT4);
      } else {
        validDate = DateUtil.getAmountDayStr(today, 31, DateConstants.DATE_FORMAT4);
      }
      emitter.emit(CommonConstants.VIP_RECORD, {
        data: {
          'isVip': true,
          'validTime': validDate,
        },
      });

      // 刷新页面
      let pathInfo: NavPathInfo = new NavPathInfo(CommonConstants.VIDEO_PLAY_PAGE, this.videoInfo);
      this.globalInfo.navStack.replacePath(pathInfo, true);

      PipManager.getInstance().player.isPlaying = true;
    }
  };
  // 查询用户开通的会员种类列表，沙盒场景下，已发货状态的非消耗型商品订单信息不返回
  private ownedMemberEvent = async (list: MemberList): Promise<void> => {
    if (list.renewList.length || list.nonRenewList.length) {
      this.getUIContext().getPromptAction().showToast({ message: `您已拥有会员` });
    }
  };
  // 购买非周期订阅商品后从开发者服务器查询商品到期时间
  private queryExpireTime = (productId: string, time?: number, validTime?: string): Promise<void> => {
    // 请求开发者服务器获取非周期订阅商品到期时间（涉及商品id、购买次数）
    return new Promise(() => {
      if (validTime !== undefined) {
        this.vipRecord.validTime = validTime
      }
    });
  };

  private getSubscribeMsg(param: MemberParams) {
    let message = '';
    if (param.status === FinishStatus.FINISHED) {
      message = '会员订阅成功';
    } else if (param.status === FinishStatus.UNFINISHED) {
      message = `会员订阅失败，订阅错误码为${param.errCode}，错误原因为${param.errMsg}`;
    }
    return message;
  }

  private readonly productsInfo: ProductsInfoOptions = {
    isSheet: true,
    themeColor: $r('app.color.color_member'),
    btnFontColor: $r('sys.color.font_on_primary'),
    linearColors: [['#FFFFFF', 0.0], ['#F5F1E5', 0.0], ['#F1D1A5', 1.0]],
    productsInfo: PRODUCTS_INFO,
    privacyContent: PRIVACY_CONTENT,
    lastPurchaseProductExpireTime: this.vipRecord.validTime,
    subscribeCallBack: this.subscribeEvent,
    queryExpireTime: this.queryExpireTime,
    ownedMemberCallBack: this.ownedMemberEvent,
  }

  @Builder
  vipPrompt() {
    Column() {
      Column() {
        Text('该视频内容为VIP会员专享，查看请先开通会员')
          .fontSize(14)
          .fontColor(Color.White)
          .lineHeight(19)

        Blank().height(12)

        Button('开通会员')
          .width(this.isLayoutFullScreen ? 120 : 90)
          .aspectRatio(2.57)
          .fontSize($r('sys.float.Body_M'))
          .fontColor($r('sys.color.font_primary'))
          .backgroundColor('#D3B685')
          .borderRadius(14)
          .onClick(() => {
            if (!this.user.isLogin) {
              QuickLoginUtil.getQuickLoginAnonymousPhone(this.getUIContext(), this.globalInfo.navStack)
              return
            }
            MemberSheetUtils.open(this.productsInfo, this.getUIContext()); // 半模态弹窗
          })

        Blank().height(12)

        Text('已是会员？点击登录查看')
          .fontSize(14)
          .fontColor('#D3B685')
          .onClick(() => {
            QuickLoginUtil.getQuickLoginAnonymousPhone(this.getUIContext(), this.globalInfo.navStack)
          })
      }
      .height(90)
      .width(288)
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('sys.color.comp_foreground_primary'))
    .visibility(Visibility.Visible);
  }

  build() {
    NavDestination() {
      Column() {
        Scroll() {
          Column() {
            PlayerComponent({
              movieItems: [new MovieItem('01', this.videoInfo.title, 0, this.videoInfo.videoUrl)],
              playerIndex: 0,
              showMaskLayer: !this.hasAuth(),
              stateChange:(state:string) => {
                if (state === AVPlayerState.PREPARED && this.currentTime) {
                  PipManager.getInstance().player.changeSeek(this.currentTime, 2)
                }
              },
              customBuilderParam: () => {
                this.vipPrompt()
              },
              fullScreenEvent: (isLayoutFullScreen: boolean) => {
                this.isLayoutFullScreen = isLayoutFullScreen
                let viewWidth = this.getUIContext().px2vp(display.getDefaultDisplaySync().width)
                let viewHeight = this.getUIContext().px2vp(display.getDefaultDisplaySync().height)

                // 开启全屏事件
                if (isLayoutFullScreen) {
                  // 开启强制横屏，通过windowSizeChange回调修改尺寸
                  if (this.needRotationToLandSpace()) {
                    window.getLastWindow(this.hostContext).then((win) => {
                      win.setPreferredOrientation(2)
                    })
                      .catch((err: BusinessError) => {
                        LogUtil.error(`getLastWindow failed: ${err.code}, ${err.message}`)
                      })
                    return
                  }
                  // 直接修改尺寸
                  this.resizeScreen(viewWidth, viewHeight)
                  return;
                }

                // 关闭全屏事件
                if (this.needRotationToPortrait()) {
                  // 关闭强制横屏，通过windowSizeChange回调修改尺寸
                  window.getLastWindow(this.hostContext)
                    .then((win) => {
                      win.setPreferredOrientation(1)
                    })
                    .catch((err: BusinessError) => {
                      LogUtil.error(`getLastWindow failed: ${err.code}, ${err.message}`)
                    })
                  return
                }
                // 直接修改尺寸
                this.resizeScreen(viewWidth, viewHeight)
              },
              exitEvent: () => {
                this.globalInfo.navStack.pop()
              },
              shareEvent: this.shareEvent,
            })
              .id('player-root')
              .width(this.playerWidth)
              .height(this.playerHeight)
              .backgroundColor(Color.Black)

            VideoPlaylist({
              title: this.videoInfo.title,
              globalVideoList: DataGenerator.getVideoDetail(this.getUIContext()).videoCardDetailList,
              testId: 'player-playlist-instance-0',
            })
              .id('player-playlist')
              .visibility(this.showPlaylistVisibility())
          }
        }
      }
      .backgroundColor(this.getBackgroundColor())
      .height('100%')
      .width('100%')
    }
    .padding({
      top: this.getUIContext().px2vp(this.avoidArea.topRectHeight),
    })
    .onReady((cxt: NavDestinationContext) => {
      let detail = cxt.pathInfo.param as VideoCardDetail;
      this.videoInfo.id = detail.id
      this.videoInfo.cardId = detail.cardId
      this.videoInfo.title = detail.title
      this.videoInfo.imageUrl = detail.imageUrl
      this.videoInfo.iconUrl = detail.iconUrl
      this.videoInfo.videoUrl = detail.videoUrl
      this.videoInfo.videoNumber = detail.videoNumber
      this.videoInfo.isVip = detail.isVip
      if (detail.currentTime) {
        this.currentTime = detail.currentTime;
      }
    })
    .onHidden(() => {
    })
    .onShown(() => {
      if (TimeControl.timeControl(this.uiContext)) {
        this.globalInfo.navStack.pop();
        return;
      }
    })
    .hideTitleBar(true)
    .title(Title(this.videoInfo.title))
    .onBackPressed(() => {
      if (this.isLayoutFullScreen) {
        this.exitFullScreen()
        return true
      }
      // 异步执行历史记录保存，不阻塞返回
      void historyRecord(this.videoDetailInfo, this.videoInfo.videoNumber - 1, 0).then(() => {
        this.globalInfo.navStack.pop();
      });
      return true;
    })
  }
}

