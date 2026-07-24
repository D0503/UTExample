import { Driver } from '@kit.TestKit';
import { expect } from '@ohos/hypium';
import { getBoundsListByIds, Rect, rectHeight, rectWidth } from './TestHelper';

export const TOLERANCE_VP: number = 3;

// 方法说明：断言组件 bounds 完全落在窗口内，覆盖截断和横向溢出问题。
export function expectInWindow(windowRect: Rect, rect: Rect): void {
  expect(rect.left >= windowRect.left).assertTrue();
  expect(rect.right <= windowRect.right).assertTrue();
  expect(rect.top >= windowRect.top).assertTrue();
  expect(rect.bottom <= windowRect.bottom).assertTrue();
}

// 方法说明：断言组件宽度接近目标 vp，主要用于 400vp 搜索框/浅层窗口验证。
export function expectWidthNear(rect: Rect, expectedVp: number, toleranceVp: number = TOLERANCE_VP): void {
  expect(Math.abs(px2vp(rectWidth(rect)) - expectedVp) <= toleranceVp).assertTrue();
}

// 方法说明：断言组件宽度不超过目标 vp，主要用于弹窗内容校验。
export function expectWidthAtMost(rect: Rect, expectedVp: number): void {
  expect(px2vp(rectWidth(rect)) <= expectedVp + TOLERANCE_VP).assertTrue();
}

// 方法说明：断言组件宽度不小于目标 vp，用于区分正常页面内联想和 400vp 浅层窗口。
export function expectWidthAtLeast(rect: Rect, expectedVp: number): void {
  expect(px2vp(rectWidth(rect)) >= expectedVp - TOLERANCE_VP).assertTrue();
}

// 方法说明：断言组件宽高近似相等，用于圆形图标入口等可观测形态判断。
export function expectSquareNear(rect: Rect, toleranceVp: number = TOLERANCE_VP): void {
  const widthVp = px2vp(rectWidth(rect));
  const heightVp = px2vp(rectHeight(rect));
  expect(Math.abs(widthVp - heightVp) <= toleranceVp).assertTrue();
}

// 方法说明：断言内容靠容器右侧对齐，覆盖结果页右上角搜索框位置。
export function expectRightAlignedNear(container: Rect, content: Rect, expectedRightMarginVp: number,
  toleranceVp: number = TOLERANCE_VP): void {
  const rightMargin = px2vp(container.right - content.right);
  expect(Math.abs(rightMargin - expectedRightMarginVp) <= toleranceVp).assertTrue();
}

// 方法说明：断言内容区左右边距接近目标 vp，覆盖 sm/md/lg 页面边距适配。
export function expectHorizontalMarginNear(container: Rect, content: Rect, expectedVp: number): void {
  const leftMargin = px2vp(content.left - container.left);
  const rightMargin = px2vp(container.right - content.right);
  expect(Math.abs(leftMargin - expectedVp) <= TOLERANCE_VP).assertTrue();
  expect(Math.abs(rightMargin - expectedVp) <= TOLERANCE_VP).assertTrue();
}

// 方法说明：断言同一行相邻元素的横向间距不小于目标值。
export function expectGapAtLeast(first: Rect, second: Rect, minGapVp: number): void {
  const gap = px2vp(second.left - first.right);
  expect(gap >= minGapVp - TOLERANCE_VP).assertTrue();
}

// 方法说明：断言同一行相邻元素的横向间距接近目标值，用于列间距精确档位校验。
export function expectGapNear(first: Rect, second: Rect, expectedGapVp: number): void {
  const gap = px2vp(second.left - first.right);
  expect(Math.abs(gap - expectedGapVp) <= TOLERANCE_VP).assertTrue();
}

// 方法说明：断言上下相邻元素的纵向间距不小于目标值。
export function expectVerticalGapAtLeast(first: Rect, second: Rect, minGapVp: number): void {
  const gap = px2vp(second.top - first.bottom);
  expect(gap >= minGapVp - TOLERANCE_VP).assertTrue();
}

// 方法说明：断言上下相邻元素的纵向间距不超过目标值，用于手机紧凑布局保护。
export function expectVerticalGapAtMost(first: Rect, second: Rect, maxGapVp: number): void {
  const gap = px2vp(second.top - first.bottom);
  expect(gap <= maxGapVp + TOLERANCE_VP).assertTrue();
}

// 方法说明：断言两个组件没有实质重叠，覆盖历史胶囊和关键控件遮挡问题。
export function expectNoOverlap(first: Rect, second: Rect): void {
  const horizontal = Math.min(first.right, second.right) - Math.max(first.left, second.left);
  const vertical = Math.min(first.bottom, second.bottom) - Math.max(first.top, second.top);
  expect(px2vp(horizontal) <= TOLERANCE_VP || px2vp(vertical) <= TOLERANCE_VP).assertTrue();
}

// 方法说明：统计列表第一行组件数量，用 bounds 判断当前列表列数。
export function getFirstRowCount(rects: Rect[]): number {
  expect(rects.length).assertLarger(0);
  const top = rects[0].top;
  let count = 0;
  for (const rect of rects) {
    if (Math.abs(px2vp(rect.top - top)) <= TOLERANCE_VP) {
      count++;
    }
  }
  return count;
}

// 方法说明：断言指定列表第一行列数符合预期，是列表列数适配的核心断言。
export async function expectColumnCount(driver: Driver, ids: string[], expectedCount: number): Promise<void> {
  const rects = await getBoundsListByIds(driver, ids);
  expect(rects.length >= expectedCount).assertTrue();
  expect(getFirstRowCount(rects)).assertEqual(expectedCount);
}
