/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { emitter } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import { MovieItem, ReportItem } from '../models/Type';
import { PipManager } from '../tools/PipManager';
import { PlayerVM } from '../viewModels/PlayerVM';
import { BottomControl } from './BottomControl'
import { FullScreenMore } from './FullScreenMore';
import { FullScreenReport } from './FullScreenReport';
import { FullScreenResolution } from './FullScreenResolution';
import { FullScreenSelections } from './FullScreenSelections';
import { FullScreenSpeed } from './FullScreenSpeed';
import { TopControl } from './TopControl'
import { hilog } from '@kit.PerformanceAnalysisKit';

const controllerDelay = 2000; // 控制器时延

@ComponentV2
export struct PlayerControl {
  logTag: string = 'PlayerControl';
  domainId: number = 0x0000;
  // 横竖屏切换事件
  @Param fullScreen: (isLayoutFullScreen: boolean) => void = () => {
  }
  // 退出事件
  @Param exitEvent: () => void = () => {
  }
  // 分享事件
  @Param shareEvent: () => void = () => {
  }
  // 选集
  @Param selectionEvent: (item: MovieItem) => void = () => {
  }
  @Param playerIndex: number = 0
  @Param isLayoutFullScreen: boolean = false;
  // 控制面板
  @Local isShowControl: boolean = true;
  // 面板上锁
  @Local isLock: boolean = false;
  // 展示更多面板
  @Local isShowMore: boolean = false;
  // 选集
  @Local isShowSelection: boolean = false;
  @Local playerVM: PlayerVM = PlayerVM.instance;
  @Local currentTime: string = '';
  private timer: number = 0;

  aboutToAppear(): void {
    this.resetTimer()
    this.currentTime = this.getCurrentTime()
    this.switchEmitter()
  }

  getCurrentTime(): string {
    let timestamp = Date.now();
    let date = new Date(timestamp);
    const hour = ('0' + date.getHours()).slice(-2);
    const min = ('0' + date.getMinutes()).slice(-2);
    return `${hour}:${min}`;
  }

  resetTimer() {
    clearTimeout(this.timer)
    this.timer = setTimeout(() => {
      this.isShowControl = false;
    }, controllerDelay)
  }

  getSpeed(speed: string): number {
    if (speed === '0.75') {
      return 0
    } else if (speed === '1.0') {
      return 1
    } else if (speed === '1.25') {
      return 2
    } else if (speed === '1.5') {
      return 6
    } else if (speed === '2.0') {
      return 4
    }
    return 1
  }

  switchSpeed(speed: string): string {
    let idx = this.playerVM.speedItemList.indexOf(speed)
    if (idx >= this.playerVM.speedItemList.length - 1) {
      idx = 0
    } else {
      idx = idx + 1
    }
    return this.playerVM.speedItemList[idx]
  }

  switchMovie() {
    if (this.playerVM.movieItemList.length === 1) {
      return
    }
    let idx = this.playerVM.movieItemList.indexOf(this.playerVM.movieItem)
    if (idx >= this.playerVM.movieItemList.length - 1) {
      idx = 0
    } else {
      idx = idx + 1
    }
    this.playerVM.movieItem = this.playerVM.movieItemList[idx]
    try {
      this.getUIContext().getPromptAction().showToast({ message: `${this.playerVM.movieItem.movieTitle}正在播放` })
    } catch (error) {
      hilog.error(this.domainId, this.logTag,
        `Error occurred. errCode is ${error.code}, errMessage is ${error.message}`);
    }
    PipManager.getInstance().player.changePlay(this.playerVM.movieItem.movieUrl,
      this.playerVM.movieItem.learnProgress)
    this.selectionEvent(this.playerVM.movieItem)
  }

  switchEmitter() {
    emitter.on('movieSelections', (event: emitter.EventData) => {
      let idx = this.playerVM.movieItemList.indexOf(this.playerVM.movieItem)
      let indexNumber = event.data!.movieSelection as number
      if (idx === indexNumber && this.playerVM.movieItem.movieUrl === PipManager.getInstance().player.videoUrl) {
        return
      }
      this.playerVM.movieItem = this.playerVM.movieItemList[indexNumber]
      this.getUIContext().getPromptAction().showToast({ message: `${this.playerVM.movieItem.movieTitle}正在播放` })
      if (PipManager.getInstance().player.isPipOpen &&
        this.playerVM.movieItem.movieUrl !== PipManager.getInstance().player.videoUrl) {
        PipManager.getInstance().stopPip()
      }
      PipManager.getInstance().player.changePlay(this.playerVM.movieItem.movieUrl,
        this.playerVM.movieItem.learnProgress)
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Column() {
        TopControl({
          isLock: this.isLock,
          currentTime: this.currentTime,
          isLayoutFullScreen: this.isLayoutFullScreen,
          fullScreen: (isLayoutFullScreen: boolean) => {
            if (!isLayoutFullScreen) {
              this.isLock = false
            }
            this.fullScreen(isLayoutFullScreen)
          },
          moreEvent: () => {
            this.isShowMore = true
          },
          speedEvent: (speed: string) => {
            if (speed === '') {
              speed = this.switchSpeed(this.playerVM.speed)
            }
            this.playerVM.speed = speed
            PipManager.getInstance().player.changeSpeed(this.getSpeed(speed))
            this.getUIContext().getPromptAction().showToast({ message: `已切换${speed}倍速` })
          },
          resolutionEvent: (resolution: string) => {
            this.playerVM.resolution = resolution
            this.getUIContext().getPromptAction().showToast({ message: `已切换${resolution}` })
          },
          pipWindowEvent: () => {
            this.fullScreen(false)
            PipManager.getInstance().startPip()
          },
          onExit: () => {
            this.fullScreen(false)
            this.exitEvent()
          },
          onShare: () => {
            this.fullScreen(false)
            this.shareEvent()
          },
          onReport: () => {
            this.getUIContext().getPromptAction().showToast({ message: '举报成功' })
          }
        })
          .width('100%')
          .height(this.isLayoutFullScreen ? 80 : 48)

        Column() {
          Image(this.isLock ? $r('app.media.icon_lock_close_fill') :
            $r('app.media.icon_lock_open_fill'))
            .id('isPlaying')
            .width(40)
            .height(40)
            .onClick(() => {
              this.isLock = !this.isLock
            })
        }
        .padding({ right: 24 })
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.End)
        .width('100%')
        .layoutWeight(1)
        .visibility(this.isLayoutFullScreen ? Visibility.Visible : Visibility.Hidden)

        BottomControl({
          isLock: this.isLock,
          isLayoutFullScreen: this.isLayoutFullScreen,
          fullScreen: (isLayoutFullScreen: boolean) => {
            this.fullScreen(isLayoutFullScreen)
          },
          selectionsEvent: () => {
            this.isShowMore = false;
            this.isShowSelection = true
          },
          nextSelectionsEvent: () => {
            this.switchMovie()
          }
        })
          .width('100%')
          .height(this.isLayoutFullScreen ? 80 : 48)
      }
      .visibility(this.isShowControl ? Visibility.Visible : Visibility.Hidden)
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height('100%')

      if (this.isLayoutFullScreen) {
        if (this.isShowMore) {
          Column() {
            MoreSetControl({
              speedEvent: (speed: string) => {
                if (speed === '') {
                  speed = this.switchSpeed(this.playerVM.speed)
                }
                this.playerVM.speed = speed
                PipManager.getInstance().player.changeSpeed(this.getSpeed(speed))
                this.getUIContext().getPromptAction().showToast({ message: `已切换${speed}倍速` })
              },
              resolutionEvent: (resolution: string) => {
                this.playerVM.resolution = resolution
                this.getUIContext().getPromptAction().showToast({ message: `已切换${resolution}` })
              },
              pipWindowEvent: () => {
                this.fullScreen(false)
                this.isShowMore = false
                PipManager.getInstance().startPip()
              },
              reportEvent: () => {
                this.isShowMore = false
                this.getUIContext().getPromptAction().showToast({ message: '举报成功' })
              },
              shareEvent: () => {
                this.isShowMore = false
                this.shareEvent()
              }
            })
          }
          .backgroundColor($r('sys.color.mask_secondary'))
          .backgroundBlurStyle(BlurStyle.BACKGROUND_THIN)
          .opacity(0.9)
          .width(368)
          .height('100%')
          .zIndex(1)
          .onClick(() => {
          })
        }
        if (this.isShowSelection) {
          Column() {
            FullScreenSelections({
              backClick: () => {
                this.isShowMore = false
                this.isShowSelection = false
              },
              selectionEvent: (item: MovieItem) => {
                this.playerVM.movieItem = item
                this.getUIContext().getPromptAction().showToast({ message: `${item.movieTitle}正在播放` })
                PipManager.getInstance().player.changePlay(item.movieUrl, this.playerVM.movieItem.learnProgress)
                this.selectionEvent(item)
              }
            })
          }
          .backgroundColor($r('sys.color.mask_secondary'))
          .opacity(0.9)
          .backgroundBlurStyle(BlurStyle.BACKGROUND_THIN)
          .width(368)
          .height('100%')
          .zIndex(1)
          .onClick(() => {
          })
        }
      }
    }
    .id('player-control-bar')
    .width('100%')
    .height('100%')
    .onClick(() => {
      this.isShowMore = false
      this.isShowSelection = false
    })
    .onTouch(() => {
      this.currentTime = this.getCurrentTime()
      this.isShowControl = true;
      this.resetTimer()
      this.playerVM.reasonList.forEach((item: ReportItem) => {
        item.isSelected = false
      })
    })
  }
}

@ComponentV2
export struct MoreSetControl {
  logTag: string = 'MoreSetControl';
  domainId: number = 0x0000;
  // 倍速切换事件
  @Param speedEvent: (speed: string) => void = () => {
  }
  // 分辨率切换事件
  @Param resolutionEvent: (resolution: string) => void = () => {
  }
  // 画中画事件
  @Param pipWindowEvent: () => void = () => {
  }
  // 举报事件
  @Param reportEvent: (reasons: string[], reason: string) => void = () => {
  }
  // 分享事件
  @Param shareEvent: () => void = () => {
  }
  @Local playerVM: PlayerVM = PlayerVM.instance;
  // 是否展示更多
  @Local isShowMore: boolean = true;
  // 是否展示倍速
  @Local isShowSpeed: boolean = false;
  // 是否展示清晰度
  @Local isShowResolution: boolean = false;
  // 是否展示举报
  @Local isShowReport: boolean = false;
  @Local reportPixmap: image.PixelMap | undefined = undefined

  @Builder
  moreBuild() {
    FullScreenMore({
      moreItemEvent: (item: string) => {
        this.moreItemEvent(item)
      }
    })
      .width('100%')
      .height('100%')
      .visibility(this.isShowMore ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  speedBuild() {
    FullScreenSpeed({
      backClick: () => {
        this.isShowMore = true
        this.isShowSpeed = false
      },
      speedEvent: (speed: string) => {
        this.speedEvent(speed)
      }
    })
      .width('100%')
      .height('100%')
      .visibility(this.isShowSpeed ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  resolutionBuild() {
    FullScreenResolution({
      backClick: () => {
        this.isShowMore = true
        this.isShowResolution = false
      },
      resolutionEvent: (resolution: string) => {
        this.resolutionEvent(resolution)
      }
    })
      .width('100%')
      .height('100%')
      .visibility(this.isShowResolution ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  reportBuild() {
    FullScreenReport({
      reportPixmap: this.reportPixmap,
      backClick: () => {
        this.isShowMore = true
        this.isShowReport = false
        this.playerVM.reasonList.forEach((item: ReportItem) => {
          item.isSelected = false
        })
      },
      onReport: (reasons: string[], reason: string) => {
        this.reportEvent(reasons, reason)
      }
    })
      .width('100%')
      .height('100%')
      .visibility(this.isShowReport ? Visibility.Visible : Visibility.Hidden)
  }

  moreItemEvent(item: string) {
    this.isShowMore = false
    if (item === '分享') {
      this.shareEvent()
    } else if (item === '倍速') {
      this.isShowSpeed = true
    } else if (item === '画中画') {
      this.pipWindowEvent()
    } else if (item === '清晰度') {
      this.isShowResolution = true
    } else if (item === '举报') {
      this.getUIContext().getComponentSnapshot().get('XComponent01', (error: Error, pixmap: image.PixelMap) => {
        if (error) {
          return;
        }
        this.reportPixmap = pixmap
      })

      this.isShowReport = true
    } else {
    }
  }

  shareItemEvent(item: string) {
    if (item === '微信') {
    } else if (item === '朋友圈') {
    } else if (item === 'QQ') {
    } else if (item === '生成海报') {
    } else if (item === '复制链接') {
    } else if (item === '系统分享') {
    } else {
    }
    try {
      this.getUIContext().getPromptAction().showToast({ message: `暂不支持${item}` })
    } catch (error) {
      hilog.error(this.domainId, this.logTag,
        `Error occurred. errCode is ${error.code}, errMessage is ${error.message}`);
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      this.moreBuild()
      this.speedBuild()
      this.resolutionBuild()
      this.reportBuild()
    }
    .width('100%')
    .height('100%')
  }
}
