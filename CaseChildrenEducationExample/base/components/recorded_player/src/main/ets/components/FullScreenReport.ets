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
export struct FullScreenReport {
  logTag: string = 'FullScreenReport';
  domainId: number = 0x0000;
  @Param @Require reportPixmap: image.PixelMap
  @Param backClick: () => void = () => {
  }
  @Param onReport: (reasons: string[], reason: string) => void = () => {
  }
  @Local isEditing: boolean = false
  @Local reasons: Array<string> = []
  @Local inputLength: number = 0
  @Local playerVM: PlayerVM = PlayerVM.instance;
  @Local reportHeight: number = 300
  private reason: string = ''

  build() {
    Column() {
      Row() {
        Image($r('app.media.icon_chevron_backward_dark')).width(40).height(40).margin({ right: 8 })
          .onClick(() => {
            this.backClick()
          })
        Text('举报').fontSize($r('sys.float.Title_S')).fontColor(Color.White).fontWeight(FontWeight.Bold)
      }.margin({ top: 20, bottom: 10 })

      Scroll() {
        Column() {
          Row() {
            Image(this.reportPixmap).width(176).height(100)
          }
          .width('100%')
          .height(100)
          .margin({ top: 8 })
          .justifyContent(FlexAlign.Center)

          Grid() {
            ForEach(
              this.playerVM.reasonList,
              (item: ReportItem, index: number) => {
                GridItem() {
                  Text(item.reason)
                    .width(104)
                    .height(28)
                    .borderRadius(14)
                    .backgroundColor(!item.isSelected ? $r('sys.color.comp_background_tertiary') :
                    $r('sys.color.multi_color_01'))
                    .fontSize($r('sys.float.Body_M'))
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#fff')
                    .textAlign(TextAlign.Center)
                    .margin({ top: 6, bottom: 6 })
                    .onClick(() => {
                      if (!item.isSelected) {
                        this.reasons.push(item.reason)
                      } else {
                        this.reasons.splice(this.reasons.indexOf(item.reason), 1)
                      }
                      this.playerVM.reasonList[index].isSelected =
                        !this.playerVM.reasonList[index].isSelected
                    })
                }
              }, (item: ReportItem, index) => JSON.stringify(item) + index)
          }
          .columnsTemplate('1fr 1fr 1fr')
          .rowsTemplate('1fr 1fr')
          .columnsGap(8)
          .rowsGap(4)
          .width('100%')
          .height(84)
          .margin({ top: 16 })

          Stack({ alignContent: Alignment.BottomEnd }) {
            TextArea({ placeholder: '请输入详细举报内容，便于平台鉴定违规情况（非必选）' })
              .width('100%')
              .height(72)
              .fontSize(12)
              .lineHeight(16)
              .fontWeight(400)
              .maxLength(30)
              .backgroundColor($r('sys.color.comp_background_primary'))
              .borderRadius(4)
              .padding(8)
              .placeholderColor($r('sys.color.font_tertiary'))
              .placeholderFont({ size: 12 })
              .onChange((v) => {
                this.reason = v
                this.inputLength = v.length
              })
              .onEditChange((isEditing: boolean) => {
                this.isEditing = isEditing
              })
            Text(`${this.inputLength}/30`)
              .height(16)
              .fontSize($r('sys.float.Caption_L'))
              .fontWeight(FontWeight.Regular)
              .fontColor($r('sys.color.font_tertiary'))
              .margin({ bottom: 8, right: 8 })
          }
          .width('100%')
          .height(72)
          .margin({ top: 4, bottom: 0 })
        }
        .height(this.reportHeight)
      }
      .layoutWeight(1)
      .width('100%')
      .scrollBar(BarState.Off)

      Button('提交')
        .width('100%')
        .height(40)
        .borderRadius(20)
        .backgroundColor($r('sys.color.multi_color_01'))
        .fontColor($r('sys.color.font_on_primary'))
        .fontSize($r('sys.float.Body_L'))
        .fontWeight(FontWeight.Medium)
        .margin({ top: 16 ,bottom:16})
        .onClick(() => {
          if (this.reasons.length === 0) {
            this.getUIContext().getPromptAction().showToast({ message: '请选择举报原因后提交' })
            return
          }
          this.playerVM.reasonList.forEach((item: ReportItem) => {
            item.isSelected = false
          }, (item: ReportItem, index: number) => item.reason + index)
          this.onReport(this.reasons, this.reason)
          this.backClick()
        })

    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
    .padding({ left: 24, right: 24 })
  }
}
