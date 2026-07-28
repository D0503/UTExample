import type { UIContext } from "@ohos:arkui.UIContext";
import { NodeParams, ViewNodeController } from "@bundle:com.thirdparty.validation.sdl2/entry/ets/service/adapter_c/common/Node";
import { XComponentModel } from "@bundle:com.thirdparty.validation.sdl2/entry/ets/service/adapter_c/common/ComponentModel";
const nodeMap = new Map<number, ViewNodeController>();
export function getNodeByWindowId(windowId: number): ViewNodeController | undefined {
    return nodeMap.get(windowId);
}
export function addRootNode(windowId: number, uiContext: UIContext, params: NodeParams): ViewNodeController {
    const root = new ViewNodeController(uiContext, params);
    nodeMap.set(windowId, root);
    return root;
}
export function addChildNode(parent: ViewNodeController, params?: NodeParams): ViewNodeController {
    let childParams: NodeParams = new NodeParams();
    if (params !== undefined) {
        const model = new XComponentModel(params.node_xcomponent.id, params.node_xcomponent.type, params.node_xcomponent.libraryname);
        model.onLoad = params.node_xcomponent.onLoad;
        model.onDestroy = params.node_xcomponent.onDestroy;
        childParams = new NodeParams(params.position_x, params.position_y, params.width, params.height, params.node_type, model);
        childParams.border_color = params.border_color;
        childParams.border_width = params.border_width;
    }
    const child = new ViewNodeController(parent.getUIContext(), childParams);
    parent.getParams().node_list.push(child);
    child.setParent(parent);
    parent.update();
    return child;
}
export function removeChildNode(child: ViewNodeController): void {
    const parent = child.getParent();
    if (parent === null)
        return;
    const children = parent.getParams().node_list;
    const index = children.indexOf(child);
    if (index >= 0)
        children.splice(index, 1);
    parent.update();
    child.delete();
}
export function resizeNode(node: ViewNodeController, width: string, height: string): void {
    node.getParams().width = width;
    node.getParams().height = height;
    node.getParent()?.update();
}
export function adjustNodeZOrder(node: ViewNodeController, zIndex: number): void {
    node.getParams().z_index = zIndex;
    node.getParent()?.update();
}
export function setNodeVisibility(node: ViewNodeController, visibility: number): void {
    node.getParams().visibility = visibility as Visibility;
    node.getParent()?.update();
}
export function getNodeRect(node: ViewNodeController): number[] {
    return [
        Number(node.getParams().position_x),
        Number(node.getParams().position_y),
        node.widthReal,
        node.heightReal
    ];
}
export function moveNode(node: ViewNodeController, x: Length, y: Length): void {
    node.getParams().position_x = x;
    node.getParams().position_y = y;
    node.getParent()?.update();
}
export function raiseNode(node: ViewNodeController): void {
    const parent = node.getParent();
    if (parent === null)
        return;
    let maximum = 0;
    parent.getParams().node_list.forEach((item: ViewNodeController) => {
        maximum = Math.max(maximum, item.getParams().z_index);
    });
    node.getParams().z_index = maximum + 1;
    parent.update();
}
export function lowerNode(node: ViewNodeController): void {
    const parent = node.getParent();
    if (parent === null)
        return;
    let minimum = node.getParams().z_index;
    parent.getParams().node_list.forEach((item: ViewNodeController) => {
        minimum = Math.min(minimum, item.getParams().z_index);
    });
    node.getParams().z_index = Math.max(0, minimum - 1);
    parent.update();
}
export function reParentNode(newParent: ViewNodeController, child: ViewNodeController): void {
    const oldParent = child.getParent();
    if (oldParent !== null) {
        const index = oldParent.getParams().node_list.indexOf(child);
        if (index >= 0)
            oldParent.getParams().node_list.splice(index, 1);
        oldParent.update();
    }
    newParent.getParams().node_list.push(child);
    child.setParent(newParent);
    newParent.update();
}
export function setNodeBorderColor(node: ViewNodeController, color: string): ViewNodeController {
    node.getParams().border_color = color;
    node.getParent()?.update();
    return node;
}
export function setNodeBorderWidth(node: ViewNodeController, width: Length): ViewNodeController {
    node.getParams().border_width = width;
    node.getParent()?.update();
    return node;
}
export function setNodeParams(node: ViewNodeController, params: NodeParams): ViewNodeController {
    node.setParams(params);
    return node;
}
export function getXcomponentId(node: ViewNodeController): string {
    return node.getParams().node_xcomponent.id;
}
