import { PresentationType, SearchItem, SearchView, SearchViewController } from 'search';
import { getShallowWindowParam } from '../common/SearchHostConfig';

@Entry
@ComponentV2
struct Index {
  @Local navPathStack: NavPathStack = new NavPathStack();
  @Local isShallowWindow: boolean = false;
  controller: SearchViewController = new SearchViewController();

  aboutToAppear(): void {
    this.isShallowWindow = getShallowWindowParam();
  }

  onBackPress(): boolean | void {
    return this.controller.onBackPressed();
  }

  build() {
    Navigation(this.navPathStack) {
      Row() {
        Text('首页').fontSize(26).fontWeight(700).height(40)
          .id('home-title')
        Blank().layoutWeight(1)
        Row({ space: 10 }) {
          SearchView({
            presentationType: PresentationType.SEARCH_ICON,
            entranceText: ['搜索推荐1', '搜索推荐2', '搜索推荐3'],
            routerStack: this.navPathStack,
            controller: this.controller,
            isShallowWindow: this.isShallowWindow,
            onClickGetMore: () => {
              this.getUIContext().getPromptAction().showToast({ message: '前往更多页，暂未开发' })
            },
            onClickResultItem: (listItem: SearchItem) => {
              this.getUIContext().getPromptAction().showToast({ message: '前往详情页，暂未开发' })
            },
          })
          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.dot_grid_2x2')).fontSize(24)
          }
          .width(40).height(40).backgroundColor($r('sys.color.comp_background_tertiary'))
        }
        .id('home-search-actions')
      }
      .height('100%')
      .width('100%')
      .padding(16)
      .alignItems(VerticalAlign.Top)
      .id('search-entry-page')
    }
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
  }
}
