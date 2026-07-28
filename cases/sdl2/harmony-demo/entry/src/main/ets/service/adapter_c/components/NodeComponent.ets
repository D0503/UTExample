/*
 * Derived from the OpenHarmony SDL2 port at commit
 * 77fc66603a1ddfafca45daf6367824a10ff05562 (Apache-2.0).
 */
import { NodeParams, NodeType, ViewNodeController } from '../common/Node';

@Builder
export function WindowBuilderForView(params: NodeParams) {
  Stack({ alignContent: Alignment.TopStart }) {
    if (params.node_type === NodeType.XComponent) {
      XComponent({
        id: params.node_xcomponent.id,
        type: params.node_xcomponent.type,
        libraryname: params.node_xcomponent.libraryname,
        controller: params.node_xcomponent.controller
      })
        .width('100%')
        .height('100%')
        .focusable(true)
        .focusOnTouch(true)
        .onLoad(params.node_xcomponent.onLoad)
        .onDestroy(params.node_xcomponent.onDestroy)
    }

    ForEach(params.node_list, (item: ViewNodeController) => {
      NodeContainer(item)
        .zIndex(item.getParams().z_index)
        .position({
          x: Number.isNaN(Number(item.getParams().position_x.toString())) ?
            item.getParams().position_x : `${item.getParams().position_x}px`,
          y: Number.isNaN(Number(item.getParams().position_y.toString())) ?
            item.getParams().position_y : `${item.getParams().position_y}px`
        })
        .width(Number.isNaN(Number(item.getParams().width.toString())) ?
          item.getParams().width : `${item.getParams().width}px`)
        .height(Number.isNaN(Number(item.getParams().height.toString())) ?
          item.getParams().height : `${item.getParams().height}px`)
        .borderColor(item.getParams().border_color)
        .borderWidth(item.getParams().border_width)
        .visibility(item.getParams().visibility)
    }, (_item: ViewNodeController, index: number) => index.toString())
  }
}
