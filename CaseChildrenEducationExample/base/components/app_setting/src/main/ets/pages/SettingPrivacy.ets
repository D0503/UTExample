import { CommonConstants } from '../constants/CommonConstants';
import { NavHeaderBar } from '../components/NavHeaderBar';
import { SettingCard } from '../components/SettingCard';
import { SettingPrivacyVM } from '../viewmodels/SettingPrivacyVM'

@Builder
export function SettingPrivacyBuilder() {
  SettingPrivacy()
}

@ComponentV2
struct SettingPrivacy {
  @Local vm: SettingPrivacyVM = new SettingPrivacyVM();

  build() {
    NavDestination() {
      NavHeaderBar({ title: '隐私设置' })
      if (this.vm.configInfo.isSheet) {
        this.coreView()
      } else {
        this.coreView()
      }
    }
    .attributeModifier(this.vm.pageModifier)
    .backgroundColor(this.vm.configInfo.isSheet ? $r('app.color.page_bg') : $r('sys.color.background_secondary'))
  }

  @Builder
  coreView() {
    Scroll() {
      Column({ space: CommonConstants.SPACE_M }) {
        SettingCard({ list: this.vm.list1 })
        SettingCard({ list: this.vm.list2 })
      }
      .padding({
        top: CommonConstants.PADDING_M,
      })
    }
    .attributeModifier(this.vm.scrollModifier)
  }
}
