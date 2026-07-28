export const sdlAppEntry: (library: string, entryPoint: string, ...args: string[]) => void;
export const init: (callback: object) => void;
export const nativeSetScreenResolution: (
  deviceWidth: number,
  deviceHeight: number,
  surfaceWidth: number,
  surfaceHeight: number,
  densityPixels: number,
  refreshRate: number
) => void;
export const nativeSendQuit: () => void;
export const nativePause: () => void;
export const nativeResume: () => void;
export const onNativeResize: () => void;
export const onNativeKeyboardFocusLost: () => void;
export const nativePermissionResult: (granted: boolean) => void;
export const onNativeOrientationChanged: (orientation: number) => void;
export const setResourceManager: (cacheDir: string, resourceManager: object) => void;
export const setWindowId: (windowId: number) => void;
export const onNativeFocusChanged: (focused: boolean) => void;
export const keyDown: (keyCode: number) => void;
export const keyUp: (keyCode: number) => void;
export const textInput: (count: number, text: string) => void;
