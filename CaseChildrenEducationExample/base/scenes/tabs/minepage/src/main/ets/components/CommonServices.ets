import { CommonServiceModel, mineCommonService } from '@ohos_agcit/children_education_datasource';
import {
  CommonConstants,
  GlobalInfoModel,
  rightArrow
} from '@ohos_agcit/children_education_utils';
import { DialPanel } from 'dial_panel';
import { AppStorageV2 } from '@kit.ArkUI';

@ComponentV2
export struct CommonServices {
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;
  private uiContext: UIContext = this.getUIContext();
  private mineCommonService: Array<CommonServiceModel> = mineCommonService;
  private dialPanel: DialPanel = new DialPanel(this.uiContext)
    .onMakeCall((e: BusinessError<void>): void => {
      if (e.code) {
        this.showToast(`拨号页面跳转失败 -> code: ${e.code}, msg: ${e.message}`);
      }
    })
    .onWillDismiss((reason: DismissReason): void => {
      this.dialPanel.close();
    });

  private showToast(msg: string): void {
    try {
      this.uiContext.getPromptAction().showToast({ message: msg });
    } catch (error) {
    }
  }

  private getHeight() {
    return 56 * this.mineCommonService.length + (this.mineCommonService.length - 1)
  }

  build() {
    Column({ space: 20 }) {
      Text($r('app.string.common_service'))
        .padding({ top: 25 })
        .fontColor($r('sys.color.black'))
        .fontWeight(FontWeight.Bold)
        .fontSize(18)

      Grid() {
        ForEach(this.mineCommonService, (item: CommonServiceModel, index: number) => {
          GridItem() {
            Column() {
              Row() {
                SymbolGlyph($r(item.symbol)).padding({ right: 16 });
                Text($r(item.serviceName)).fontSize(16).fontWeight(FontWeight.Medium).fontFamily('鸿蒙黑体');
                Blank();
                rightArrow()
              }
              .id(item.pageName === 'ViewHistory' ? 'common-service-history' : `common-service-action-${index}`)
              .height(56)
              .width(CommonConstants.FULL_PERCENT)
              .alignItems(VerticalAlign.Center)
              .onClick(() => {
                if (item.pageName === 'ContactUs') {
                  this.dialPanel
                    .setTitle('联系客服')
                    .setPhoneNumber('12345678901')
                    .setAutoClosePanel(true)
                    .open();
                  return
                }
                this.globalInfo.navStack.pushPathByName(item.pageName, undefined);
              });
              if (index !== mineCommonService.length - 1) {
                Divider().id('common-services-divider').width('100%').alignSelf(ItemAlign.End);
              }
            }
          }
          .id(`common-service-item-${index}`)
        }, (item: CommonServiceModel) => JSON.stringify(item));
      }
      .height(this.getHeight())
      .width(CommonConstants.FULL_PERCENT)
      .rowsGap(0)
      .columnsGap(40)
    }
    .id('common-services-root')
    .padding({
      right: 16,
      left: 16
    })
    .alignItems(HorizontalAlign.Start)
    .width(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('sys.color.white'))
    .borderRadius(16)
    .padding({ left: 12, right: 12 })
  }
}


