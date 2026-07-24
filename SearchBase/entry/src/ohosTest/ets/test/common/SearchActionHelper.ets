import { Driver, ON } from '@kit.TestKit';
import { inputMethod } from '@kit.IMEKit';
import { expect } from '@ohos/hypium';
import { getComponentById, tryGetBoundsById, tryGetComponentById } from './TestHelper';
import { getWindowBounds } from './DeviceHelper';

// 方法说明：按测试 id 点击组件，并等待 UI 稳定。
export async function tapById(driver: Driver, id: string): Promise<void> {
  const component = await getComponentById(driver, id);
  await component.click();
  await driver.delayMs(300);
}

// 方法说明：按文本点击组件，主要用于点击搜索按钮。
export async function tapText(driver: Driver, text: string): Promise<void> {
  const component = await driver.findComponent(ON.text(text));
  expect(component !== null).assertTrue();
  if (component !== null) {
    await component.click();
    await driver.delayMs(300);
  }
}

// 方法说明：点击首页搜索入口，兼容手机圆形图标和大屏搜索框两种入口形态。
export async function tapHomeSearchEntry(driver: Driver): Promise<void> {
  const box = await tryGetComponentById(driver, 'search-entry-box');
  if (box !== null) {
    await box.click();
    await driver.delayMs(300);
  } else {
    await tapById(driver, 'search-entry-icon');
    return;
  }
}

// 方法说明：打开完整搜索页；若当前已经在搜索承载页则直接返回。
export async function openFullSearchPage(driver: Driver): Promise<void> {
  const searchPage = await tryGetBoundsById(driver, 'search-result-page');
  if (searchPage !== null) {
    return;
  }
  await tapHomeSearchEntry(driver);
}

// 方法说明：向搜索输入框输入关键词，用于触发联想词或搜索提交。
export async function inputKeyword(driver: Driver, keyword: string = '苹果'): Promise<void> {
  const input = await getComponentById(driver, 'search-input');
  await input.click();
  await driver.delayMs(300);
  await input.inputText(keyword);
  await driver.delayMs(500);
}

// 方法说明：输入关键词并点击搜索按钮，用于进入搜索结果状态。
export async function submitSearch(driver: Driver, keyword: string = '苹果'): Promise<void> {
  await inputKeyword(driver, keyword);
  await tapText(driver, '搜索');
  await driver.delayMs(500);
}

// 方法说明：进入搜索联想状态，用于验证联想词单列和浅层联想弹出。
export async function openSuggestionState(driver: Driver, keyword: string = '苹果'): Promise<void> {
  await openFullSearchPage(driver);
  await inputKeyword(driver, keyword);
  await driver.delayMs(500);
}

// 方法说明：进入搜索结果状态，用于验证搜索结果列表列数、间距和页面布局。
export async function openResultState(driver: Driver, keyword: string = '苹果'): Promise<void> {
  await openFullSearchPage(driver);
  await submitSearch(driver, keyword);
}

// 方法说明：仅聚焦搜索输入框，用于验证浅层窗口获焦触发逻辑。
export async function focusSearchInput(driver: Driver): Promise<void> {
  const input = await getComponentById(driver, 'search-input');
  await input.click();
  await driver.delayMs(500);
}

// 方法说明：点击窗口空白区域，用于验证浅层窗口点击空白关闭。
export async function tapBlankArea(driver: Driver, bundleName: string): Promise<void> {
  const windowRect = await getWindowBounds(driver, bundleName);
  await driver.click(windowRect.left + 100, windowRect.bottom - 100);
  await driver.delayMs(500);
}

// 方法说明：收起键盘
export async function closeKeyBoard(driver: Driver): Promise<void> {
  inputMethod.getController().stopInputSession();
  await driver.delayMs(500);
}

// 方法说明：聚焦 lg/xl 首页搜索框，进入浅层窗口待测状态。
export async function openHomePopup(driver: Driver): Promise<void> {
  await tapById(driver, 'search-entry-box');
}
