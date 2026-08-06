/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { emitter } from '@kit.BasicServicesKit';
import { uiObserver, window } from '@kit.ArkUI';
import { PipManager } from '../tools/PipManager';
import { PlayerControl } from '../components/PlayerControl';
import { PlayerView } from '../components/PlayerView';
import { PlayerVM } from '../viewModels/PlayerVM';
import { AVPlayer } from '../tools/AVPlayer';
import { MovieItem } from '../models/Type';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const controllerDelay = 2000; // 控制器时延

@ComponentV2
export struct PlayerComponent {
  logTag: string = 'PlayerComponent';
  domainId: number = 0x0000;
  @Local videoHeight: number = 100
  @Param @Require movieItems: MovieItem[] = []
  @Param @Require playerIndex: number = 0
  @Param showMaskLayer: boolean = false
  // 选集
  @Param selectionEvent: (idx: number) => void = () => {
  }
  @Param fullScreenEvent: (isLayoutFullScreen: boolean) => void = () => {
  }
  @Param callbackTimeUpdate: (nol: number, total: number) => void = () => {
  };
  // 退出事件
  @Event exitEvent: () => void = () => {
  }
  // 分享事件
  @Param shareEvent: () => void = () => {
  }
  // 控制器是否显示
  @Local controlShow: boolean = false;
  // 是否全屏
  @Local isLayoutFullScreen: boolean = false;
  // 清晰度
  @Local isShowDefinitionSheet: boolean = false;
  // 设置
  @Local isShowSettingSheet: boolean = false;
  @Local playerVM: PlayerVM = PlayerVM.instance;
  @Local player: AVPlayer = PipManager.getInstance().player;
  @Local windowStatusType: number = 0;
  @Local componentHeight: string = '100%';
  mWindow?: window.Window;
  private timer: number = -1;
  private uiContext: UIContext = this.getUIContext() as UIContext;
  private context: common.UIAbilityContext = this.uiContext.getHostContext() as common.UIAbilityContext;
  private windowClass = this.context.windowStage.getMainWindowSync();
  @BuilderParam customBuilderParam: () => void = this.customBuilder;
  @Event stateChange:(state:string) => void = (state:string) => {};

  @Builder
  customBuilder() {
  }

  @Monitor('player.isPlaying')
  onNameChange() {
    if (PipManager.getInstance().player.isResetPause) {
      PipManager.getInstance().player.getPause();
    } else {
      PipManager.getInstance().player.isPlaying ? PipManager.getInstance().player.getPlay() :
        PipManager.getInstance().player.getPause();
    }
  }

  // 设置窗口方向
  setR(orientation: number) {
    // window.getLastWindow(this.context).then((win) => {
    //   win.setPreferredOrientation(orientation).then(() => {
    //   }).catch(() => {
    //   })
    // }).catch(() => {
    // })
  }

  async aboutToAppear() {
    if (this.movieItems && this.movieItems.length > 0) {
      this.playerVM.movieItemList = this.movieItems
      this.playerVM.movieItem = this.playerVM.movieItemList[this.playerIndex]
    }
    PipManager.getInstance().init(this.context, this.playerVM.navId)
    window.getLastWindow(this.context).then((currentWindow: window.Window) => {
      this.mWindow = currentWindow;
      // 获取窗口属性
      try {
        let properties = currentWindow.getWindowProperties();
        let rect = properties.windowRect;
        if (this.getUIContext().px2vp(rect.height) <= 680) {
          this.windowStatusType = 5
          this.playerVM.windowStatusType = this.windowStatusType
          this.isLayoutFullScreen = false
          this.setR(1)
        }
        currentWindow.on('windowStatusChange', (windowStatusType) => {
          this.windowStatusType = windowStatusType
          this.playerVM.windowStatusType = this.windowStatusType
          if (windowStatusType === 5) {
            this.isLayoutFullScreen = false
            this.setR(1)
          }
        });
      } catch (error) {
        hilog.error(this.domainId, this.logTag,
          `Error occurred. errCode is ${error.code}, errMessage is ${error.message}`);
      }
    }).catch((error: BusinessError) => {
      hilog.error(this.domainId, this.logTag,
        `Error occurred. errCode is ${error.code}, errMessage is ${error.message}`);
    })

    emitter.on('playerPause', (event: emitter.EventData) => {
      let isPlaying = event.data!.isPlaying as boolean
      if (isPlaying) {
        PipManager.getInstance().player.isResetPause = false
        PipManager.getInstance().player.isPlaying = true
      } else {
        PipManager.getInstance().player.isResetPause = true
        PipManager.getInstance().player.isPlaying = false
      }
    })
    emitter.on('autoStartPip', () => {
      if (this.playerVM.autoStartEnabled) {
        if (PipManager.getInstance().player.isPipOpen) {
        } else {
          PipManager.getInstance().startPip()
          PipManager.getInstance().updatePiPControlStatus();
        }
      } else {
        if (PipManager.getInstance().player.isPipOpen) {
        } else {
          PipManager.getInstance().player.isPlaying = false
        }
      }
    })
    emitter.on('chapterDetailBack', () => {
      if (!PipManager.getInstance().player.isPipOpen) {
        // 释放AVPlayer资源
        PipManager.getInstance().stopPip()
        PipManager.getInstance().player.isCreate = true
        PipManager.getInstance().player.release();
      }
    })
    this.getUIContext().getUIObserver().on('navDestinationSwitch', this.releaseResource);
  }

  aboutToDisappear() {
    this.getUIContext().getUIObserver().off('navDestinationSwitch', this.releaseResource);
  }

  /**
   * 页面导航切换时释放播放器相关资源以及回调
   */
  releaseResource = (info: uiObserver.NavDestinationSwitchInfo) => {
    if (info.to.name === 'VideoPlayPage') {
      return
    }

    emitter.off('exitFullScreen')

    this.playerVM.movieItem.movieUrl = 'null'
    this.isLayoutFullScreen = false
    this.setR(this.isLayoutFullScreen ? 2 : 1)
    this.fullScreenEvent(false)

    this.windowClass.setWindowSystemBarProperties({
      statusBarColor: '#FFFFFF',
      statusBarContentColor: '#000000',
    })


    PipManager.getInstance().player.isCreate = true
    PipManager.getInstance().player.release()
  }

  getSpeed(selectItem: string): number {
    if (selectItem === '0.75') {
      return 0
    } else if (selectItem === '1.0') {
      return 1
    } else if (selectItem === '1.25') {
      return 2
    } else if (selectItem === '1.5') {
      return 6
    } else if (selectItem === '2.0') {
      return 4
    }
    return 1
  }

  resetTimer() {
    clearTimeout(this.timer)
    this.timer = setTimeout(() => {
      this.controlShow = false;
    }, controllerDelay)
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      // 视频层
      PlayerView({
        videoRatio: 16 / 9,
        showMaskLayer: this.showMaskLayer,
        callbackTimeUpdate: this.callbackTimeUpdate,
        customBuilderParam: this.customBuilderParam,
        stateChange:(state:string) => {
          this.stateChange(state);
        }
      })
        .width('100%')
        .height('100%')


      // 控制层
      PlayerControl({
        playerIndex: this.playerIndex,
        isLayoutFullScreen: this.isLayoutFullScreen,
        fullScreen: (isLayoutFullScreen: boolean) => {
          this.isLayoutFullScreen = isLayoutFullScreen
          this.fullScreenEvent(this.isLayoutFullScreen)
        },
        selectionEvent: (item: MovieItem) => {
          let idx = this.playerVM.movieItemList.indexOf(item)
          this.selectionEvent(idx)
        },
        exitEvent: () => {
          this.isLayoutFullScreen = false
          this.setR(this.isLayoutFullScreen ? 2 : 1)
          this.fullScreenEvent(this.isLayoutFullScreen)
          this.exitEvent()
        },
        shareEvent: () => {
          this.isLayoutFullScreen = false
          this.setR(this.isLayoutFullScreen ? 2 : 1)
          this.fullScreenEvent(this.isLayoutFullScreen)
          this.shareEvent()
        }
      })
        .visibility(this.showMaskLayer ? Visibility.Hidden : Visibility.Visible)
        .width('100%')
    }
    .width('100%')
  }
}
