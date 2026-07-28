import { BuilderNode, NodeController } from "@ohos:arkui.node";
import type { FrameNode, Size } from "@ohos:arkui.node";
import type { UIContext } from "@ohos:arkui.UIContext";
import { WindowBuilderForView } from "@bundle:com.thirdparty.validation.sdl2/entry/ets/service/adapter_c/components/NodeComponent";
import { XComponentModel } from "@bundle:com.thirdparty.validation.sdl2/entry/ets/service/adapter_c/common/ComponentModel";
export enum NodeType {
    XComponent = 0,
    UIExtension = 1,
    Container = 2
}
@Observed
export class NodeParams {
    public node_list: Array<ViewNodeController> = [];
    public width: Length = '100%';
    public height: Length = '100%';
    public position_x: Length = 0;
    public position_y: Length = 0;
    public border_color: string = '#FFFFFF';
    public border_width: Length = 0;
    public node_type: NodeType = NodeType.Container;
    public z_index: number = 1;
    public visibility: Visibility = Visibility.Visible;
    public node_xcomponent: XComponentModel = new XComponentModel('', XComponentType.SURFACE, '');
    constructor(x?: Length, y?: Length, width?: Length, height?: Length, nodeType?: NodeType, xcomponent?: XComponentModel) {
        if (x !== undefined)
            this.position_x = x;
        if (y !== undefined)
            this.position_y = y;
        if (width !== undefined)
            this.width = width;
        if (height !== undefined)
            this.height = height;
        if (nodeType !== undefined)
            this.node_type = nodeType;
        if (xcomponent !== undefined)
            this.node_xcomponent = xcomponent;
    }
}
export class ViewNodeController extends NodeController {
    private builderNode: BuilderNode<NodeParams[]> | null = null;
    private wrapBuilder = new WrappedBuilder<[
        NodeParams
    ]>(WindowBuilderForView);
    private uiContext: UIContext;
    private params: NodeParams;
    private parent: ViewNodeController | null = null;
    public widthReal: number = 0;
    public heightReal: number = 0;
    constructor(uiContext: UIContext, params?: NodeParams) {
        super();
        this.uiContext = uiContext;
        this.params = params ?? new NodeParams();
        this.builderNode = new BuilderNode(this.uiContext);
        this.builderNode.build(this.wrapBuilder, this.params);
    }
    makeNode(_uiContext: UIContext): FrameNode | null {
        return this.builderNode?.getFrameNode() ?? null;
    }
    aboutToResize(size: Size): void {
        this.widthReal = size.width;
        this.heightReal = size.height;
    }
    getCurNode(): BuilderNode<NodeParams[]> | null {
        return this.builderNode;
    }
    getParent(): ViewNodeController | null {
        return this.parent;
    }
    setParent(parent: ViewNodeController): void {
        this.parent = parent;
    }
    getUIContext(): UIContext {
        return this.uiContext;
    }
    getParams(): NodeParams {
        return this.params;
    }
    setParams(params: NodeParams): void {
        this.params = params;
        this.update();
    }
    update(): void {
        this.builderNode?.update(this.params);
    }
    delete(): void {
        this.params.node_list.forEach((child: ViewNodeController) => child.delete());
        this.builderNode = null;
    }
}
