import { PresentationType, SearchItem, SearchView, SearchViewController } from 'search';
import { getShallowWindowParam } from '../common/SearchHostConfig';

@Entry
@ComponentV2
struct Index {
  @Local navPathStack: NavPathStack = new NavPathStack();
  @Local breakpoint: string = '';
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
      GridRow({ columns: 1 }) {
        GridCol({ span: 1 }) {
          Row() {
            Text('首页').fontSize(26).fontWeight(700).height(40)
              .id('home-title')
            Blank().layoutWeight(1)
            Row({ space: 10 }) {
              SearchView({
                presentationType: this.breakpoint === 'sm' ? PresentationType.SEARCH_ICON : PresentationType.SEARCH_BOX,
                entranceText: ['搜索推荐1', '搜索推荐2', '搜索推荐3'],
                routerStack: this.navPathStack,
                controller: this.controller,
                isShallowWindow: this.isShallowWindow,
                guessItemBuilderParam: wrapBuilder(myBuilder),
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
          .onClick(() => {
            this.controller.closePop();
          })
          .id('search-entry-page')
        }
      }
      .onBreakpointChange((bp) => {
        this.breakpoint = bp;
      })
    }
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
  }
}


@Builder
function myBuilder(listItem: string) {
  Row({ space: 12 }) {
    SymbolGlyph($r('sys.symbol.magnifyingglass'))
      .fontSize(16)
      .fontColor([$r('sys.color.icon_primary')])

    Text(listItem)
      .fontSize($r('sys.float.Body_M'))
      .fontFamily('HarmonyHeiTi')
      .fontColor($r('sys.color.font_primary'))
      .textAlign(TextAlign.Start)
      .layoutWeight(1)
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
  }
  .justifyContent(FlexAlign.Center)
  .height(40)
  .width('100%')
}
