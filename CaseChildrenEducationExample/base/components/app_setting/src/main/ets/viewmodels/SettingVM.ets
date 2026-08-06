import { common, ConfigurationConstant, EnvironmentCallback } from '@kit.AbilityKit';
import { BaseViewModel } from '../models/BaseViewModel';
import { SettingGroup, SettingItem } from '../types/SettingItem';
import { SettingPageEnum, SettingType, SupportedSetting } from '../types/SettingType';
import { AboutModel, AgreementModel, IFontModel, WebModel } from '../models/CustomConfigModel';
import { Logger } from '../common/Logger';
import { FileUtils } from '../common/FileUtils';
import { AppGalleryUtils } from '../common/AppGalleryUtils';
import { lightDarkOptions } from '../constants/LightDarkOptions';
import { CommonConfirmDialog } from '../components/CommonConfirmDialog';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[SettingViewModel]';

@ObservedV2
export class SettingViewModel extends BaseViewModel {
  logTag: string = 'SettingViewModel';
  domainId: number = 0x0000;
  @Trace settingList: SettingGroup[] = [];
  @Trace callbackId: number = 0;
  public uiContext: UIContext | null = null;
  public context: common.UIAbilityContext | null = null;

  handleSettingList(list: SettingGroup[]) {
    this.settingList = list;
    this.settingList.forEach((v: SettingGroup) => {
      v.list.forEach(async (item: SettingItem) => {
        switch (item.supportedType) {
          case SupportedSetting.PRIVACY:
            this.handlePrivacy(item);
            break;
          case SupportedSetting.CLEAR_CACHE:
            this.handleCache(item);
            break;
          case SupportedSetting.LIGHT_DARK_MODE:
            this.handleDark(item);
            break;
          case SupportedSetting.FONT_SIZE:
            this.handleFont(item);
            break;
          case SupportedSetting.CHECK_VERSION:
            this.handleVersionCheck(item);
            break;
          case SupportedSetting.ABOUT:
            this.handleAbout(item);
            break;
          case SupportedSetting.WEB:
            this.handleWeb(item);
            break;
        }
      })
    })
  }

  handlePrivacy(item: SettingItem) {
    item.setType(SettingType.ROUTER)
      .setLabel(item.label ?? '隐私设置')
      .setRouterParam({ routerName: SettingPageEnum.SETTING_PRIVACY });
    this.handleGlobalAgreement(item.extraParams as AgreementModel);
  }

  async handleCache(item: SettingItem) {
    item.setType(SettingType.TEXT)
      .setLabel(item.label ?? '清理缓存')
      .setClickEvent(() => {
        if (!this.uiContext) {
          return;
        }
        CommonConfirmDialog.show(
          this.uiContext,
          {
            primaryTitle: '温馨提示',
            content: 'APP使用过程中下载的图片、音频、视频等资源将被清除，不可还原。',
            confirm: () => {
              FileUtils.clearCache(this.uiContext?.getHostContext()!);
              setTimeout(async () => {
                const cache = await this.getCache();
                item.setNormalText(cache);
                try {
                  this.uiContext?.getPromptAction().showToast({ message: '清除缓存成功' });
                } catch (error) {
                }
                if (item.onChange) {
                  item.onChange(cache);
                }
              }, 400)
            },
          })
      })
    const cache = await this.getCache();
    item.setNormalText(cache);
  }

  handleDark(item: SettingItem) {
    const options = item.selectOptions ?? lightDarkOptions;
    if (item.selectIndex < options.length && item.selectIndex >= 0) {
      const colorMode = options[item.selectIndex].value as ConfigurationConstant.ColorMode;
      try {
        this.uiContext?.getHostContext()?.getApplicationContext().setColorMode(colorMode);
      } catch (error) {
        hilog.error(this.domainId, this.logTag,
          `Error occurred. errCode is ${error.code}, errMessage is ${error.message}`);
      }
    }

    item.setType(SettingType.SELECT)
      .setLabel(item.label ?? '夜间模式')
      .setSelectOptions(item.selectOptions ?? lightDarkOptions)
      .setSelectEvent((index: number) => {
        const colorMode = lightDarkOptions[index].value as ConfigurationConstant.ColorMode;
        this.uiContext?.getHostContext()?.getApplicationContext().setColorMode(colorMode);
        if (item.onChange) {
          item.onChange(colorMode);
        }
      })
  }

  handleFont(item: SettingItem) {
    item.setType(SettingType.ROUTER)
      .setLabel(item.label ?? '字体大小')
      .setRouterParam({ routerName: SettingPageEnum.SETTING_FONT });
    this.handleGlobalFont(item.extraParams as IFontModel);
  }

  handleVersionCheck(item: SettingItem) {
    item.setType(SettingType.TEXT)
      .setLabel(item.label ?? '检测版本')
      .setClickEvent(() => {
        const context = this.uiContext?.getHostContext() as common.UIAbilityContext;
        if (!context) {
          return;
        }
        AppGalleryUtils.checkAppUpdate(context).then((resp: boolean) => {
          if (resp) {
            AppGalleryUtils.showUpdateDialog(context);
          } else {
            this.uiContext?.getPromptAction().showToast({ message: '已是最新版本' });
          }
          if (item.onChange) {
            item.onChange(resp);
          }
        })
      })
  }

  handleAbout(item: SettingItem) {
    item.setType(SettingType.ROUTER)
      .setLabel(item.label ?? '关于我们')
      .setRouterParam({ routerName: SettingPageEnum.SETTING_ABOUT });
    this.handleGlobalAbout(item.extraParams as AboutModel);
  }

  handleWeb(item: SettingItem) {
    item.setRouterParam({
      routerName: SettingPageEnum.SETTING_AGREEMENT,
      routerParams: (item.extraParams as WebModel).src,
    })
  }

  handleGlobalAgreement(agreementInfo: AgreementModel) {
    if (agreementInfo.userAgreement) {
      this.configInfo.agreementModel.userAgreement = agreementInfo.userAgreement;
    }
    if (agreementInfo.privacyPolicy) {
      this.configInfo.agreementModel.privacyPolicy = agreementInfo.privacyPolicy;
    }
    if (agreementInfo.thirtyItem) {
      this.configInfo.agreementModel.thirtyItem = agreementInfo.thirtyItem;
    }
    if (agreementInfo.personalCollection) {
      this.configInfo.agreementModel.personalCollection = agreementInfo.personalCollection;
    }
  }

  handleGlobalAbout(aboutModel: AboutModel) {
    if (aboutModel.icpText) {
      this.configInfo.aboutModel.icpText = aboutModel.icpText;
    }
    if (aboutModel.copyrightText) {
      this.configInfo.aboutModel.copyrightText = aboutModel.copyrightText;
    }
    if (aboutModel.hotline) {
      this.configInfo.aboutModel.hotline = aboutModel.hotline;
    }
  }

  handleGlobalFont(fontModel: IFontModel) {
    this.fontModel.followSystem = fontModel.followSystem ?? false;
    this.fontModel.fontSizeRatio = fontModel.fontSizeRatio ?? 1;
    this.fontModel.onChange = () => {
      fontModel.onChange?.(this.fontModel.followSystem, this.fontModel.fontSizeRatio,
        this.fontModel.sysFontSizeScale);
    };
  }

  getCache() {
    return FileUtils.getCache().then((resp: number) => {
      const cacheSize = (resp / 1024 / 1024).toFixed(2);
      return `${cacheSize}M`;
    })
  }

  onConfigurationUpdate(): void {
    if (!this.context) {
      return;
    }
    this.fontModel.sysFontSizeScale = this.context.config.fontSizeScale as number;
    let environmentCallback: EnvironmentCallback = {
      onConfigurationUpdated: (config) => {
        this.fontModel.sysFontSizeScale = config.fontSizeScale as number;
      },
      onMemoryLevel: () => {
      },
    }
    try {
      this.callbackId = this.context.getApplicationContext().on('environment', environmentCallback);
    } catch (err) {
      Logger.error(TAG, `Failed to register applicationContext. err: ${JSON.stringify(err)}`);
    }
  }

  offConfigurationUpdate() {
    if (!this.context) {
      return;
    }
    this.context.getApplicationContext().off('environment', this.callbackId);
  }
}
