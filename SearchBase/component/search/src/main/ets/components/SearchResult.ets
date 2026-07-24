import { BasicDataSource } from '../common/BasicDataSource';
import { Constants } from '../common/Constant';
import { FilterTagAndList, SearchItem } from '../types/Type';
import { SearchViewModel } from '../viewmodel/SearchViewModel';

@ComponentV2
export struct SearchResult {
  @Param themeColor: ResourceColor = '#0A59F7';
  @Param showFilterTag: boolean = true;
  @Param tabBarScroller: Scroller = new Scroller();
  @Param scroller: Scroller = new Scroller();
  @Param itemBuilderParam: WrappedBuilder<[SearchItem]> | undefined = undefined;
  @Event onClickResultItem: (listItem: SearchItem) => void = () => {
  }
  @Local curTabIndex: number = 0;
  @Local vm: SearchViewModel = SearchViewModel.getInstance();
  @Local dataSource: BasicDataSource<SearchItem> = new BasicDataSource();

  aboutToAppear(): void {
    if (this.vm.searchResults.length) {
      this.dataSource.setData(this.vm.searchResults[this.curTabIndex].itemList);
    }
  };

  @Monitor('curTabIndex')
  onListChange() {
    this.dataSource.setData(this.vm.searchResults[this.curTabIndex].itemList);
  }

  @Monitor('vm.resultsChangeStatus')
  onChange() {
    if (this.vm.searchResults.length) {
      this.curTabIndex = 0;
      this.dataSource.setData(this.vm.searchResults[this.curTabIndex].itemList);
    } else {
      this.dataSource.setData([]);
    }
  }

  build() {
    Column() {
      if (this.showFilterTag) {
        if (this.vm.searchResults.length > 1) {
          List({ space: Constants.SPACE_S, scroller: this.tabBarScroller }) {
            ForEach(this.vm.searchResults, (item: FilterTagAndList, index: number) => {
              ListItem() {
                this.subBarItemBuilder(item.label, index)
              }
              .onClick(() => {
                this.curTabIndex = index;
              })
            }, (item: FilterTagAndList) => JSON.stringify(item.id))
          }
          .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
          .margin({
            left: Constants.PADDING_XL,
          })
          .padding({
            top: Constants.PADDING_TEN,
            bottom: Constants.PADDING_TEN,
          })
          .height(Constants.SEARCH_HEIGHT)
          .listDirection(Axis.Horizontal)
          .scrollBar(BarState.Off)
        }
      }

      if (!this.vm.searchResults.length || this.vm.searchResults[this.curTabIndex].itemList.length === 0) {
        this.searchNoResultBuilder()
      } else {
        Column() {
          Row() {
            Text('搜索结果')
              .fontSize($r('sys.float.Subtitle_L'))
              .fontWeight(FontWeight.Bold)
              .fontFamily('HarmonyHeiTi')
          }
          .width(Constants.FULL_PERCENT)
          .height(Constants.HISTORY_HEIGHT)
          .justifyContent(FlexAlign.Start)
          .padding({
            top: Constants.PADDING_XL,
            bottom: Constants.PADDING_S,
          })

          List() {
            LazyForEach(this.dataSource, (listItem: SearchItem) => {
              ListItem() {
                if (this.itemBuilderParam !== undefined) {
                  this.itemBuilderParam.builder(listItem)
                } else {
                  this.itemBuilder(listItem)
                }
              }
              .onClick(() => {
                this.onClickResultItem(listItem)
              })
              .id('search-result-item-' + listItem.id)
            }, (listItem: string) => JSON.stringify(listItem))
          }
          .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
          .scrollBar(BarState.Off)
          .layoutWeight(1)
          .width(Constants.FULL_PERCENT)
          .id('search-result-list')
        }
        .margin({
          left: Constants.PADDING_XL,
          right: Constants.PADDING_XL,
        })
        .layoutWeight(1)
        .id('search-result-section')
      }
    }
    .alignItems(HorizontalAlign.Start)
    .width(Constants.FULL_PERCENT)
    .layoutWeight(1)
  }

  @Builder
  searchNoResultBuilder() {
    Column({ space: Constants.SPACE_M }) {
      Image($r('app.media.SearchNoResult'))
        .width(Constants.SEARCH_NO_RESULT_SIZE)
        .height(Constants.SEARCH_NO_RESULT_SIZE)

      Text('没有符合条件的内容')
        .fontSize($r('sys.float.Body_M'))
        .fontWeight(FontWeight.Regular)
        .fontFamily('HarmonyHeiTi')
        .fontColor($r('sys.color.font_secondary'))
    }
    .justifyContent(FlexAlign.Center)
    .layoutWeight(1)
    .width(Constants.FULL_PERCENT)
  }

  @Builder
  subBarItemBuilder(item: string, index: number) {
    Button(item)
      .fontSize($r('sys.float.Body_M'))
      .fontWeight(this.curTabIndex === index ? FontWeight.Medium : FontWeight.Regular)
      .fontColor(this.curTabIndex === index ?
      $r('sys.color.font_on_primary') : $r('sys.color.font_primary'))
      .backgroundColor(this.curTabIndex === index ?
      this.themeColor : $r('sys.color.comp_background_tertiary'))
      .onClick(() => {
        this.curTabIndex = index;
        this.tabBarScroller.scrollToIndex(index, true);
        this.scroller.scrollToIndex(0, true);
      })
      .height(Constants.BUTTON_HEIGHT)
      .padding({
        top: Constants.PADDING_S,
        bottom: Constants.PADDING_S,
        right: Constants.PADDING_XL,
        left: Constants.PADDING_XL
      })
  }

  @Builder
  itemBuilder(listItem: SearchItem) {
    Row({ space: Constants.PADDING_M }) {
      if (listItem.image) {
        Image(listItem.image)
          .width(Constants.SEARCH_IMAGE_WIDTH)
          .height(Constants.SEARCH_IMAGE_HEIGHT)
          .objectFit(ImageFit.Fill)
          .borderRadius(8)
      }

      Column() {
        Text(listItem.title)
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .fontFamily('HarmonyHeiTi')
          .fontColor($r('sys.color.font_primary'))
          .textAlign(TextAlign.Start)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Divider()
          .strokeWidth('1px')
          .color($r('sys.color.comp_divider'))
      }
      .height(Constants.ITEM_RESULT_HEIGHT)
      .layoutWeight(1)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Start)
    }
    .alignItems(VerticalAlign.Center)
    .padding({ bottom: Constants.PADDING_M, top: Constants.PADDING_M })
    .height(Constants.LIST_RESULT_HEIGHT)
    .width(Constants.FULL_PERCENT)
  }
}
