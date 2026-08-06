import { AVPlayer } from '../tools/AVPlayer';
import { PipManager } from '../tools/PipManager';
import { PlayerVM } from '../viewModels/PlayerVM';

@ComponentV2
export struct PlayerView {
  @Param videoRatio: number = 16 / 9
  @Param showMaskLayer: boolean = false
  @Param callbackTimeUpdate: (nol: number, total: number) => void = () => {
  };
  @Local renderWidth: number = 0
  @Local renderHeight: number = 0
  @Local playerVM: PlayerVM = PlayerVM.instance;
  @Local player: AVPlayer = PipManager.getInstance().player;
  @BuilderParam customBuilderParam: () => void = this.customBuilder;
  @Event stateChange:(state:string) => void = (state:string) => {};

  @Builder
  customBuilder() {
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      // 黑色背景
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor(Color.Black)
        .zIndex(1)

      // 视频渲染区域
      Stack({ alignContent: Alignment.Center }) {
        // 视频
        if (this.showMaskLayer) {
          this.customBuilderParam()
        } else {
          this.xComponentView()
        }
      }
      .zIndex(2)
      .width(this.renderWidth)
      .height(this.renderHeight)
    }
    .clip(true)
    .onAreaChange((_, area) => {
      this.calcRenderSize(Number(area.width), Number(area.height))
    })
  }

  @Builder
  xComponentView() {
    Column() {
      XComponent({
        type: XComponentType.SURFACE,
        controller: PipManager.getInstance().getXComponentController()
      })
        .id('XComponent01')
        .layoutWeight(1)
        .onLoad(async () => {
          let surfaceId = PipManager.getInstance().getXComponentController().getXComponentSurfaceId();
          // 将surfaceId设置给媒体源
          PipManager.getInstance().getXComponentController().onSurfaceCreated(surfaceId)
         await PipManager.getInstance().player.init(this.playerVM.movieItem.movieUrl,
           this.playerVM.movieItem.learnProgress, (state:string) => {
           this.stateChange(state);
         })
          PipManager.getInstance().player.callbackTimeUpdate = (vol: number, total: number) => {
            this.callbackTimeUpdate(vol, total)
            this.playerVM.movieItem.learnProgress = Math.floor(vol / total * 100)
          }

        })
    }
    .width('100%')
    .height('100%')
  }

  private calcRenderSize(containerW: number, containerH: number) {
    const containerRatio: number = containerW / containerH

    if (containerRatio > this.videoRatio) {
      // 左右黑边
      this.renderHeight = containerH
      this.renderWidth = containerH * this.videoRatio
    } else {
      // 上下黑边
      this.renderWidth = containerW
      this.renderHeight = containerW / this.videoRatio
    }
  }
}

