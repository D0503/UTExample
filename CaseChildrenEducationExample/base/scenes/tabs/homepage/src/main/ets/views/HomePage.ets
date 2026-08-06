import { EnglishZonePage } from '@ohos_agcit/children_education_englishzone';
import { CartoonPage } from '@ohos_agcit/children_education_cartoon';
import { SelectedPage } from '@ohos_agcit/children_education_selected';
import { SingPage } from '@ohos_agcit/children_education_sing';
import { ChinesePage } from '@ohos_agcit/children_education_chinese';
import {
  AvoidArea,
  CommonConstants,
  DialogUtils
} from '@ohos_agcit/children_education_utils';
import { AppStorageV2 } from '@kit.ArkUI';


@ComponentV2
export struct HomePage {
  @Local currentIndex: number = 0;
  @Provider('age') age: string = '0-3岁';
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  private ageArray: Resource = $r('app.strarray.age_array');
  private controller: TabsController = new TabsController();
  @Local scrollMargin: number = 0;

  @Builder
  tabBuilder(index: number, name: string | Resource) {
    Column() {
      Text(name)
        .fontColor(Color.Black)
        .fontSize(14)
        .fontWeight(this.currentIndex === index ? FontWeight.Bold : FontWeight.Regular)
        .fontColor(this.currentIndex === index ? $r('sys.color.black') : Color.Gray)
        .lineHeight(22)
        .margin({ top: 17, bottom: 10 })
    }
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        Row() {
        }
        .borderRadius(20)
        .backgroundColor('#F1F3F5')
        .width(92)
        .height(40);

        Row() {
          Text(this.age)
            .fontSize(16)
            .lineHeight(21)
            .fontWeight(FontWeight.Medium)
          SymbolGlyph($r('sys.symbol.arrowtriangle_down_fill'))
        };
      }
      .margin({
        top: 10,
        left: 16,
      })
      .alignSelf(ItemAlign.Start)
      .onClick(() => {
        DialogUtils.textPickerDialog(this.getUIContext(), this.ageArray, (sexValue: string) => {
          this.age = sexValue;
        })
      })

      // custom tabBar
      Row({
        space: 24
      }) {
        ForEach(CommonConstants.TABS, (item: string, index: number) => {
          Text(item)
            .id(`home-category-${index}`)
            .fontSize(14)
            .lineHeight(19)
            .fontWeight(this.currentIndex === index ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.currentIndex === index ? $r('sys.color.black') : Color.Gray)
            .onClick(() => {
              this.controller.changeIndex(index)
            })
        }, (item: string) => JSON.stringify(item))
      }
      .width(360)
      .alignSelf(ItemAlign.Start)
      .padding({
        left: 16,
        right: 16
      })
      .alignItems(VerticalAlign.Center)
      .height(48)

      Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
        TabContent() {
          // 精选
          SelectedPage();
        }

        TabContent() {
          // 看动画
          CartoonPage();
        }

        TabContent() {
          // 英语乐园
          EnglishZonePage();
        }

        TabContent() {
          // 儿歌
          SingPage();
        }

        TabContent() {
          // 学汉语
          ChinesePage();
        }
      }
      .barWidth(0)
      .barHeight(0)
      .width(CommonConstants.FULL_PERCENT)
      .alignSelf(ItemAlign.Start)
      .animationDuration(300)
      .onAnimationStart((index: number, targetIndex: number) => {
        this.currentIndex = targetIndex;
      })
      .align(Alignment.Start)
    }
    .id('education-home-root')
    .padding({
      top: this.getUIContext().px2vp(this.avoidArea.topRectHeight)
    })
  }
}
