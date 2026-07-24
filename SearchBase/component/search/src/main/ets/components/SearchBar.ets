import { SymbolGlyphModifier } from '@kit.ArkUI';

@ComponentV2
export struct SearchBar {
  @Param placeholder: string = 'Search';
  @Param searchWords: string = '';
  @Param themeColor: ResourceColor = '#0A59F7';
  @Param controller: SearchController = new SearchController();
  @Event
  updateSearchWords: (value: string) => void = () => {
  };
  @Event
  submitSearch: (value: string) => void = () => {
  };

  build() {
    Row() {
      Search({
        value: $$this.searchWords,
        controller: this.controller,
        placeholder: this.placeholder,
      })
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .placeholderFont({
          size: $r('sys.float.Body_L'),
          weight: FontWeight.Regular,
          family: 'HarmonyHeiTi'
        })
        .placeholderColor($r('sys.color.font_secondary'))
        .textFont({
          size: $r('sys.float.Body_L'),
          weight: FontWeight.Medium,
          family: 'HarmonyHeiTi',
        })
        .cancelButton({
          style: CancelButtonStyle.INPUT,
          icon: new SymbolGlyphModifier().fontSize('16vp')
        })
        .caretStyle({ color: this.themeColor })
        .searchButton('搜索', {
          fontSize: $r('sys.float.Body_M'),
          fontColor: this.themeColor,
        })
        .enableKeyboardOnFocus(true)
        .id('search-input')
        .onChange((value) => {
          this.updateSearchWords?.(value);
        })
        .onSubmit((value) => {
          this.submitSearch?.(value ? value : this.placeholder);
        })
    }
    .alignItems(VerticalAlign.Center)
  }
}
