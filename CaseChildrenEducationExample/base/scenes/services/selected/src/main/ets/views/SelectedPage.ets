import { DataGenerator, SelectedPageData, VideoCard } from '@ohos_agcit/children_education_datasource';
import {
  CommonConstants,
  CompactCardComponent,
  FeedTitle,
  GlobalInfoModel,
  NoMoreTab
} from '@ohos_agcit/children_education_utils';
import { AudioStoryZone } from '../components/AudioStoryZone';
import { Banner } from '../components/Banner';
import { HobbyCategory } from '../components/HobbyCategory';
import { PremiumVideo } from '../components/PremiumVideo';
import { AppStorageV2 } from '@kit.ArkUI';


@ComponentV2
export struct SelectedPage {
  @Local selectedPageData: SelectedPageData = DataGenerator.getSelectedPageData(this.getUIContext())
  @Local premiumVideo: Array<VideoCard> = this.selectedPageData.premiumVideoZero;
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;
  @Local paddingNum: number = 16;
  @Consumer('age') age: string = '0-3岁';

  @Monitor('age')
  onAgeChange() {
    if (this.age === '3-6岁') {
      this.premiumVideo = this.selectedPageData.premiumVideoThree;
    } else if (this.age === '6岁以上') {
      this.premiumVideo = this.selectedPageData.premiumVideoSix;
    } else if (this.age === '0-3岁') {
      this.premiumVideo = this.selectedPageData.premiumVideoZero;
    }
  }

  build() {
    Column() {
      List() {
        ListItem() {
          Banner({
            bannerArray: this.selectedPageData.bannerArray,
          });
        }
        .padding({
          left: 16,
          right: 16
        })

        ListItem() {
          HobbyCategory({
            hobbyCategory: this.selectedPageData.hobbyCategory,
          });
        }
        .margin({ top: 16 })
        .padding({ left: this.paddingNum, right: this.paddingNum })

        ListItemGroup({
          header: FeedTitle('app.media.feed_head_premium', '精品互动视频', () => {
            this.globalInfo.navStack.pushPathByName('PremiumInteractiveVideoListView', '精品互动视频');
          }),
        }) {
          PremiumVideo({
            premiumArray: this.premiumVideo,
          })
        }
        .id('premium-video-section')
        .padding({ left: this.paddingNum, right: this.paddingNum })

        ListItemGroup({
          header: FeedTitle('app.media.feed_head_video', '热门动画榜',
            () => {
              this.globalInfo.navStack.pushPathByName('HotAnimationListView', '热门动画榜');
            }),
        }) {
          CompactCardComponent({
            videoCardArray: this.selectedPageData.hotAnimation
          })
        }
        .id('hot-animation-section')
        .padding({ left: this.paddingNum, right: this.paddingNum })

        ListItemGroup({
          header: FeedTitle('app.media.feed_head_audio', '音频故事专区', () => {
            this.globalInfo.navStack.pushPathByName('AudioSectionListView', undefined);
          }),
        }) {
          AudioStoryZone({
            audioStoryArray: this.selectedPageData.audioStory,
          });
        }
        .id('audio-story-section')
        .padding({ left: this.paddingNum, right: this.paddingNum })

        ListItemGroup({
          header: FeedTitle('app.media.feed_head_video', '经典故事', () => {
            this.globalInfo.navStack.pushPathByName('HotAnimationListView', '经典故事');
          }),
        }) {
          CompactCardComponent({
            videoCardArray: this.selectedPageData.classicStory
          });
        }
        .padding({ left: this.paddingNum, right: this.paddingNum })

        ListItemGroup({ header: NoMoreTab($r('app.string.reach_bottom')) }) {
        }
        .padding({ left: this.paddingNum, right: this.paddingNum })
      }
      .id('education-home-content')
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .height(CommonConstants.FULL_PERCENT)
      .width(CommonConstants.FULL_PERCENT)
    }
  }
}
