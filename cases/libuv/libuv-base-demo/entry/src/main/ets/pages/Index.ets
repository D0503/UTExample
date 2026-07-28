import libuv, { LibuvTestResult } from 'libentry.so';

@Entry
@Component
struct Index {
  @State private version: string = 'loading';
  @State private summary: string = 'Native checks are running';
  @State private details: string = '';

  aboutToAppear(): void {
    const result: LibuvTestResult = libuv.runAll();
    this.version = result.version;
    this.summary = result.failed === 0 ?
      `PASS · ${result.passed} checks` :
      `FAIL · ${result.failed} checks`;
    this.details = result.failed === 0 ?
      'Event loop · timer · work queue · thread · CPU affinity' :
      result.failures.join('\n');
  }

  build() {
    Column({ space: 18 }) {
      Text('libuv HarmonyOS validation')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
      Text(`libuv ${this.version}`)
        .fontSize(20)
        .fontColor('#5B67F1')
      Text(this.summary)
        .id('libuv_result')
        .fontSize(24)
        .fontWeight(FontWeight.Medium)
      Text(this.details)
        .fontSize(18)
        .textAlign(TextAlign.Center)
        .lineHeight(28)
      Button('Run again')
        .onClick(() => this.aboutToAppear())
    }
    .padding(40)
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#F7F8FC')
  }
}
