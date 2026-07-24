import { PopViewUtils } from '../common/PopViewUtils';
import { Constants } from '../common/Constant';
import { SearchApis } from '../https/Apis';
import {
  FilterTagAndList,
  PresentationType,
  SearchItem,
  SearchSource,
  SearchViewController,
  SearchWordItem,
  SetValueParams
} from '../types/Type';
import { SearchViewModel } from '../viewmodel/SearchViewModel';

@ComponentV2
export struct SearchView {
  @Param presentationType: PresentationType = PresentationType.SEARCH_ICON
  @Param entranceText: string[] = ['Search'];
  @Param routerStack: NavPathStack = new NavPathStack();
  @Param placeholder: string = 'Search';
  @Param themeColor: ResourceColor = '#0A59F7';
  @Param showFilterTag: boolean = true;
  @Param showGuessLike: boolean = true;
  @Param showHotSearch: boolean = true;
  @Param isShallowWindow: boolean = false;
  @Param tabBarScroller: Scroller = new Scroller();
  @Param searchResultScroller: Scroller = new Scroller();
  @Param controller: SearchViewController = new SearchViewController();
  @Param suggestionItemBuilderParam: WrappedBuilder<[string, number]> | undefined = undefined;
  @Param guessItemBuilderParam: WrappedBuilder<[string]> | undefined = undefined;
  @Param hotItemBuilderParam: WrappedBuilder<[SearchItem, number]> | undefined = undefined;
  @Param resultItemBuilderParam: WrappedBuilder<[SearchItem]> | undefined = undefined;
  @Event handleSearch: (keyWord: string | SearchWordItem | SearchItem,
    searchSource: SearchSource) => Promise<FilterTagAndList[]> =
    SearchApis.getSearchResultsList;
  @Event searchSuggestion: (keyWord: string) => Promise<[SearchWordItem[], string[]]> = SearchApis.getSearchSuggestion;
  @Event queryHistoryList: () => Promise<SearchWordItem[]> = SearchApis.getHistoryList;
  @Event deleteHistoryList: () => Promise<SearchWordItem[]> = SearchApis.deleteHistoryList;
  @Event queryGuessList: (isRefresh: boolean) => Promise<SearchWordItem[]> = SearchApis.getGuessLikeList;
  @Event queryHotSearchList: () => Promise<SearchItem[]> = SearchApis.getHotSearchList;
  @Event onClickGetMore: () => void = () => {
  }
  @Event onClickResultItem: (listItem: SearchItem) => void = () => {
  }
  @Local vm: SearchViewModel = SearchViewModel.getInstance();
  @Local searchWordIndex: number = 0;
  @Local params: SetValueParams = {};
  uiContext: UIContext = this.getUIContext();

  aboutToAppear(): void {
    this.params = {
      routerStack: this.routerStack,
      placeholder: this.placeholder,
      themeColor: this.themeColor,
      showFilterTag: this.showFilterTag,
      showGuessLike: this.showGuessLike,
      showHotSearch: this.showHotSearch,
      isShallowWindow: this.isShallowWindow,
      tabBarScroller: this.tabBarScroller,
      scroller: this.searchResultScroller,
      controller: this.controller,
      handleSearch: this.handleSearch,
      searchSuggestion: this.searchSuggestion,
      getMore: this.onClickGetMore,
      onClickResultItem: this.onClickResultItem,
      queryHistoryList: this.queryHistoryList,
      queryGuessList: this.queryGuessList,
      queryHotSearchList: this.queryHotSearchList,
      deleteHistoryList: this.deleteHistoryList,
      suggestionItemBuilderParam: this.suggestionItemBuilderParam,
      guessItemBuilderParam: this.guessItemBuilderParam,
      hotItemBuilderParam: this.hotItemBuilderParam,
      resultItemBuilderParam: this.resultItemBuilderParam
    };
    this.controller.onBackPressed = () => {
      if (this.vm.searchWords.length) {
        this.vm.searchWords = '';
        return true;
      }
      return false;
    }

    PopViewUtils.initPopViewUtil(this.uiContext);
    this.vm.setValue(this.params);
  }

  aboutToDisappear(): void {
    this.vm.initSearchParam();
  }

  build() {
    if (this.presentationType === PresentationType.SEARCH_BOX) {
      Stack({ alignContent: Alignment.Start }) {
        Search()
          .focusable(false)
          .margin(0)
          .constraintSize({ maxWidth: 400, minWidth: 40 })
          .placeholderFont({ size: $r('sys.float.Body_L') })
          .id('search-entry-box-input')

        Swiper() {
          ForEach(this.entranceText, (item: string) => {
            Text(item.toString())
              .textAlign(TextAlign.Start)
              .fontSize($r('sys.float.Body_L'))
              .fontColor($r('sys.color.font_secondary'))
              .maxFontScale(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }, (item: string) => item);
        }
        .index($$this.searchWordIndex)
        .vertical(true)
        .autoPlay(true)
        .interval(2000)
        .loop(true)
        .indicator(false)
        .duration(500)
        .height(38)
        .width('calc(100% - 48vp)')
        .offset({ x: 36 })
        .constraintSize({ maxWidth: 352, minWidth: 40 })
      }
      .id('search-entry-box')
      .onClick(() => {
        this.vm.placeholderContent = this.entranceText[this.searchWordIndex];
        this.vm.initSearchParam();
        this.routerStack.pushPathByName('ResultPage', null);
      })
    } else {
      Button({ type: ButtonType.Circle }) {
        SymbolGlyph($r('sys.symbol.magnifyingglass'))
          .fontColor([$r('sys.color.icon_primary')])
          .fontSize(Constants.SEARCH_ICON_WIDTH)
      }
      .width(Constants.BACK_BACKGROUND_WIDTH)
      .height(Constants.BACK_BACKGROUND_HEIGHT)
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .id('search-entry-icon')
      .onClick(() => {
        this.vm.placeholderContent = this.placeholder;
        this.vm.initSearchParam();
        this.routerStack.pushPathByName('ResultPage', null);
      })
    }
  }
}
