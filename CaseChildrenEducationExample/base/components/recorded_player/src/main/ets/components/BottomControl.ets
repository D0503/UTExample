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

import { PipManager } from '../tools/PipManager';
import { getTimeString } from '../tools/TimeTools';
import { PlayerVM } from '../viewModels/PlayerVM';
import { emitter } from '@kit.BasicServicesKit';

const TAKE_SURPLUS = 100;

@ComponentV2
export struct BottomControl {
  @Param isLock: boolean = false;
  @Param isLayoutFullScreen: boolean = false;
  @Param fullScreen: (isLayoutFullScreen: boolean) => void = () => {
  };
  @Param selectionsEvent: () => void = () => {
  };
  @Param nextSelectionsEvent: () => void = () => {
  };
  @Local playerVM: PlayerVM = PlayerVM.instance;
  
  aboutToAppear(): void {
    emitter.on('exitFullScreen', (event: emitter.EventData) => {
      if (this.isLayoutFullScreen) {
        this.fullScreen(!this.isLayoutFullScreen);
      }
    })
  }

  aboutToDisappear(): void {
    emitter.off('exitFullScreen')
  }

  @Builder
  landscapeBottom() {
    Column() {
      Row() {
        Text(getTimeString(PipManager.getInstance().player.currentTime))
          .fontWeight(FontWeight.Regular)
          .fontSize($r('sys.float.Caption_M'))
          .fontColor(Color.White)

        Slider({
          value: Math.round(PipManager.getInstance().player.currentTime /
          PipManager.getInstance().player.totalDuration * TAKE_SURPLUS),
          max: 100,
          min: 0,
        })
          .trackThickness(4)
          .selectedColor($r('sys.color.comp_background_emphasize'))
          .layoutWeight(1)
          .trackColor($r('sys.color.comp_background_secondary'))
          .onChange((value: number, mode: SliderChangeMode) => {
            if (mode === SliderChangeMode.End) {
              PipManager.getInstance().player.isPlaying = true;
            } else {
              PipManager.getInstance().player.isPlaying = false;
            }
            PipManager.getInstance().player.currentTime =
              PipManager.getInstance().player.totalDuration * value / TAKE_SURPLUS;
            PipManager.getInstance().player.changeSeek(PipManager.getInstance().player.currentTime, 2);
          });
        Text(getTimeString(PipManager.getInstance().player.totalDuration))
          .fontColor(Color.White)
          .fontSize($r('sys.float.Caption_M'))
          .fontWeight(FontWeight.Regular);
      }
      .width('100%')
      .height(20);

      Row() {
        Image(PipManager.getInstance().player.isPlaying ? $r('app.media.pip_window_icon_play') :
          $r('app.media.pip_window_icon_pause'))
          .id('playing01')
          .width(24)
          .height(24)
          .margin({ right: 26 })
          .onClick(() => {
            PipManager.getInstance().player.isPlaying = !PipManager.getInstance().player.isPlaying;
          });
        Image($r('app.media.icon_forward_end_fill'))
          .width(24)
          .height(24)
          .visibility(this.playerVM.movieItemList.length > 1 ? Visibility.Visible : Visibility.None)
          .onClick(() => {
            if (!this.playerVM.isSelections) {
              this.getUIContext().getPromptAction().showToast({ message: '购买后可切换' });
              return;
            }
            this.nextSelectionsEvent();
          });
        Blank()
          .layoutWeight(1);

        Text('选集')
          .textAlign(TextAlign.Center)
          .fontSize($r('sys.float.Caption_L'))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
          .borderRadius(4)
          .backgroundColor('rgba(0,0,0,0.5)')
          .padding({
            top: 5,
            bottom: 5,
            right: 10,
            left: 10
          })
          .visibility(this.playerVM.movieItemList.length > 1 ? Visibility.Visible : Visibility.None)
          .onClick(() => {
            if (!this.playerVM.isSelections) {
              this.getUIContext().getPromptAction().showToast({ message: '购买后可切换' });
              return;
            }
            this.selectionsEvent();
          });
        Text(this.playerVM.resolution)
          .textAlign(TextAlign.Center)
          .fontSize($r('sys.float.Caption_L'))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
          .borderRadius(4)
          .backgroundColor('rgba(0,0,0,0.5)')
          .margin({ left: 16 })
          .padding({
            top: 5,
            bottom: 5,
            right: 10,
            left: 10
          });
        Image($r('app.media.icon_multi_screen_collaboration'))
          .id('player-exit-fullscreen-button')
          .width(30)
          .height(30)
          .margin({ left: 16 })
          .onClick(() => {
            this.fullScreen(this.isLayoutFullScreen ? false : true);
          });
      }
      .margin({ top: 5 })
      .layoutWeight(1);
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .height('100%')
    .padding({
      left: 24,
      right: 50,
      top: 10,
      bottom: 20
    })
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [['#00990000', 0.0], ['#80000000', 1.0]]
    })
    .visibility(this.isLayoutFullScreen ? Visibility.Visible : Visibility.Hidden);
  }

  @Builder
  verticalBottom() {
    Row() {
      Image(PipManager.getInstance().player.isPlaying ? $r('app.media.pip_window_icon_play') :
        $r('app.media.pip_window_icon_pause'))
        .id('playing02')
        .width(24)
        .height(24)
        .margin({ left: 12, right: 8 })
        .onClick(() => {
          PipManager.getInstance().player.isPlaying = !PipManager.getInstance().player.isPlaying;
        });
      Row() {
        Text(getTimeString(PipManager.getInstance().player.currentTime))
          .fontSize($r('sys.float.Caption_M'))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Regular);
        Slider({
          value: Math.round(PipManager.getInstance().player.currentTime /
          PipManager.getInstance().player.totalDuration * TAKE_SURPLUS),
          min: 0,
          max: 100
        })
          .selectedColor($r('sys.color.comp_background_emphasize'))
          .trackThickness(4)
          .layoutWeight(1)
          .trackColor($r('sys.color.comp_background_secondary'))
          .onChange((val: number, mode: SliderChangeMode) => {
            if (mode === SliderChangeMode.End) {
              PipManager.getInstance().player.isPlaying = true;
            } else {
              PipManager.getInstance().player.isPlaying = false;
            }
            PipManager.getInstance().player.currentTime =
              PipManager.getInstance().player.totalDuration * val / TAKE_SURPLUS;
            PipManager.getInstance().player.changeSeek(PipManager.getInstance().player.currentTime, 2);
          });
        Text(getTimeString(PipManager.getInstance().player.totalDuration))
          .fontSize($r('sys.float.Caption_M'))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Regular);
      }
      .layoutWeight(1)
      .height(25);

      Image($r('app.media.icon_multi_screen_collaboration'))
        .id('player-fullscreen-button')
        .width(24)
        .height(24)
        .margin({ left: 8, right: 12 })
        .onClick(() => {
          if (this.playerVM.windowStatusType === 5) {
            this.getUIContext().getPromptAction().showToast({ message: '分屏下不支持切换' });
            return;
          }
          this.fullScreen(!this.isLayoutFullScreen);
        });
    }
    .alignItems(this.isLayoutFullScreen ? VerticalAlign.Top : VerticalAlign.Bottom)
    .width('100%')
    .height('100%')
    .padding({ bottom: 5 })
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [['#00990000', 0.0], ['#80000000', 1.0]]
    })
    .visibility(this.isLayoutFullScreen ? Visibility.Hidden : Visibility.Visible);
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      this.landscapeBottom();
      this.verticalBottom();
    }
    .visibility(this.isLock ? Visibility.Hidden : Visibility.Visible)
    .width('100%')
    .height('100%');
  }
}
