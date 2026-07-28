import type { Context } from "@ohos:abilityAccessCtrl";
import display from "@ohos:display";
import sdl from "@app:com.thirdparty.validation.sdl2/entry/SDL2";
export function setScreenResolution(surfaceWidth: number, surfaceHeight: number): void {
    try {
        const current = display.getDefaultDisplaySync();
        const pixelWidth: number = Math.round(surfaceWidth * current.densityPixels);
        const pixelHeight: number = Math.round(surfaceHeight * current.densityPixels);
        sdl.nativeSetScreenResolution(pixelWidth, pixelHeight, pixelWidth, pixelHeight, current.densityPixels, current.refreshRate);
    }
    catch (error) {
        console.error(`Failed to obtain SDL2 display resolution: ${JSON.stringify(error)}`);
    }
}
export function setResourceManager(context: Context): void {
    sdl.setResourceManager(context.cacheDir, context.resourceManager);
}
export function setWindowId(windowId: number): void {
    sdl.setWindowId(windowId);
}
export function nativePause(): void {
    sdl.nativePause();
}
export function nativeResume(): void {
    sdl.nativeResume();
}
export function nativeSendQuit(): void {
    sdl.nativeSendQuit();
}
export function onNativeKeyDown(keyCode: number): void {
    sdl.keyDown(keyCode);
}
export function onNativeTextInput(count: number, text: string): void {
    sdl.textInput(count, text);
}
