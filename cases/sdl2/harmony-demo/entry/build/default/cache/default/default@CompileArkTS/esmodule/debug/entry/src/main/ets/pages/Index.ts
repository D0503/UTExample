if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Index_Params {
    uiContext?: UIContext | null;
    windowId?: number;
    rootNodeController?: ViewNodeController | null;
    renderReadyText?: string;
    nativeStatusText?: string;
    pollingTimer?: number;
    sdlStarted?: boolean;
}
import type { UIContext } from "@ohos:arkui.UIContext";
import entry from "@app:com.thirdparty.validation.sdl2/entry/entry";
import type { GuiState } from "@app:com.thirdparty.validation.sdl2/entry/entry";
import { notifySdlAboutToAppear, notifySdlAboutToDisappear, notifySdlPageHide, notifySdlPageShow } from "@bundle:com.thirdparty.validation.sdl2/entry/ets/service/SdlModule";
import { NodeParams, NodeType } from "@bundle:com.thirdparty.validation.sdl2/entry/ets/service/adapter_c/common/Node";
import type { ViewNodeController } from "@bundle:com.thirdparty.validation.sdl2/entry/ets/service/adapter_c/common/Node";
import { addRootNode } from "@bundle:com.thirdparty.validation.sdl2/entry/ets/service/adapter_c/utils/AdapterTs";
const storage: LocalStorage = LocalStorage.getShared();
class Index extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__rootNodeController = new ObservedPropertyObjectPU(null, this, "rootNodeController");
        this.__renderReadyText = new ObservedPropertySimplePU('false', this, "renderReadyText");
        this.__nativeStatusText = new ObservedPropertySimplePU('frames=0;buttonClicks=0;slider=0.500;keyboardEvents=0;lastKeyCode=0', this, "nativeStatusText");
        this.pollingTimer = -1;
        this.sdlStarted = false;
        this.setInitiallyProvidedValue(params);
        this.declareWatch("uiContext", this.onUiContextChanged);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Index_Params) {
        if (params.rootNodeController !== undefined) {
            this.rootNodeController = params.rootNodeController;
        }
        if (params.renderReadyText !== undefined) {
            this.renderReadyText = params.renderReadyText;
        }
        if (params.nativeStatusText !== undefined) {
            this.nativeStatusText = params.nativeStatusText;
        }
        if (params.pollingTimer !== undefined) {
            this.pollingTimer = params.pollingTimer;
        }
        if (params.sdlStarted !== undefined) {
            this.sdlStarted = params.sdlStarted;
        }
    }
    updateStateVars(params: Index_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__uiContext.purgeDependencyOnElmtId(rmElmtId);
        this.__windowId.purgeDependencyOnElmtId(rmElmtId);
        this.__rootNodeController.purgeDependencyOnElmtId(rmElmtId);
        this.__renderReadyText.purgeDependencyOnElmtId(rmElmtId);
        this.__nativeStatusText.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__uiContext.aboutToBeDeleted();
        this.__windowId.aboutToBeDeleted();
        this.__rootNodeController.aboutToBeDeleted();
        this.__renderReadyText.aboutToBeDeleted();
        this.__nativeStatusText.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __uiContext: ObservedPropertyAbstractPU<UIContext | null> = this.createLocalStorageProp<UIContext | null>('uiContext', null, "uiContext");
    get uiContext() {
        return this.__uiContext.get();
    }
    set uiContext(newValue: UIContext | null) {
        this.__uiContext.set(newValue);
    }
    private __windowId: ObservedPropertyAbstractPU<number> = this.createLocalStorageProp<number>('windowId', 0, "windowId");
    get windowId() {
        return this.__windowId.get();
    }
    set windowId(newValue: number) {
        this.__windowId.set(newValue);
    }
    private __rootNodeController: ObservedPropertyObjectPU<ViewNodeController | null>;
    get rootNodeController() {
        return this.__rootNodeController.get();
    }
    set rootNodeController(newValue: ViewNodeController | null) {
        this.__rootNodeController.set(newValue);
    }
    private __renderReadyText: ObservedPropertySimplePU<string>;
    get renderReadyText() {
        return this.__renderReadyText.get();
    }
    set renderReadyText(newValue: string) {
        this.__renderReadyText.set(newValue);
    }
    private __nativeStatusText: ObservedPropertySimplePU<string>;
    get nativeStatusText() {
        return this.__nativeStatusText.get();
    }
    set nativeStatusText(newValue: string) {
        this.__nativeStatusText.set(newValue);
    }
    private pollingTimer: number;
    private sdlStarted: boolean;
    aboutToAppear(): void {
        this.initializeSdl();
    }
    private onUiContextChanged(): void {
        this.initializeSdl();
    }
    private initializeSdl(): void {
        if (this.uiContext === null || this.rootNodeController !== null)
            return;
        const params = new NodeParams(0, 0, '100%', '100%', NodeType.Container);
        this.rootNodeController = addRootNode(this.windowId, this.uiContext, params);
        this.pollNativeState();
        this.pollingTimer = setInterval(() => this.pollNativeState(), 100);
    }
    private onSurfaceAreaChange(newValue: Area): void {
        const width: number = Number(newValue.width);
        const height: number = Number(newValue.height);
        if (this.uiContext === null || this.sdlStarted || width <= 0 || height <= 0)
            return;
        notifySdlAboutToAppear(getContext(this), this.windowId, width, height);
        this.sdlStarted = true;
    }
    aboutToDisappear(): void {
        if (this.pollingTimer >= 0)
            clearInterval(this.pollingTimer);
        notifySdlAboutToDisappear();
    }
    onPageShow(): void {
        notifySdlPageShow();
    }
    onPageHide(): void {
        notifySdlPageHide();
    }
    private pollNativeState(): void {
        const state: GuiState = entry.getGuiState();
        this.renderReadyText = state.renderReady ? 'true' : 'false';
        this.nativeStatusText =
            `frames=${state.frameCount};buttonClicks=${state.buttonClickCount};` +
                `slider=${state.sliderValue.toFixed(3)};keyboardEvents=${state.keyboardEventCount};` +
                `lastKeyCode=${state.lastKeyCode}`;
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create({ alignContent: Alignment.TopStart });
            Stack.width('100%');
            Stack.height('100%');
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            NodeContainer.create(this.rootNodeController);
            NodeContainer.id('sdlSurface');
            NodeContainer.width('100%');
            NodeContainer.height('100%');
            NodeContainer.focusable(true);
            NodeContainer.focusOnTouch(true);
            NodeContainer.onAreaChange((_oldValue: Area, newValue: Area) => {
                this.onSurfaceAreaChange(newValue);
            });
        }, NodeContainer);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('SDL2 GUI validation');
            Text.fontSize(24);
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor(Color.White);
            Text.backgroundColor('#CC111722');
            Text.position({ x: 12, y: 12 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.renderReadyText);
            Text.id('renderReady');
            Text.fontSize(16);
            Text.fontColor(Color.White);
            Text.backgroundColor('#CC111722');
            Text.position({ x: 12, y: 48 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.nativeStatusText);
            Text.id('nativeStatus');
            Text.fontSize(14);
            Text.fontColor(Color.White);
            Text.backgroundColor('#CC111722');
            Text.position({ x: 12, y: 76 });
        }, Text);
        Text.pop();
        Stack.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "Index";
    }
}
if (storage && storage.routeName != undefined && storage.storage != undefined) {
    registerNamedRoute(() => new Index(undefined, {}, storage.useSharedStorage ? LocalStorage.getShared() : storage.storage), storage.routeName, { bundleName: "com.thirdparty.validation.sdl2", moduleName: "entry", pagePath: "pages/Index", pageFullPath: "entry/src/main/ets/pages/Index", integratedHsp: "false", moduleType: "followWithHap" });
}
else if (storage && storage.routeName != undefined && storage.storage == undefined) {
    registerNamedRoute(() => new Index(undefined, {}, storage.useSharedStorage ? LocalStorage.getShared() : storage.storage), storage.routeName, { bundleName: "com.thirdparty.validation.sdl2", moduleName: "entry", pagePath: "pages/Index", pageFullPath: "entry/src/main/ets/pages/Index", integratedHsp: "false", moduleType: "followWithHap" });
}
else if (storage && storage.routeName == undefined && storage.storage != undefined) {
    registerNamedRoute(() => new Index(undefined, {}, storage.useSharedStorage ? LocalStorage.getShared() : storage.storage), "", { bundleName: "com.thirdparty.validation.sdl2", moduleName: "entry", pagePath: "pages/Index", pageFullPath: "entry/src/main/ets/pages/Index", integratedHsp: "false", moduleType: "followWithHap" });
}
else if (storage && storage.useSharedStorage != undefined) {
    registerNamedRoute(() => new Index(undefined, {}, storage.useSharedStorage ? LocalStorage.getShared() : undefined), "", { bundleName: "com.thirdparty.validation.sdl2", moduleName: "entry", pagePath: "pages/Index", pageFullPath: "entry/src/main/ets/pages/Index", integratedHsp: "false", moduleType: "followWithHap" });
}
else {
    registerNamedRoute(() => new Index(undefined, {}, storage), "", { bundleName: "com.thirdparty.validation.sdl2", moduleName: "entry", pagePath: "pages/Index", pageFullPath: "entry/src/main/ets/pages/Index", integratedHsp: "false", moduleType: "followWithHap" });
}
