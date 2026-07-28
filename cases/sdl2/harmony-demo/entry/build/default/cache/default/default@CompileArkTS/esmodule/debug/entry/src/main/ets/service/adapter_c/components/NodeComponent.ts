import { NodeType } from "@bundle:com.thirdparty.validation.sdl2/entry/ets/service/adapter_c/common/Node";
import type { NodeParams, ViewNodeController } from "@bundle:com.thirdparty.validation.sdl2/entry/ets/service/adapter_c/common/Node";
export function WindowBuilderForView(params: NodeParams, parent = null) {
    const __params__ = params;
    (parent ? parent : this).observeComponentCreation2((elmtId, isInitialRender, params = __params__) => {
        Stack.create({ alignContent: Alignment.TopStart });
    }, Stack);
    (parent ? parent : this).observeComponentCreation2((elmtId, isInitialRender, params = __params__) => {
        If.create();
        if (params.node_type === NodeType.XComponent) {
            (parent ? parent : this).ifElseBranchUpdateFunction(0, () => {
                (parent ? parent : this).observeComponentCreation2((elmtId, isInitialRender, params = __params__) => {
                    XComponent.create({
                        id: params.node_xcomponent.id,
                        type: params.node_xcomponent.type,
                        libraryname: params.node_xcomponent.libraryname,
                        controller: params.node_xcomponent.controller
                    }, "com.thirdparty.validation.sdl2/entry");
                    XComponent.width('100%');
                    XComponent.height('100%');
                    XComponent.focusable(true);
                    XComponent.focusOnTouch(true);
                    XComponent.onLoad(params.node_xcomponent.onLoad);
                    XComponent.onDestroy(params.node_xcomponent.onDestroy);
                }, XComponent);
            });
        }
        else {
            this.ifElseBranchUpdateFunction(1, () => {
            });
        }
    }, If);
    If.pop();
    (parent ? parent : this).observeComponentCreation2((elmtId, isInitialRender, params = __params__) => {
        ForEach.create();
        const forEachItemGenFunction = _item => {
            const item = _item;
            (parent ? parent : this).observeComponentCreation2((elmtId, isInitialRender, params = __params__) => {
                NodeContainer.create(item);
                NodeContainer.zIndex(item.getParams().z_index);
                NodeContainer.position({
                    x: Number.isNaN(Number(item.getParams().position_x.toString())) ?
                        item.getParams().position_x : `${item.getParams().position_x}px`,
                    y: Number.isNaN(Number(item.getParams().position_y.toString())) ?
                        item.getParams().position_y : `${item.getParams().position_y}px`
                });
                NodeContainer.width(Number.isNaN(Number(item.getParams().width.toString())) ?
                    item.getParams().width : `${item.getParams().width}px`);
                NodeContainer.height(Number.isNaN(Number(item.getParams().height.toString())) ?
                    item.getParams().height : `${item.getParams().height}px`);
                NodeContainer.borderColor(item.getParams().border_color);
                NodeContainer.borderWidth(item.getParams().border_width);
                NodeContainer.visibility(item.getParams().visibility);
            }, NodeContainer);
        };
        (parent ? parent : this).forEachUpdateFunction(elmtId, params.node_list, forEachItemGenFunction, (_item: ViewNodeController, index: number) => index.toString(), false, true);
    }, ForEach);
    ForEach.pop();
    Stack.pop();
}
