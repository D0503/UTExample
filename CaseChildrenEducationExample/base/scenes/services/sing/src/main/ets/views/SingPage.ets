import { DataGenerator } from '@ohos_agcit/children_education_datasource';
import {
  CommonConstants,
  FeedTitle,
  NoMoreTab,
  CompactCardComponent,
  GlobalInfoModel
} from '@ohos_agcit/children_education_utils';
import { AppStorageV2 } from '@kit.ArkUI';

@ComponentV2
export struct SingPage {
  private singSongPageData = DataGenerator.getSingSongPageData(this.getUIContext());
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;
  
  build() {
    Column() {
      List() {
        ListItemGroup({
          header: FeedTitle('app.media.feed_head_video', '律动儿歌', () => {
            this.globalInfo.navStack.pushPathByName('HotAnimationListView', '律动儿歌');
          })
        }) {
          CompactCardComponent({
            videoCardArray: this.singSongPageData
          });
        }
        .id('rhythm-song-section');

        ListItemGroup({
          header: FeedTitle('app.media.feed_head_video', '经典童谣', () => {
            this.globalInfo.navStack.pushPathByName('HotAnimationListView', '经典童谣');
          }),
        }) {
          CompactCardComponent({
            videoCardArray: this.singSongPageData
          });
        };

        ListItem() {
          NoMoreTab($r('app.string.reach_bottom'));
        };
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .height(CommonConstants.FULL_PERCENT)
      .width(CommonConstants.FULL_PERCENT)
      .padding({
        left: 16,
        right: 16
      })
    }
  }
}
