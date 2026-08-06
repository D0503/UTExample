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

import { image } from '@kit.ImageKit';
import { PlayerVM } from '../viewModels/PlayerVM';
import { ResolutionSheet } from './ResolutionSheet';
import { PlayerSettingSheet } from './PlayerSettingSheet';
import { batteryInfo, BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { ReportSheet } from './ReportSheet';
import { ReportItem } from '../models/Type';
import { window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

// 定义订阅者，用于保存创建成功的订阅者对象，后续使用其完成订阅及退订的动作
let subscriber: commonEventManager.CommonEventSubscriber;
// 订阅者信息
let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
  events: ['usual.event.POWER_CONNECTED', 'usual.event.POWER_DISCONNECTED']
};

@ComponentV2
export struct TopControl {
  logTag: string = 'TopControl';
  domainId: number = 0x0000;
  @Param playerTitle: string = '01 课程章节目录名称';
  @Param isLock: boolean = false;
  @Param isLayoutFullScreen: boolean = false;
  @Param currentTime: string = '';
  // 横竖屏切换事件
  @Param fullScreen: (isLayoutFullScreen: boolean) => void = () => {
  }
  // 更多事件
  @Param moreEvent: () => void = () => {
  }
  // 倍速切换事件
  @Param speedEvent: (speed: string) => void = () => {
  }
  // 分辨率切换事件
  @Param resolutionEvent: (resolution: string) => void = () => {
  }
  // 画中画事件
  @Param pipWindowEvent: () => void = () => {
  }
  // 退出事件
  @Param onExit: () => void = () => {
  }
  // 分享事件
  @Param onShare: () => void = () => {
  }
  // 举报事件
  @Param onReport: (reasons: string[], reason: string) => void = () => {
  }
  // 清晰度
  @Local isShowDefinitionSheet: boolean = false;
  // 设置
  @Local isShowSettingSheet: boolean = false;
  @Local isShowReport: boolean = false;
  @Local playerVM: PlayerVM = PlayerVM.instance;
  @Local speedIcon: Resource = $r('app.media.icon_speed_100percent');
  @Local reportPixmap: image.PixelMap | undefined = undefined
  @Local keyboardHeight: number = 0;

  @Monitor('playerVM.speed','playerVM.resolution')
  onChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      if (path === 'playerVM.speed') {
        let speed = monitor.value(path)?.now as string
        this.speedIcon = this.setSpeedIcon(speed)
      } else if (path === 'playerVM.resolution') {
      }
    })
  }

  @Builder
  landscapeTop() {
    if (this.isLock) {
      Row() {
        Image($r('app.media.icon_chevron_backward_dark'))
          .width(40)
          .height(40)
          .onClick(() => {
            this.fullScreen(false)
          })
      }
      .justifyContent(FlexAlign.Start)
      .width('100%')
      .height('100%')
      .padding({ top: 20, left: 24 })
    } else {
      Row() {
        Stack({ alignContent: Alignment.Center }) {
          Circle()
            .width(40)
            .height(40)
            .fill($r('sys.color.comp_background_tertiary'))

          SymbolGlyph($r('sys.symbol.chevron_left'))
            .fontColor([$r('sys.color.icon_on_primary')])
            .fontSize(24)
        }
        .id('player-back-button')
        .onClick(() => {
          this.fullScreen(false)
        })

        Text(this.playerVM.movieItem.movieTitle)
          .fontSize($r('sys.float.Title_S'))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .visibility(this.playerVM.movieItemList.length > 1 ? Visibility.Visible : Visibility.None)

        Blank()
          .layoutWeight(1)

        Stack({ alignContent: Alignment.Center }) {
          Circle()
            .width(40)
            .height(40)
            .fill($r('sys.color.comp_background_tertiary'))

          SymbolGlyph($r('sys.symbol.share'))
            .fontSize(24)
            .fontColor([$r('sys.color.icon_on_primary')])
        }
        .onClick(() => {
          this.onShare()
        })

        Image(this.playerVM.isCharge ? $r('app.media.battery_bolt') : $r('app.media.battery_60percent'))
          .width(24)
          .height(12)
          .margin({ left: 16 })
        Text(this.currentTime)
          .fontSize($r('sys.float.Body_S'))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 8 })
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .height('100%')
      .padding({ top: 16, left: 24, right: 24 })
      .linearGradient({
        direction: GradientDirection.Top,
        colors: [['#00990000', 0.0], ['#80000000', 1.0]]
      })
      .visibility(this.isLayoutFullScreen ? Visibility.Visible : Visibility.Hidden)
    }
  }

  @Builder
  verticalTop() {
    Row() {
      Stack({ alignContent: Alignment.Center }) {
        Circle()
          .width(40)
          .height(40)
          .fill($r('sys.color.comp_background_tertiary'))

        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24)
          .fontColor([$r('sys.color.icon_on_primary')])
      }
      .id('player-back-button')
      .margin({ left: 16, top: 8 })
      .onClick(() => {
        this.onExit()
      })

      Stack({ alignContent: Alignment.Center }) {
        Circle()
          .width(40)
          .height(40)
          .fill($r('sys.color.comp_background_tertiary'))

        SymbolGlyph($r('sys.symbol.share'))
          .fontColor([$r('sys.color.icon_on_primary')])
          .fontSize(24)
      }
      .margin({ right: 16, top: 8 })
      .onClick(() => {
        this.onShare()
      })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Top)
    .width('100%')
    .height('100%')
    .padding({ top: 5 })
    .linearGradient({
      direction: GradientDirection.Top,
      colors: [['#00990000', 0.0], ['#80000000', 1.0]]
    })
    .visibility(this.isLayoutFullScreen ? Visibility.Hidden : Visibility.Visible)
  }

  @Builder
  playerSettingBuilder() {
    Column() {
      PlayerSettingSheet({
        defaultSpeed: this.playerVM.speed,
        onChangeSpeed: (selectSpeed: string) => {
          this.speedEvent(selectSpeed)
        },
        settingItem: (selectItem: string) => {
          if (selectItem === '清晰度') {
            this.isShowDefinitionSheet = true
          } else if (selectItem === '画中画') {
            this.pipWindowEvent()
          } else if (selectItem === '分享') {
            this.onShare()
            this.isShowSettingSheet = false
          } else if (selectItem === '举报') {
            this.getUIContext().getComponentSnapshot().get('XComponent01', (error: Error, pixmap: image.PixelMap) => {
              if (error) {
                return;
              }
              this.reportPixmap = pixmap
              this.isShowReport = true
              this.playerVM.reasonList.forEach((item: ReportItem) => {
                item.isSelected = false
              })
            })
          } else {
          }
        }
      })
        .width('90%')
        .height(350)
    }
    .width('100%')
    .height(350)
  }

  @Builder
  definitionBuilder() {
    Column() {
      ResolutionSheet({
        defaultResolution: this.playerVM.resolution,
        onChangeResolution: (selectResolution: string) => {
          this.resolutionEvent(selectResolution)
        }
      })
        .width('90%')
        .height(350)
    }
    .width('100%')
    .height(350)
  }

  @Builder
  reportBuilder() {
    Column() {
      ReportSheet({
        reportPixmap: this.reportPixmap,
        onReport: (reasons: string[], reason: string) => {
          this.onReport(reasons, reason)
          this.isShowReport = false
        }
      })
        .width('90%')
        .height(500)
    }
    .width('100%')
    .height(500)
  }

  setSpeedIcon(speed: string): Resource {
    if (speed === '0.75') {
      return $r('app.media.icon_speed_75percent');
    } else if (speed === '1.0') {
      return $r('app.media.icon_speed_100percent');
    } else if (speed === '1.25') {
      return $r('app.media.icon_speed_125percent');
    } else if (speed === '1.5') {
      return $r('app.media.icon_speed_150percent');
    } else if (speed === '2.0') {
      return $r('app.media.icon_speed_200percent');
    }
    return $r('app.media.icon_speed_100percent');
  }

  aboutToAppear(): void {
    try {
      commonEventManager.createSubscriber(subscribeInfo, createCB);
    } catch (error) {
    }
    getBatteryInfo()
    this.speedIcon = this.setSpeedIcon(this.playerVM.speed)
    window.getLastWindow(this.getUIContext().getHostContext()).then((currentWindow: window.Window) => {
      currentWindow.on('avoidAreaChange', data => {
        if (data.type === window.AvoidAreaType.TYPE_KEYBOARD) {
          if (data.area.bottomRect.height === 0) {
            this.keyboardHeight = 0
          } else {
            this.keyboardHeight = 100;
          }
        }
      })
    }).catch((error: BusinessError) => {
      hilog.error(this.domainId, this.logTag,
        `Error occurred. errCode is ${error.code}, errMessage is ${error.message}`);
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 横屏
      this.landscapeTop()
      // 竖屏
      this.verticalTop()
    }
    .width('100%')
    .height(this.isLayoutFullScreen ? 80 : 48)
  }
}

function getBatteryInfo() {
  let batterySOCInfo: number = batteryInfo.batterySOC;
  let chargingStatusInfo = batteryInfo.chargingStatus;
  if (chargingStatusInfo === 1 || chargingStatusInfo === 3) {
    PlayerVM.instance.isCharge = true
  } else {
    PlayerVM.instance.isCharge = false
  }
  PlayerVM.instance.charge = batterySOCInfo
}

function createCB(err: BusinessError, commonEventSubscriber: commonEventManager.CommonEventSubscriber) {
  if (!err) {
    subscriber = commonEventSubscriber;
    try {
      commonEventManager.subscribe(subscriber, subscribeCB);
    } catch (error) {
    }
  }
}

// 订阅公共事件回调
function subscribeCB(err: BusinessError, data: commonEventManager.CommonEventData) {
  getBatteryInfo()
}
