if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Index_Params {
    version?: string;
    summary?: string;
    details?: string;
}
import libuv from "@app:com.thirdparty.validation.libuv.base/entry/entry";
import type { LibuvTestResult } from "@app:com.thirdparty.validation.libuv.base/entry/entry";
class Index extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__version = new ObservedPropertySimplePU('loading', this, "version");
        this.__summary = new ObservedPropertySimplePU('Native checks are running', this, "summary");
        this.__details = new ObservedPropertySimplePU('', this, "details");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Index_Params) {
        if (params.version !== undefined) {
            this.version = params.version;
        }
        if (params.summary !== undefined) {
            this.summary = params.summary;
        }
        if (params.details !== undefined) {
            this.details = params.details;
        }
    }
    updateStateVars(params: Index_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__version.purgeDependencyOnElmtId(rmElmtId);
        this.__summary.purgeDependencyOnElmtId(rmElmtId);
        this.__details.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__version.aboutToBeDeleted();
        this.__summary.aboutToBeDeleted();
        this.__details.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __version: ObservedPropertySimplePU<string>;
    get version() {
        return this.__version.get();
    }
    set version(newValue: string) {
        this.__version.set(newValue);
    }
    private __summary: ObservedPropertySimplePU<string>;
    get summary() {
        return this.__summary.get();
    }
    set summary(newValue: string) {
        this.__summary.set(newValue);
    }
    private __details: ObservedPropertySimplePU<string>;
    get details() {
        return this.__details.get();
    }
    set details(newValue: string) {
        this.__details.set(newValue);
    }
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
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: 18 });
            Column.padding(40);
            Column.width('100%');
            Column.height('100%');
            Column.justifyContent(FlexAlign.Center);
            Column.backgroundColor('#F7F8FC');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('libuv HarmonyOS validation');
            Text.fontSize(30);
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`libuv ${this.version}`);
            Text.fontSize(20);
            Text.fontColor('#5B67F1');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.summary);
            Text.id('libuv_result');
            Text.fontSize(24);
            Text.fontWeight(FontWeight.Medium);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.details);
            Text.fontSize(18);
            Text.textAlign(TextAlign.Center);
            Text.lineHeight(28);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('Run again');
            Button.onClick(() => this.aboutToAppear());
        }, Button);
        Button.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "Index";
    }
}
registerNamedRoute(() => new Index(undefined, {}), "", { bundleName: "com.thirdparty.validation.libuv.base", moduleName: "entry", pagePath: "pages/Index", pageFullPath: "entry/src/main/ets/pages/Index", integratedHsp: "false", moduleType: "followWithHap" });
