import { NavHeaderBar } from '../components/NavHeaderBar';
import { SettingH5VM } from '../viewmodels/SettingH5VM';

@Builder
export function SettingH5Builder() {
  SettingH5()
}

@ComponentV2
struct SettingH5 {
  @Local vm: SettingH5VM = new SettingH5VM();

  aboutToAppear(): void {
    this.vm.getParams();
  }

  build() {
    NavDestination() {
      NavHeaderBar()
      if (this.vm.configInfo.isSheet) {
        this.webBuilder()
      } else {
        this.webBuilder()
      }
    }
    .attributeModifier(this.vm.pageModifier)
    .backgroundColor(this.pageBg)
  }

  @Builder
  webBuilder() {
    Web({
      src: '',
      controller: this.vm.webViewController,
    })
      .fileAccess(false)
      .geolocationAccess(false)
      .darkMode(WebDarkMode.Auto)
      .forceDarkAccess(true)
      .verticalScrollBarAccess(false)
      .defaultFontSize(this.vm.getDefaultFontSize)
      .textZoomRatio(this.vm.getTextZoomRatio)
      .backgroundColor(this.pageBg)
      .layoutWeight(1)
      .nestedScroll({
        scrollForward: NestedScrollMode.SELF_ONLY,
        scrollBackward: NestedScrollMode.SELF_ONLY,
      })
      .onControllerAttached(() => {
        this.vm.onControllerAttached();
      })
  }

  @Computed
  get pageBg() {
    return this.vm.configInfo.isSheet ? $r('app.color.page_bg') : $r('sys.color.background_secondary')
  }
}
