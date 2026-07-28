import tinyxml2 from 'libentry.so';

@Entry
@Component
struct Index {
  @State private result: string = 'loading';

  aboutToAppear(): void {
    const xml = '<document><title>HarmonyOS</title></document>';
    this.result = `tinyxml2: ${tinyxml2.parseTitle(xml)}`;
  }

  build() {
    Column({ space: 16 }) {
      Text('tinyxml2 Native validation')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
      Text(this.result)
        .id('tinyxml2_result')
        .fontSize(22)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
