import { SharePicker } from 'aggregated_share';

@Builder
export function TitleShare(title: string , url: string) {
  Row() {
    Text(title)
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .fontSize(20)
      .fontWeight(FontWeight.Bold)
      .margin({
        left: 8
      })
      .layoutWeight(1)

    Stack({ alignContent: Alignment.Center }) {
      Circle()
        .width(40)
        .height(40)
        .fill($r('sys.color.comp_background_tertiary'))

      SymbolGlyph($r('sys.symbol.share'))
        .fontSize(24)
    }
    .margin({ left: 8, right: 16 })
    .onClick(() => {
      const picker: SharePicker = new SharePicker({
        title: title,
        coverUrl: url
      });
      picker.show();
    })
  }
  .layoutWeight(1)
  .height(56)
}