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

import { image } from '@kit.ImageKit'
import { ReportItem } from '../models/Type'
import { PlayerVM } from '../viewModels/PlayerVM'

@ComponentV2
export struct ReportSheet {
  @Param @Require reportPixmap: image.PixelMap
  @Param onReport: (reasons: string[], reason: string) => void = () => {
  }
  @Local reasons: Array<string> = []
  @Local inputLength: number = 0
  @Local playerVM: PlayerVM = PlayerVM.instance;
  private reason: string = ''

  build() {
    Column() {
      Row() {
        Text('请选择举报原因')
          .height(27)
          .width('100%')
          .fontColor($r('sys.color.font_primary'))
          .fontSize($r('sys.float.Title_S'))
          .fontWeight(FontWeight.Bold)
      }
      .height(56)
      .width('100%')
      .margin({ top: 8 })
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Image(this.reportPixmap)
          .width(176)
          .height(100)
      }
      .width('100%')
      .height(100)
      .margin({ top: 16 })
      .justifyContent(FlexAlign.Center)

      Column({ space: 4 }) {
        Grid() {
          ForEach(this.playerVM.reasonList, (item: ReportItem, index: number) => {
            GridItem() {
              Text(item.reason)
                .width(104)
                .height(28)
                .borderRadius(14)
                .backgroundColor(!item.isSelected ? $r('sys.color.comp_background_tertiary') :
                  '#E84026')
                .fontSize($r('sys.float.Body_M'))
                .margin({ top: 6, bottom: 6 })
                .textAlign(TextAlign.Center)
                .fontColor(!item.isSelected ? $r('sys.color.font_primary') : $r('sys.color.font_on_primary'))
                .fontWeight(FontWeight.Medium)
                .onClick(() => {
                  if (item.isSelected) {
                    this.reasons.splice(this.reasons.indexOf(item.reason), 1)
                  } else {
                    this.reasons.push(item.reason)
                  }
                  this.playerVM.reasonList[index].isSelected =
                    !this.playerVM.reasonList[index].isSelected
                })
            }
          }, (item: ReportItem, index: number) => JSON.stringify(item) + index)
        }
        .columnsTemplate('1fr 1fr 1fr')
        .rowsTemplate('1fr 1fr')
        .columnsGap(8)
        .rowsGap(4)
        .width('100%')
        .height(84)

        Stack({ alignContent: Alignment.BottomEnd }) {
          TextArea({ placeholder: '请输入详细举报内容，便于平台鉴定违规情况（非必选）' })
            .width('100%')
            .height(72)
            .borderRadius(4)
            .padding({ top: 8, left: 8, right: 8 })
            .fontSize($r('sys.float.Body_M'))
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .placeholderFont({ size: 12 })
            .placeholderColor($r('sys.color.font_tertiary'))
            .maxLength(30)
            .onChange((value: string) => {
              this.inputLength = value.length
              this.reason = value
            })
          Text(`${this.inputLength}/30`)
            .height(16)
            .fontSize($r('sys.float.Caption_L'))
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.font_tertiary'))
            .margin({ right: 8, bottom: 8 })
        }
        .width('100%')
        .height(72)
      }
      .width('100%')
      .padding({ top: 16, bottom: 16 })

      Row() {
        Button('提交')
          .width('100%')
          .height(40)
          .borderRadius(20)
          .backgroundColor('#E84026')
          .fontColor($r('sys.color.font_on_primary'))
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .onClick(() => {
            if (this.reasons.length === 0) {
              this.getUIContext().getPromptAction().showToast({ message: '请选择举报原因后提交' })
              return
            }
            this.playerVM.reasonList.forEach((item: ReportItem) => {
              item.isSelected = false
            })
            this.onReport(this.reasons, this.reason)
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
  }
}