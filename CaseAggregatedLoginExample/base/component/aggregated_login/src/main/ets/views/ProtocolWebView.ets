import { webview } from '@kit.ArkWeb';
import { ProtocolRouterParams } from '../model/Index';
import { Constants } from '../common/Constant';

@Builder
export function ProtocolWebViewBuilder() {
  ProtocolWebView()
}

@ComponentV2
struct ProtocolWebView {
  @Local content: string = '';
  @Local isSheet: boolean = false;
  webViewController: webview.WebviewController = new webview.WebviewController();
  stack: NavPathStack = new NavPathStack();

  @Computed
  get headerPaddingTop() {
    if (!this.isSheet) {
      return undefined;
    }

    return Constants.PADDING_L;
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.chevron_backward'))
              .fontColor([$r('sys.color.icon_primary')])
              .fontSize(Constants.BACK_WIDTH)
          }
          .width(Constants.BACK_BACKGROUND_WIDTH)
          .height(Constants.BACK_BACKGROUND_HEIGHT)
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .onClick(() => {
            this.stack.pop();
          })
        }
        .width(Constants.FULL_PERCENT)
        .margin({
          bottom: Constants.SPACE_S,
        })

        this.coreInfo()
      }
      .padding({
        left: Constants.PADDING_L,
        right: Constants.PADDING_L,
        bottom: this.isSheet ? Constants.WINDOW_BOTTOM_PADDING : Constants.ZERO,
        top: this.headerPaddingTop,
      })
      .height(Constants.FULL_PERCENT)
      .width(Constants.FULL_PERCENT)
      .backgroundColor($r('sys.color.background_secondary'))
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
    .onReady((context) => {
      this.stack = context.pathStack;
      const params = context.pathInfo.param as ProtocolRouterParams;
      if (params) {
        this.content = params.content;
        this.isSheet = params.isSheet ?? false;
      }
    })
  }

  @Builder
  coreInfo() {
    Web({
      src: '',
      controller: this.webViewController,
    })
      .fileAccess(false)
      .geolocationAccess(false)
      .darkMode(WebDarkMode.Auto)
      .forceDarkAccess(true)
      .verticalScrollBarAccess(false)
      .backgroundColor($r('sys.color.background_primary'))
      .layoutWeight(1)
      .backgroundColor($r('sys.color.background_secondary'))
      .onControllerAttached(() => {
        if (this.content.startsWith('http://') || this.content.startsWith('https://')) {
          this.webViewController.loadUrl(this.content)
        } else {
          this.webViewController.loadData(
            this.content,
            'text/html',
            'UTF-8',
            '',
            '',
          );
        }
      })
  }
}
