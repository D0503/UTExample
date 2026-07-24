import { Want } from '@kit.AbilityKit';
import { abilityDelegatorRegistry, Component, Driver, ON } from '@kit.TestKit';
import { expect } from '@ohos/hypium';
import { setShallowWindowParam as setShallowWindowParamInHost } from '../../../../main/ets/common/SearchHostConfig';

export const POPUP_WIDTH_VP: number = 400;

export const GUESS_LIKE_ITEM_IDS: string[] = [
  'guess-like-item-0',
  'guess-like-item-1',
  'guess-like-item-2',
  'guess-like-item-3',
];

export const HOT_SEARCH_ITEM_IDS: string[] = [
  'hot-search-item-fruit-1',
  'hot-search-item-meat-1',
  'hot-search-item-vegetable-2',
  'hot-search-item-meat-2',
  'hot-search-item-fruit-3',
  'hot-search-item-fruit-4',
  'hot-search-item-fruit-5',
  'hot-search-item-fruit-6',
  'hot-search-item-fruit-2',
];

export const SEARCH_RESULT_ITEM_IDS: string[] = [
  'search-result-item-fruit-1',
  'search-result-item-fruit-2',
  'search-result-item-fruit-3',
  'search-result-item-fruit-4',
  'search-result-item-fruit-5',
  'search-result-item-fruit-6',
  'search-result-item-fruit-7',
  'search-result-item-fruit-8',
  'search-result-item-fruit-9',
];

export const HISTORY_CHIP_IDS: string[] = [
  'history-chip-0',
  'history-chip-1',
  'history-chip-2',
  'history-chip-3',
];

export const AUTOCOMPLETE_ITEM_IDS: string[] = [
  'autocomplete-item-0',
  'autocomplete-item-1',
  'autocomplete-item-2',
];

// 方法说明：统一描述组件 bounds，测试中所有布局断言都基于该矩形模型。
export interface Rect {
  left: number;
  top: number;
  right: number;
  bottom: number;
}

// 方法说明：设置入口页浅层窗口能力开关；普通用例不调用时默认关闭。
export function setShallowWindowParam(enabled: boolean): void {
  setShallowWindowParamInHost(enabled);
}

// 方法说明：启动被测 EntryAbility，并等待页面进入稳定状态。
export async function startAbility(driver: Driver, bundleName: string, abilityName: string): Promise<void> {
  const want: Want = {
    bundleName: bundleName,
    abilityName: abilityName,
  };
  await abilityDelegatorRegistry.getAbilityDelegator().startAbility(want);
  await driver.delayMs(500);
}

// 方法说明：按测试 id 获取组件，找不到时直接断言失败。
export async function getComponentById(driver: Driver, id: string): Promise<Component> {
  const component = await driver.findComponent(ON.id(id));
  expect(component !== null).assertTrue();
  return component;
}

// 方法说明：按测试 id 尝试获取组件，适用于判断 popup 或某个形态是否不存在。
export async function tryGetComponentById(driver: Driver, id: string): Promise<Component | null> {
  try {
    return await driver.findComponent(ON.id(id));
  } catch (e) {
    return null;
  }
}

// 方法说明：获取指定测试 id 组件的 bounds，并转为通用 Rect。
export async function getBoundsById(driver: Driver, id: string): Promise<Rect> {
  const component = await getComponentById(driver, id);
  const bounds = await component.getBounds();
  return normalizeRect(bounds);
}

// 方法说明：尝试获取指定组件 bounds，组件不存在时返回 null。
export async function tryGetBoundsById(driver: Driver, id: string): Promise<Rect | null> {
  const component = await tryGetComponentById(driver, id);
  if (component === null) {
    return null;
  }
  const bounds = await component.getBounds();
  return normalizeRect(bounds);
}

// 方法说明：批量收集一组列表项 bounds，用于列数、间距和重叠断言。
export async function getBoundsListByIds(driver: Driver, ids: string[]): Promise<Rect[]> {
  const rects: Rect[] = [];
  for (const id of ids) {
    const rect = await tryGetBoundsById(driver, id);
    if (rect !== null && rect.right > rect.left && rect.bottom > rect.top) {
      rects.push(rect);
    }
  }
  return rects;
}

// 方法说明：将 TestKit 返回的 bounds 对象规整成 Rect，统一后续几何计算。
export function normalizeRect(bounds: ESObject): Rect {
  return {
    left: bounds.left as number,
    top: bounds.top as number,
    right: bounds.right as number,
    bottom: bounds.bottom as number,
  };
}

// 方法说明：计算组件宽度，单位保持像素，调用处按需要转 vp。
export function rectWidth(rect: Rect): number {
  return rect.right - rect.left;
}

// 方法说明：计算组件高度，单位保持像素，调用处按需要转 vp。
export function rectHeight(rect: Rect): number {
  return rect.bottom - rect.top;
}

// 方法说明：断言组件有有效宽高，证明组件真实可见。
export function expectVisible(rect: Rect): void {
  expect(rectWidth(rect)).assertLarger(0);
  expect(rectHeight(rect)).assertLarger(0);
}

// 方法说明：断言指定组件不存在或不可见，常用于浅层窗口关闭状态检查。
export async function expectComponentAbsent(driver: Driver, id: string): Promise<void> {
  const rect = await tryGetBoundsById(driver, id);
  if (rect === null) {
    expect(true).assertTrue();
    return;
  }
  expect(rectWidth(rect) <= 0 || rectHeight(rect) <= 0).assertTrue();
}
