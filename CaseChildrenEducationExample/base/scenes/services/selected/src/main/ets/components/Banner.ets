import { GlobalInfoModel } from '@ohos_agcit/children_education_utils';
import { AppStorageV2 } from '@kit.ArkUI';

@ComponentV2
export struct Banner {
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;
  @Param bannerArray: Array<string> = [];

  build() {
    Column() {
      Swiper() {
        ForEach(this.bannerArray, (item: string, index: number) => {
          Image(item)
            .id(`banner-item-${index}`)
            .borderRadius(16)
            .aspectRatio(16 / 9)
            .width('100%')
        }, (item: string) => item)
      }
      .interval(10000)
      .loop(true)
      .indicator(false)
      .autoPlay(true)
    }
    .id('banner-container')
    .width('100%')
    .alignItems(HorizontalAlign.Center)
  }
}
