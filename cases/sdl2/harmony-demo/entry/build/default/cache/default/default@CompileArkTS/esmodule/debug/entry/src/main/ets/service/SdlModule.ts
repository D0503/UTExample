import type { Context } from "@ohos:abilityAccessCtrl";
import sdl from "@app:com.thirdparty.validation.sdl2/entry/SDL2";
import { nativePause, nativeResume, nativeSendQuit, onNativeKeyDown, onNativeTextInput, setResourceManager, setScreenResolution, setWindowId } from "@bundle:com.thirdparty.validation.sdl2/entry/ets/service/InvokeNative";
import { hideTextInput, requestPermission, setOrientation, setPointer, setTitle, setWindowStyle, shouldMinimizeOnFocusLoss, showTextInput } from "@bundle:com.thirdparty.validation.sdl2/entry/ets/service/ResponseNative";
import type { NodeParams, ViewNodeController } from './adapter_c/common/Node';
import { addChildNode, adjustNodeZOrder, getNodeByWindowId, getNodeRect, getXcomponentId, lowerNode, moveNode, raiseNode, removeChildNode, reParentNode, resizeNode, setNodeBorderColor, setNodeBorderWidth, setNodeParams, setNodeVisibility } from "@bundle:com.thirdparty.validation.sdl2/entry/ets/service/adapter_c/utils/AdapterTs";
class ArkNapiCallback {
    private windowId: number = 0;
    setCurrentWindowId(windowId: number): void {
        this.windowId = windowId;
    }
    getWindowId(): number {
        return this.windowId;
    }
    getNodeByWindowId(windowId: number): ViewNodeController | undefined {
        return getNodeByWindowId(windowId);
    }
    addChildNode(parent: ViewNodeController, params?: NodeParams): ViewNodeController {
        return addChildNode(parent, params);
    }
    removeChildNode(child: ViewNodeController): void {
        removeChildNode(child);
    }
    resizeNode(node: ViewNodeController, width: string, height: string): void {
        resizeNode(node, width, height);
    }
    adjustNodeZOrder(node: ViewNodeController, zIndex: number): void {
        adjustNodeZOrder(node, zIndex);
    }
    setNodeVisibility(node: ViewNodeController, visibility: number): void {
        setNodeVisibility(node, visibility);
    }
    getNodeRect(node: ViewNodeController): number[] {
        return getNodeRect(node);
    }
    moveNode(node: ViewNodeController, x: Length, y: Length): void {
        moveNode(node, x, y);
    }
    raiseNode(node: ViewNodeController): void {
        raiseNode(node);
    }
    lowerNode(node: ViewNodeController): void {
        lowerNode(node);
    }
    reParentNode(parent: ViewNodeController, child: ViewNodeController): void {
        reParentNode(parent, child);
    }
    setNodeBorderColor(node: ViewNodeController, color: string): ViewNodeController {
        return setNodeBorderColor(node, color);
    }
    setNodeBorderWidth(node: ViewNodeController, width: Length): ViewNodeController {
        return setNodeBorderWidth(node, width);
    }
    setNodeParams(node: ViewNodeController, params: NodeParams): ViewNodeController {
        return setNodeParams(node, params);
    }
    getXcomponentId(node: ViewNodeController): string {
        return getXcomponentId(node);
    }
    setTitle(title: string): void {
        setTitle(title);
    }
    setWindowStyle(fullscreen: boolean): void {
        setWindowStyle(fullscreen);
    }
    setOrientation(width: number, height: number, resizable: number, hint: string): void {
        setOrientation(width, height, resizable, hint);
    }
    shouldMinimizeOnFocusLoss(): boolean {
        return shouldMinimizeOnFocusLoss();
    }
    showTextInput(x: number, y: number, width: number, height: number): void {
        showTextInput(x, y, width, height);
    }
    showTextInput2(_show: boolean): void { }
    hideTextInput(): void {
        hideTextInput();
    }
    requestPermission(permission: string): void {
        requestPermission(permission);
    }
    setPointer(cursorId: number): void {
        setPointer(cursorId);
    }
    setCustomCursorandCreate(_pixelmap: object, _focusX: number, _focusY: number): void { }
    nAPISetWindowResize(_x: number, _y: number, _width: number, _height: number): void { }
}
const callback = new ArkNapiCallback();
let started: boolean = false;
export function notifySdlAboutToAppear(context: Context, windowId: number, surfaceWidth: number, surfaceHeight: number): void {
    if (started)
        return;
    callback.setCurrentWindowId(windowId);
    setResourceManager(context);
    setWindowId(windowId);
    setScreenResolution(surfaceWidth, surfaceHeight);
    sdl.init(callback);
    sdl.sdlAppEntry('libentry.so', 'main');
    started = true;
}
export function notifySdlAboutToDisappear(): void {
    if (!started)
        return;
    nativeSendQuit();
    started = false;
}
export function notifySdlPageShow(): void {
    if (started)
        nativeResume();
}
export function notifySdlPageHide(): void {
    if (started)
        nativePause();
}
export function notifySdlKeyDown(keyCode: number): void {
    onNativeKeyDown(keyCode);
}
export function notifySdlTextInput(count: number, text: string): void {
    onNativeTextInput(count, text);
}
