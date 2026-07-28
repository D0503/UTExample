import { UIContext } from '@kit.ArkUI';
import entry, { GuiState } from 'libentry.so';
import {
  notifySdlAboutToAppear,
  notifySdlAboutToDisappear,
  notifySdlPageHide,
  notifySdlPageShow
} from '../service/SdlModule';
import { NodeParams, NodeType, ViewNodeController } from '../service/adapter_c/common/Node';
import { addRootNode } from '../service/adapter_c/utils/AdapterTs';

const storage: LocalStorage = LocalStorage.getShared();

@Entry(storage)
@Component
struct Index {
  @LocalStorageProp('uiContext') @Watch('onUiContextChanged')
  uiContext: UIContext | null = null;
  @LocalStorageProp('windowId') windowId: number = 0;
  @State rootNodeController: ViewNodeController | null = null;
  @State renderReadyText: string = 'false';
  @State nativeStatusText: string =
    'frames=0;buttonClicks=0;slider=0.500;keyboardEvents=0;lastKeyCode=0';
  private pollingTimer: number = -1;
  private sdlStarted: boolean = false;

  aboutToAppear(): void {
    this.initializeSdl();
  }

  private onUiContextChanged(): void {
    this.initializeSdl();
  }

  private initializeSdl(): void {
    if (this.uiContext === null || this.rootNodeController !== null) return;
    const params = new NodeParams(0, 0, '100%', '100%', NodeType.Container);
    this.rootNodeController = addRootNode(this.windowId, this.uiContext, params);
    this.pollNativeState();
    this.pollingTimer = setInterval(() => this.pollNativeState(), 100);
  }

  private onSurfaceAreaChange(newValue: Area): void {
    const width: number = Number(newValue.width);
    const height: number = Number(newValue.height);
    if (this.uiContext === null || this.sdlStarted || width <= 0 || height <= 0) return;
    notifySdlAboutToAppear(getContext(this), this.windowId, width, height);
    this.sdlStarted = true;
  }

  aboutToDisappear(): void {
    if (this.pollingTimer >= 0) clearInterval(this.pollingTimer);
    notifySdlAboutToDisappear();
  }

  onPageShow(): void {
    notifySdlPageShow();
  }

  onPageHide(): void {
    notifySdlPageHide();
  }

  private pollNativeState(): void {
    const state: GuiState = entry.getGuiState();
    this.renderReadyText = state.renderReady ? 'true' : 'false';
    this.nativeStatusText =
      `frames=${state.frameCount};buttonClicks=${state.buttonClickCount};` +
      `slider=${state.sliderValue.toFixed(3)};keyboardEvents=${state.keyboardEventCount};` +
      `lastKeyCode=${state.lastKeyCode}`;
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      NodeContainer(this.rootNodeController)
        .id('sdlSurface')
        .width('100%')
        .height('100%')
        .focusable(true)
        .focusOnTouch(true)
        .onAreaChange((_oldValue: Area, newValue: Area) => {
          this.onSurfaceAreaChange(newValue);
        })
      Text('SDL2 GUI validation')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .backgroundColor('#CC111722')
        .position({ x: 12, y: 12 })
      Text(this.renderReadyText)
        .id('renderReady')
        .fontSize(16)
        .fontColor(Color.White)
        .backgroundColor('#CC111722')
        .position({ x: 12, y: 48 })
      Text(this.nativeStatusText)
        .id('nativeStatus')
        .fontSize(14)
        .fontColor(Color.White)
        .backgroundColor('#CC111722')
        .position({ x: 12, y: 76 })
    }
    .width('100%')
    .height('100%')
  }
}
