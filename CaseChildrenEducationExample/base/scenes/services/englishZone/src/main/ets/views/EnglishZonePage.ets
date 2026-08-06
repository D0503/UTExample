import { DataGenerator } from '@ohos_agcit/children_education_datasource';
import { CommonConstants, FeedTitle, NoMoreTab, CompactCardComponent, GlobalInfoModel } from '@ohos_agcit/children_education_utils';
import { AppStorageV2 } from '@kit.ArkUI';

@ComponentV2
export struct EnglishZonePage {
  private englishChildrenSongsData = DataGenerator.getEnglishChildrenSongsData(this.getUIContext());
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;

  build() {
    Column() {
      List() {
        ListItemGroup({
          header: FeedTitle('app.media.feed_head_video', '原版英文儿歌', () => {
            this.globalInfo.navStack.pushPathByName('HotAnimationListView', '原版英文儿歌');
          })
        }) {
          CompactCardComponent({
            videoCardArray: this.englishChildrenSongsData
          })
        }
        .id('english-song-section');

        ListItem() {
          NoMoreTab($r('app.string.reach_bottom'))
        }
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