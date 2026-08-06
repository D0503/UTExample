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
export struct ResolutionSheet {
  @Param @Require defaultResolution: string
  @Param onChangeResolution: (selectResolution: string) => void = () => {
  }
  private resolution: string[] = ['1080P 原画（高帧率）', '1080P 蓝光', '720P超清', '480P高清']
  @Local nowResolution: string = '1080P 原画（高帧率）'

  aboutToAppear(): void {
    this.nowResolution = this.defaultResolution
  }

  build() {
    Column() {
      Row() {
        Text('清晰度')
          .height(27)
          .width('100%')
          .fontColor($r('sys.color.font_primary'))
          .fontWeight(FontWeight.Bold)
          .fontSize($r('sys.float.Title_S'))
      }
      .height(56)
      .width('100%')
      .margin({ top: 8 })
      .justifyContent(FlexAlign.SpaceBetween)

      Column() {
        ForEach(this.resolution, (item: string) => {
          Row() {
            Text(item)
              .fontSize(16)
              .fontWeight(500)
              .fontColor(this.nowResolution === item ? $r('sys.color.multi_color_01') : '#e6000000')
          }
          .width('100%')
          .height(48)
          .onClick(() => {
            if (this.nowResolution === item) {
              return
            }
            this.onChangeResolution(item)
            this.nowResolution = item
          })
          .margin({ top: 16 })

          Divider()
        }, (item: string) => item)
      }
    }
  }
}