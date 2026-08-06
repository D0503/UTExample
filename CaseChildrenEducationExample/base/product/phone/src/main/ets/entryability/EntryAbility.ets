import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { AppStorageV2, promptAction, window } from '@kit.ArkUI';
import {
  AvoidArea,
  CloudPrefetchUtils,
  CommonConstants,
  GlobalContext
} from '@ohos_agcit/children_education_utils';
import { webview } from '@kit.ArkWeb';
import { GlobalInfoModel } from '@ohos_agcit/children_education_utils'
import { url } from '@kit.ArkTS';
import { RouterModule } from '@ohos_agcit/children_education_utils'
import { PipManager} from 'recorded_player'

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  storage: LocalStorage = new LocalStorage();
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    GlobalContext.getContext().context = this.context;
    CloudPrefetchUtils.functionPreload();
    webview.WebviewController.initializeWebEngine();

    try {
      let url = this.context.resourceManager.getStringByNameSync('privacyAgreementPath')
      webview.WebviewController.prepareForPageLoad(url, true, 2);
    } catch (error) {
      hilog.error(DOMAIN, 'testTag', '%{public}s', 'prepareForPageLoad fail');
    }

    // 关闭应用接续数据迁移能力
    this.context.setMissionContinueState(AbilityConstant.ContinueState.INACTIVE, (result) => {
      console.info(`setMissionContinueState: ${JSON.stringify(result)}`);
    });

    const globalInfo =
      AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;

    // 碰一碰数据传输
    let uri = want?.uri;
    if (uri) {
      try {
        let urlObject = url.URL.parseURL(want?.uri);
        const name = urlObject.params.get('name')
        const param = urlObject.params.get('param')?.toString() as string;
        globalInfo.navStack.pushPathByName(name, JSON.parse(param))
      } catch (e) {
      }
    }


    // 应用接续
    if (launchParam.launchReason === AbilityConstant.LaunchReason.CONTINUATION) {
      // 将上述的保存的数据取出恢复
      let continueInput = '';
      if (want.parameters !== undefined) {
        const routerName: string = (want.parameters.data as ESObject).routerName;
        const param: ESObject = (want.parameters.data as ESObject).param;
        const currentTime: ESObject = (want.parameters.data as ESObject).currentTime;
        param.currentTime = currentTime || 0;
        if (routerName === 'VideoPlayPage') {
          CommonConstants.GLOBAL_VIDEO_LIST
          GlobalContext.getContext().setObject(CommonConstants.GLOBAL_VIDEO_LIST, param)
        }
        globalInfo.navStack.pushPathByName(routerName, param)
      }
      // ...
      // 触发页面恢复
      this.context.restoreWindowStage(this.storage);
    }
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    const globalInfo =
      AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;
    if (want.parameters && want.parameters.params) {
      let param:ESObject =  {};
      try {
        param = JSON.parse(want.parameters.params as string)
      } catch (e) {
      }
      if (param.message === 'HotAnimationListView') {
        globalInfo.navStack.replacePathByName('HotAnimationListView', '热门推荐')
      }
      if (param.message === 'ViewHistory') {
        globalInfo.navStack.replacePathByName('ViewHistory', true)
      }
      if (param.message === 'VideoPlayPage' && param.param !== '') {
        const data:object = typeof param.param === 'object'?param.param:JSON.parse(param.param);
        globalInfo.navStack.pushPathByName('VideoPlayPage',data )
      }
      if (param.message === 'AudioPlayPage' && param.param !== '') {
        const data:object = typeof param.param === 'object'?param.param:JSON.parse(param.param);
        globalInfo.navStack.pushPathByName('AudioPlayPage', data)
      }
    }
    // 碰一碰数据传输
    let uri = want?.uri;
    if (uri) {
      try {
        let urlObject = url.URL.parseURL(want?.uri);
        const name = urlObject.params.get('name')
        const param = urlObject.params.get('param')?.toString() as string;
        globalInfo.navStack.pushPathByName(name, JSON.parse(param))
      } catch (e) {
      }
    }

    // 应用接续数据传输
    if (launchParam.launchReason === AbilityConstant.LaunchReason.CONTINUATION) {
      // 将上述的保存的数据取出恢复
      let continueInput = '';
      if (want.parameters !== undefined) {
      const routerName:string = (want.parameters.data as ESObject).routerName;
      const param:ESObject = (want.parameters.data as ESObject).param;
      const currentTime: ESObject = (want.parameters.data as ESObject).currentTime;
      param.currentTime = currentTime || 0;
        if (routerName === 'VideoPlayPage') {
          CommonConstants.GLOBAL_VIDEO_LIST
          GlobalContext.getContext().setObject(CommonConstants.GLOBAL_VIDEO_LIST, param)
        }
        globalInfo.navStack.pushPathByName(routerName, param)
      }
      // ...
      // 触发页面恢复
      this.context.restoreWindowStage(this.storage);
    }
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');

      // 沉浸式布局
      let windowClass: window.Window = windowStage.getMainWindowSync();
      let isLayoutFullScreen = true;
      windowClass.setWindowLayoutFullScreen(isLayoutFullScreen).then(() => {
        console.info('Succeeded in setting the window layout to full-screen mode.');
      }).catch((err: BusinessError) => {
        console.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
      });

      // 导航条与状态栏避让
      let topAvoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      let topRectHeight = topAvoidArea.topRect.height; // 获取状态栏区域高度
      let bottomAvoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      let bottomRectHeight = bottomAvoidArea.bottomRect.height; // 获取到导航条区域的高度
      AppStorageV2.connect(AvoidArea, () => new AvoidArea(topRectHeight, bottomRectHeight));

      // 注册监听函数，动态获取避让区域数据
      windowClass.on('avoidAreaChange', (data) => {
        let avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
        if (data.type === window.AvoidAreaType.TYPE_SYSTEM) {
          avoidArea.topRectHeight = data.area.topRect.height;
        } else if (data.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          avoidArea.bottomRectHeight = data.area.bottomRect.height;
        }
      })
    })
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }

  onContinue(wantParam: Record<string, Object>) {
    const targetVersion = wantParam.version; // 获取迁移对端应用的版本号
    // 应用可根据源端版本号设置支持接续的最小兼容版本号，源端版本号可从app.json5文件中的versionCode字段获取；防止目标端版本号过低导致不兼容。
    const versionThreshold: number = 0; // 替换为应用自己支持兼容的最小版本号
    // 兼容性校验
    if (targetVersion < versionThreshold) {
      // 建议在校验版本兼容性失败后，提示用户拒绝迁移的原因
      promptAction.showToast({
        message: '目标端应用版本号过低，不支持接续，请您升级应用版本后再试',
        duration: 2000
      })
      // 在兼容性校验不通过时返回MISMATCH
      return AbilityConstant.OnContinueResult.MISMATCH;
    }
    console.info(`onContinue version = ${wantParam.version}, targetDevice: ${wantParam.targetDevice}`)
    const currentTime = PipManager.getInstance().player.currentTime || 0;
    // 迁移数据保存
    const param:Record<string, ESObject> = {
      'routerName':RouterModule.routerName,
      'param':RouterModule.param,
      'currentTime': currentTime,
    }
    const continueInput = param;
    if (continueInput) {
      // 将要迁移的数据保存在wantParam的自定义字段（如：data）中;
      wantParam.data = continueInput;
    }
    // ...
    return AbilityConstant.OnContinueResult.AGREE;
  }
};
