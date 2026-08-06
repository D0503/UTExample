import { ComponentContent, promptAction } from '@kit.ArkUI';

enum PopViewShowType {
  OPEN
}


interface PopViewModel {
  com: ComponentContent<Object>;
  popType: PopViewShowType;
}

/**
 * 全局弹窗类
 */
export class PopViewUtils {
  private infoList: PopViewModel[] = [];
  private static uiContext: UIContext;
  private static popShare: PopViewUtils;

  private static shareInstance(): PopViewUtils {
    if (!PopViewUtils.popShare) {
      PopViewUtils.popShare = new PopViewUtils();
    }
    return PopViewUtils.popShare;
  }

  private static async showDialog<T extends Object>(uiContext: UIContext, type: PopViewShowType,
    contentView: WrappedBuilder<[T]> | WrappedBuilder<[]>, args?: T,
    options?: promptAction.BaseDialogOptions): Promise<void> {
    if (!PopViewUtils.uiContext) {
      PopViewUtils.uiContext = uiContext;
    }
    if (PopViewUtils.uiContext) {
      let promptAction = PopViewUtils.uiContext.getPromptAction();
      let componentContent: ComponentContent<Object> | null = null;
      if (args) {
        componentContent = new ComponentContent(PopViewUtils.uiContext, contentView, args);
      } else {
        componentContent = new ComponentContent(PopViewUtils.uiContext, contentView as WrappedBuilder<[]>);
      }

      let customOptions: promptAction.BaseDialogOptions = {
        autoCancel: options?.autoCancel ?? true,
        maskColor: options?.maskColor,
        alignment: options?.alignment ?? DialogAlignment.Center,
        onWillDismiss: (v: DismissDialogAction) => {
          if (options?.autoCancel ?? true) {
            v.dismiss();
          }
        },
      };
      promptAction.openCustomDialog(componentContent, customOptions).catch(() => {
      });

      let infoList = PopViewUtils.shareInstance().infoList;
      let info: PopViewModel = {
        com: componentContent,
        popType: type,
      };
      infoList[0] = info;
    }
  }

  private static async closeDialog(uiContext: UIContext, type: PopViewShowType): Promise<void> {
    if (!PopViewUtils.uiContext) {
      PopViewUtils.uiContext = uiContext;
    }
    if (PopViewUtils.uiContext) {
      let prompt = PopViewUtils.uiContext.getPromptAction();
      let sameTypeList = PopViewUtils.shareInstance().infoList.filter((model) => {
        return model.popType === type;
      })
      let info = sameTypeList[sameTypeList.length - 1];
      if (info?.com) {
        PopViewUtils.shareInstance().infoList = PopViewUtils.shareInstance().infoList.filter((model) => {
          return model.com !== info.com;
        })
        prompt.closeCustomDialog(info.com).catch(() => {
        });
      }
    }
  }

  /**
   * 打开弹窗
   * @param contentView
   * @param args
   * @param options
   */
  public static showPopView<T extends Object>(uiContext: UIContext,
    contentView: WrappedBuilder<[T]> | WrappedBuilder<[]>,
    options?: promptAction.BaseDialogOptions, args?: T): void {
    PopViewUtils.showDialog(uiContext, PopViewShowType.OPEN, contentView, args, options);
  }

  /**
   * 关闭弹窗
   */
  public static closePopView(uiContext: UIContext): void {
    PopViewUtils.closeDialog(uiContext, PopViewShowType.OPEN);
  }
}
