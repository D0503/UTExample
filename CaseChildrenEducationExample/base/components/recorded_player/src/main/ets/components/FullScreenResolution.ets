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

import { PlayerVM } from '../viewModels/PlayerVM';

@ComponentV2
export struct FullScreenResolution {
  @Param backClick: () => void = () => {
  }
  @Param resolutionEvent: (resolution: string) => void = () => {
  }
  @Local playerVM: PlayerVM = PlayerVM.instance;

  build() {
    Column() {
      Row() {
        Image($r('app.media.icon_chevron_backward_dark'))
          .width(40)
          .height(40)
          .margin({ right: 8 })
          .onClick(() => {
            this.backClick()
          })
        Text('清晰度')
          .fontSize($r('sys.float.Title_S'))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
      }
      .margin({ top: 20, bottom: 10 })

      List({ space: 12 }) {
        ForEach(this.playerVM.resolutionItemList, (item: string) => {
          ListItem() {
            Column() {
              Text(item)
                .fontSize($r('sys.float.Body_L'))
                .fontWeight(FontWeight.Regular)
                .textAlign(TextAlign.Center)
                .fontColor(this.playerVM.resolution === item ? '#7C73FF' : '#fff')
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
            .borderRadius(8)
            .height(50)
            .backgroundColor($r('sys.color.mask_secondary'))
            .alignItems(HorizontalAlign.Center)
            .onClick(() => {
              if (this.playerVM.resolution === item) {
                return
              }
              this.resolutionEvent(item)
            })
          }
        }, (item: string) => JSON.stringify(item))
      }
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .padding({ bottom: 10 })
      .layoutWeight(1)
    }
    .padding({ left: 24, right: 24 })
    .height('100%')
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}