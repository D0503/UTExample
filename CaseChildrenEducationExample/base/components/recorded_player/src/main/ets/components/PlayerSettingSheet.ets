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

@ComponentV2
export struct PlayerSettingSheet {
  @Param @Require defaultSpeed: string
  @Param onChangeSpeed: (selectSpeed: string) => void = () => {
  }
  @Param settingItem: (selectItem: string) => void = () => {
  }
  private speeds: string[] = ['0.75', '1.0', '1.25', '1.5', '2.0']
  @Local nowSpeed: string = '1.0'

  getResource(item: string): Resource {
    if (item === '清晰度') {
      return $r('app.media.hd_plus_rectangle')
    } else if (item === '画中画') {
      return $r('app.media.icon_smal_window_playback_light')
    } else if (item === '分享') {
      return $r('app.media.icon_share_black')
    } else if (item === '举报') {
      return $r('app.media.exclamationmark_triangle')
    }
    return $r('app.media.hd_plus_rectangle')
  }

  aboutToAppear(): void {
    this.nowSpeed = this.defaultSpeed
  }

  build() {
    Column() {
      Row() {
        Text('设置')
          .width('100%')
          .height(27)
          .fontSize(20)
          .fontWeight(700)
      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 8 })

      Row() {
        Image($r('app.media.icon_speed_multiple_w'))
          .width(24)
          .height(24)
          .margin({ right: 10 })
        Text('倍速')
          .fontSize($r('sys.float.Subtitle_M'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
          .margin({ right: 24 })

        Row({ space: 20 }) {
          ForEach(this.speeds, (item: string) => {
            Text(`${item}`)
              .fontSize($r('sys.float.Subtitle_S'))
              .fontWeight(this.nowSpeed === item ? FontWeight.Bold : FontWeight.Regular)
              .textAlign(TextAlign.Center)
              .fontColor(this.nowSpeed === item ? $r('sys.color.multi_color_01') : $r('sys.color.font_primary'))
              .onClick(() => {
                if (this.nowSpeed === item) {
                  return
                }
                this.onChangeSpeed(item)
                this.nowSpeed = item
              })
          }, (item: string, index: number) => item + index)
        }
      }
      .width('100%')
      .height(48)

      Column() {
        ForEach(['清晰度', '画中画', '分享', '举报'], (item: string) => {
          Row() {
            Image(this.getResource(item))
              .width(24)
              .height(24)
              .margin({ right: 10 })

            Text(item)
              .fontSize($r('sys.float.Subtitle_M'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
          }
          .width('100%')
          .height(48)
          .onClick(() => {
            this.settingItem(item)
          })
          .margin({ top: 16 })
        }, (item: string) => item)
      }
    }
  }
}