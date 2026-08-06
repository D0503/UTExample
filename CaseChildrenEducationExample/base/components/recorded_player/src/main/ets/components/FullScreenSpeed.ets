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

import { LengthMetrics } from '@kit.ArkUI';
import { PlayerVM } from '../viewModels/PlayerVM';
import { MoreItem } from '../models/Type';

@ComponentV2
export struct FullScreenSpeed {
  @Param backClick: () => void = () => {
  }
  @Param speedEvent: (speed: string) => void = () => {
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
        Text('倍速')
          .fontSize($r('sys.float.Title_S'))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
      }
      .margin({ top: 20, bottom: 10 })

      List({ space: 12 }) {
        ForEach(this.playerVM.speedItemList, (item: string) => {
          ListItem() {
            Column() {
              Text(item)
                .fontSize($r('sys.float.Body_L'))
                .fontColor(this.playerVM.speed === item ? '#7C73FF' : '#fff')
                .fontWeight(FontWeight.Regular)
                .textAlign(TextAlign.Center)
            }
            .backgroundColor($r('sys.color.mask_secondary'))
            .width('100%')
            .borderRadius(8)
            .height(40)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .onClick(() => {
              if (this.playerVM.speed === item) {
                return
              }
              this.speedEvent(item)
            })
          }
        }, (item: string) => JSON.stringify(item))
      }
      .padding({ bottom: 10 })
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .layoutWeight(1)

    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
    .padding({ left: 24, right: 24 })
  }
}