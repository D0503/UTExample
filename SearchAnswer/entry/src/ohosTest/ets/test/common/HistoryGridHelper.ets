import { rectWidth, Rect } from './TestHelper';

// 方法说明：历史胶囊栅格计算结果，宽度单位统一为 vp。
export interface HistoryChipGridInfo {
  columns: number;
  gutter: number;
  maxColumns: number;
  maxGutters: number;
  columnWidth: number;
  minChipWidth: number;
  maxChipWidth: number;
}

// 方法说明：根据断点返回历史胶囊所在页面的栅格总列数。
function getHistoryGridColumns(breakpoint: string): number {
  if (breakpoint === 'sm') {
    return 4;
  }
  if (breakpoint === 'md') {
    return 8;
  }
  return 12;
}

// 方法说明：根据断点返回历史胶囊词之间的 gutter。
function getHistoryGridGutter(breakpoint: string): number {
  if (breakpoint === 'sm') {
    return 8;
  }
  if (breakpoint === 'md') {
    return 12;
  }
  if (breakpoint === 'lg') {
    return 16;
  }
  return 20;
}

// 方法说明：根据断点返回历史胶囊最大可占用的栅格列数。
function getHistoryMaxColumns(breakpoint: string): number {
  if (breakpoint === 'sm') {
    return 2;
  }
  if (breakpoint === 'md') {
    return 3;
  }
  return 4;
}

// 方法说明：根据容器宽度和断点计算历史胶囊最小/最大宽度约束。
export function getHistoryChipGridInfo(container: Rect, breakpoint: string): HistoryChipGridInfo {
  const columns = getHistoryGridColumns(breakpoint);
  const gutter = getHistoryGridGutter(breakpoint);
  const maxColumns = getHistoryMaxColumns(breakpoint);
  const maxGutters = maxColumns - 1;
  const containerWidthVp = px2vp(rectWidth(container));
  const columnWidth = (containerWidthVp - (columns - 1) * gutter) / columns;

  return {
    columns: columns,
    gutter: gutter,
    maxColumns: maxColumns,
    maxGutters: maxGutters,
    columnWidth: columnWidth,
    minChipWidth: columnWidth,
    maxChipWidth: maxColumns * columnWidth + maxGutters * gutter,
  };
}
