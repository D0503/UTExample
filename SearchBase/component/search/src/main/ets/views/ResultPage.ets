import { Constants } from '../common/Constant';
import { PopViewUtils } from '../common/PopViewUtils';
import { GuessLike } from '../components/GuessLike';
import { HistorySearch } from '../components/HistorySearch';
import { HotSearch } from '../components/HotSearch';
import { SearchAutoComplete } from '../components/SearchAutoComplete';
import { SearchBar } from '../components/SearchBar';
import { SearchResult } from '../components/SearchResult';
import { SearchSource } from '../types/Type';
import { SearchViewModel } from '../viewmodel/SearchViewModel';

@Builder
export function ResultPageBuilder() {
  ResultPage()
}

@ComponentV2
export struct ResultPage {
  @Local vm: SearchViewModel = SearchViewModel.getInstance();
  @Local columnWidth: number = 0;
  @Local maxLen: number = 0;
  @Local containerWidth: number = 0;
  uiContext: UIContext = this.getUIContext();

  aboutToAppear(): void {
    PopViewUtils.initPopViewUtil(this.uiContext);
    this.vm.loadingData();
  };

  @Monitor('vm.showSearchRsp')
  onHistoryChange() {
    this.vm.loadingData();
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Row() {
            Button({ type: ButtonType.Circle }) {
              SymbolGlyph($r('sys.symbol.chevron_left'))
                .fontColor([$r('sys.color.icon_primary')])
                .fontSize(Constants.CHEVRON_WIDTH)
            }
            .width(Constants.BACK_BACKGROUND_WIDTH)
            .height(Constants.BACK_BACKGROUND_HEIGHT)
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .id('search-back-button')
          }
          .margin({ right: Constants.SPACE_S })
          .onClick(() => {
            this.vm.routerStack?.pop?.();
          });

          SearchBar({
            placeholder: this.vm.placeholderContent,
            searchWords: this.vm.searchWords,
            themeColor: this.vm.themeColor,
            controller: this.vm.searchResultController,
            updateSearchWords: (value) => {
              this.vm.searchQuery(value, this.vm.searchSuggestion)
            },
            submitSearch: (value) => {
              this.vm.submitSearch(value, SearchSource.USER_INPUT, this.vm.handleSearch);
            },
          })
            .layoutWeight(1)
        }
        .id('search-bar-row')
        .onSizeChange((oldSize, newSize) => {
          this.containerWidth = newSize.width as number
          this.calculateWidth()
        })
        .height(Constants.SEARCH_HEIGHT)
        .padding({
          top: Constants.PADDING_S,
          bottom: Constants.PADDING_S,
          left: Constants.PADDING_XL,
          right: Constants.PADDING_XL,
        })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)
        .width(Constants.FULL_PERCENT)

        if (this.vm.showSearchSuggestionRsp) {
          SearchAutoComplete({
            themeColor: this.vm.themeColor,
            itemBuilderParam: this.vm.suggestionItemBuilderParam,
            selectSuggestionItem: (value) => {
              this.vm.submitSearch(value, SearchSource.SUGGESTION, this.vm.handleSearch);
            },
          })

        } else if (this.vm.showSearchRsp) {
          SearchResult({
            themeColor: this.vm.themeColor,
            showFilterTag: this.vm.showFilterTag,
            tabBarScroller: this.vm.tabBarScroller,
            scroller: this.vm.scroller,
            itemBuilderParam: this.vm.resultItemBuilderParam,
            onClickResultItem: this.vm.onClickResultItem,
          })
        } else {
          Scroll() {
            Column() {
              HistorySearch({
                historyList: this.vm.historyList,
                maxLen: this.maxLen,
                columnWidth: this.columnWidth,
                deleteHistoryList: async () => {
                  this.vm.historyList = await this.vm.deleteHistoryList();
                },
                selectHistoryItem: (value) => {
                  this.vm.submitSearch(value, SearchSource.HISTORY, this.vm.handleSearch);
                },
              })

              if (this.vm.showGuessLike) {
                GuessLike({
                  guessLikeList: this.vm.guessLikeList,
                  itemBuilderParam: this.vm.guessItemBuilderParam,
                  selectGuessLikeItem: (value) => {
                    this.vm.submitSearch(value, SearchSource.RECOMMEND, this.vm.handleSearch);
                  },
                  queryGuessList: async () => {
                    this.vm.guessLikeList = await this.vm.queryGuessList(true);
                  }
                })
              }

              if (this.vm.showHotSearch) {
                HotSearch({
                  hotSearchList: this.vm.hotSearchList,
                  itemBuilderParam: this.vm.hotItemBuilderParam,
                  getMore: this.vm.getMore,
                  selectHotSearchItem: (value) => {
                    this.vm.submitSearch(value, SearchSource.HOT_SEARCH, this.vm.handleSearch);
                  },
                })
              }
            }
          }
          .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
          .align(Alignment.Top)
          .scrollBar(BarState.Off)
          .layoutWeight(1)
          .margin({
            left: Constants.PADDING_XL,
            right: Constants.PADDING_XL,
          })
        }
      }
      // todo 为适配元服务需要打开注释，以防胶囊遮挡
      // .padding({ top: 56 })
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.End)
      .height(Constants.FULL_PERCENT)
      .width(Constants.FULL_PERCENT)
      .id('search-result-page')
    }
    .onBackPressed(() => {
      if (this.vm.searchWords.length) {
        this.vm.initSearchParam();
        return true;
      }
      return false;
    })
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(true)
  }

  calculateWidth = () => {
    this.columnWidth = (this.containerWidth - Constants.SPACE_S * 3) / 4;
    this.maxLen = 2 * this.columnWidth + Constants.SPACE_S;
  }
}
