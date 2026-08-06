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
import { MoreItem, MovieItem, ReportItem } from '../models/Type';
import { PipManager } from '../tools/PipManager';

@ObservedV2
export class PlayerVM {
  // 后台播放是否开启
  @Trace autoStartEnabled: boolean = false;
  @Trace windowStatusType: number = 1;
  @Trace charge: number = 50;
  @Trace isCharge: boolean = false;
  @Trace speed: string = '1.0';
  @Trace resolution: string = '1080P 原画（高帧率）';
  @Trace movieItem: MovieItem = new MovieItem('01', '章节1', 0, '');
  @Trace reasonList: Array<ReportItem> = [
    new ReportItem('色情低俗', false), new ReportItem('违法违规', false), new ReportItem('血腥暴力', false),
    new ReportItem('危险行为', false), new ReportItem('垃圾广告', false), new ReportItem('未成年人相关', false)
  ]
  private static _instance: PlayerVM;
  public moreItemList: MoreItem[] = [
    {
      label: '分享',
      icon: $r('app.media.icon_share'),
      itemId: '01',
    },
    {
      label: '倍速',
      icon: $r('app.media.icon_speed_multiple'),
      itemId: '02',
    },
    {
      label: '画中画',
      icon: $r('app.media.icon_smal_window_playback'),
      itemId: '03',
    },
    {
      label: '清晰度',
      icon: $r('app.media.icon_hd_plus_rectangle'),
      itemId: '04',
    },
    {
      label: '举报',
      icon: $r('app.media.icon_exclamationmark_triangle'),
      itemId: '05',
    },
  ];
  public shareItemList: MoreItem[] = [
    {
      label: '微信',
      icon: $r('app.media.wechat'),
      itemId: '01',
    },
    {
      label: '朋友圈',
      icon: $r('app.media.friend_circle'),
      itemId: '02',
    },
    {
      label: 'QQ',
      icon: $r('app.media.qq'),
      itemId: '03',
    },
    {
      label: '生成海报',
      icon: $r('app.media.create_post_white'),
      itemId: '04',
    },
    {
      label: '复制链接',
      icon: $r('app.media.copy_link_white'),
      itemId: '05',
    },
    {
      label: '系统分享',
      icon: $r('app.media.system_share_white'),
      itemId: '06',
    }
  ];
  @Trace movieItemList: MovieItem[] = [
  ];
  @Trace isSelections: boolean = false;
  public speedItemList: string[] = ['0.75', '1.0', '1.25', '1.5', '2.0'];
  public resolutionItemList: string[] = ['1080P 原画（高帧率）', '1080P 蓝光', '720P超清', '480P高清'];
  public selections: string[] = ['章节1', '章节2', '章节3', '章节4', '章节5', '章节6'];
  public navId: string = 'courseNavId';

  public static get instance() {
    if (!PlayerVM._instance) {
      PlayerVM._instance = new PlayerVM();
      PlayerVM._instance.movieItem = PlayerVM._instance.movieItemList[1]
    }
    return PlayerVM._instance;
  }

  @Monitor('autoStartEnabled')
  onAutoStartEnabledChange(monitor: IMonitor) {
    let autoStart = monitor.value()?.now as boolean
    let eventData: emitter.EventData = {
      data: { autoStartEnabled: autoStart }
    }
    emitter.emit('autoStartEnabled', eventData)
  }

  stopPip() {
    PipManager.getInstance().stopPip()
  }
}