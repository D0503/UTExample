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

import { PiPWindow } from '@kit.ArkUI';
import { AVPlayer } from './AVPlayer';
import { BusinessError } from '@kit.BasicServicesKit';

const CONTEXT_WIDTH: number = 1600;
const CONTEXT_HEIGHT: number = 900;

export class CustomXComponentController extends XComponentController {
  onSurfaceCreated(surfaceId: string): void {
    if (PipManager.getInstance().player.surfaceID === surfaceId) {
      return;
    }
    PipManager.getInstance().player.setSurfaceId(surfaceId);
  }
}

// 画中画控制器
export class PipManager {
  private static instance: PipManager = new PipManager();
  private pipController?: PiPWindow.PiPController;
  private mXComponentController: XComponentController;
  player: AVPlayer;

  constructor() {
    this.player = new AVPlayer();
    this.mXComponentController = new CustomXComponentController();
  }

  public static getInstance(): PipManager {
    return PipManager.instance;
  }

  getXComponentController(): CustomXComponentController {
    return this.mXComponentController;
  }

  init(ctx: Context, navigationId: string) {
    // 当前设备如若不支持画中画则退出
    if (!PiPWindow.isPiPEnabled()) {
      return;
    }
    let config: PiPWindow.PiPConfiguration = {
      context: ctx,
      // XComponent组件绑定同一个
      componentController: this.mXComponentController,
      navigationId: navigationId,
      // 画中画媒体类型枚举，当前使用的视频播放模版
      templateType: PiPWindow.PiPTemplateType.VIDEO_PLAY,
      contentWidth: CONTEXT_WIDTH,
      contentHeight: CONTEXT_HEIGHT,
    };
    PiPWindow.create(config).then((controller: PiPWindow.PiPController) => {
      this.pipController = controller;
      this.pipController?.setAutoStartEnabled(false);
      this.pipController.on('stateChange', (state: PiPWindow.PiPState, reason: string) => {
        this.onStateChange(state, reason);
      });
      this.pipController.on('controlEvent', (control: PiPWindow.ControlEventParam) => {
        this.onActionEvent(control);
      });
    }).catch((err: BusinessError) => {
    })
  }

  startPip() {
    this.pipController?.startPiP().then(() => {
    }).catch((err: BusinessError) => {
    });
  }

  stopPip() {
    this.pipController?.stopPiP().then(() => {
    }).catch((err: BusinessError) => {
    });
  }

  setAutoStart(autoStart: boolean): void {
    this.pipController?.setAutoStartEnabled(autoStart);
  }

  updateContentSize(width: number, height: number) {
    if (this.pipController) {
      this.pipController.updateContentSize(width, height);
    }
  }

  updatePiPControlStatus() {
    let controlType: PiPWindow.PiPControlType = PiPWindow.PiPControlType.VIDEO_PLAY_PAUSE;
    let status: PiPWindow.PiPControlStatus = PiPWindow.PiPControlStatus.PLAY;
    this.pipController?.updatePiPControlStatus(controlType, status);
  }

  unregisterPipStateChangeListener() {
    this.pipController?.off('stateChange');
    this.pipController?.off('controlEvent');
  }

  // 监听画中画生命周期
  onStateChange(state: PiPWindow.PiPState, _reason: string) {
    switch (state) {
      // 表示画中画将要启动
      case PiPWindow.PiPState.ABOUT_TO_START:
        break;
      // 表示画中画已经启动
      case PiPWindow.PiPState.STARTED:
        // 启动画中画
        PipManager.getInstance().player.isPipOpen = true;
        break;
      // 表示画中画将要停止
      case PiPWindow.PiPState.ABOUT_TO_STOP:
        // 画中画关闭
        PipManager.getInstance().player.isPipOpen = false;
        break;
      // 表示画中画已经停止
      case PiPWindow.PiPState.STOPPED:
        // 画中画关闭
        PipManager.getInstance().player.isPipOpen = false;
        // // 小窗口点击关闭画中画，视频暂停播放
        PipManager.getInstance().player.isPiPWindowRestore = false;
        break;
      // 表示画中画将从小窗播放恢复到原始播放界面
      case PiPWindow.PiPState.ABOUT_TO_RESTORE:
        // 小窗口复原关闭画中画
        PipManager.getInstance().player.isPipOpen = false;
        // 从小窗口复原
        PipManager.getInstance().player.isPiPWindowRestore = true;
        break;
      // 表示画中画生命周期执行过程出现了异常
      case PiPWindow.PiPState.ERROR:
        break;
      default:
        break;
    }
  }

  // 监听画中画控制面板控件动作事件
  onActionEvent(control: PiPWindow.ControlEventParam) {
    switch (control.controlType) {
      // 视频播放、停止
      case PiPWindow.PiPControlType.VIDEO_PLAY_PAUSE:
        if (control.status === PiPWindow.PiPControlStatus.PAUSE) {
          // 停止视频
          PipManager.getInstance().player.isPlaying = false;
        } else if (control.status === PiPWindow.PiPControlStatus.PLAY) {
          // 播放视频
          PipManager.getInstance().player.isPlaying = true;
        }
        break;
      // 切换到下一个视频
      case PiPWindow.PiPControlType.VIDEO_NEXT:
        break;
      // 切换到上一个视频
      case PiPWindow.PiPControlType.VIDEO_PREVIOUS:
        break;
      // 视频进度快进
      case PiPWindow.PiPControlType.FAST_FORWARD:
        break;
      // 视频进度后退
      case PiPWindow.PiPControlType.FAST_BACKWARD:
        break;
      default:
        break;
    }
  }
}