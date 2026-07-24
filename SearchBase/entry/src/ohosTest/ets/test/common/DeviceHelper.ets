import { DisplayRotation, Driver, ResizeDirection, UiWindow } from '@kit.TestKit';
import { expect } from '@ohos/hypium';
import { JSON } from '@kit.ArkTS';
import { normalizeRect, Rect } from './TestHelper';

export const BREAKPOINT_SM: number = 600;
export const BREAKPOINT_MD: number = 840;
export const BREAKPOINT_LG: number = 1440;

// 方法说明：获取当前应用窗口 bounds，用于判断组件是否越界以及计算页面边距。
export async function getWindowBounds(driver: Driver, bundleName: string): Promise<Rect> {
  const win = await driver.findWindow({ bundleName: bundleName, active: true });
  const bounds = await win.getBounds();
  return normalizeRect(bounds);
}

// 方法说明：将当前窗口宽度换算为 vp，作为断点判断的输入。
export async function getWindowVpWidth(driver: Driver, bundleName: string): Promise<number> {
  const windowRect = await getWindowBounds(driver, bundleName);
  return px2vp(windowRect.right - windowRect.left);
}

// 方法说明：根据窗口 vp 宽度映射 sm/md/lg/xl 断点。
export function getBreakpointName(vpWidth: number): string {
  if (vpWidth < BREAKPOINT_SM) {
    return 'sm';
  }
  if (vpWidth < BREAKPOINT_MD) {
    return 'md';
  }
  if (vpWidth < BREAKPOINT_LG) {
    return 'lg';
  }
  return 'xl';
}

// 方法说明：断言当前设备处于指定断点集合，避免在错误设备上误判用例结果。
export async function expectBreakpointIn(driver: Driver, bundleName: string, expected: string[]): Promise<string> {
  const breakpoint = getBreakpointName(await getWindowVpWidth(driver, bundleName));
  expect(expected.includes(breakpoint)).assertTrue();
  return breakpoint;
}

// 方法说明：模拟设备旋转
export async function rotateTablet(driver: Driver, degree: DisplayRotation): Promise<void> {
  await driver.setDisplayRotation(degree);
  await driver.delayMs(500);
}
