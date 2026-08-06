import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import { DataGenerator, History, VideoCard } from '@ohos_agcit/children_education_datasource';
import { CommonConstants, GlobalContext, PreferencesUtil } from '@ohos_agcit/children_education_utils';
import { request } from '@kit.BasicServicesKit';
import { fileIo as fs} from '@kit.CoreFileKit'
import { common } from '@kit.AbilityKit';

interface GeneratedObjectLiteralInterface_1 {
  id: string | number | bigint | true | object;
  title: string | number | bigint | true | object;
  updateCount: string | number | bigint | true | object;
  imageUrl: string | number | bigint | true | object;
}

interface GeneratedObjectLiteralInterface_2 {
  'imgUrl': number;
}

interface GeneratedObjectLiteralInterface_3 {}

export default class PhoneFormAbility extends FormExtensionAbility {
  onAddForm(want: Want) {
    // Called to return a FormBindingData object.
    const cloudUrl = this.context.resourceManager.getStringByNameSync('cloud_datastore')
    let videoUrl = this.context.resourceManager.getStringByNameSync('videoUrlOne')
    const hotData:ESObject =  {
      id: '00042',
      cardId: '1003',
      title: '风沙中的对决',
      imageUrl: cloudUrl +
        'v0/children-education-kqxc3/common%2F1756539491_huge.png?token=451028ba-72e5-4a8d-a4af-0aa54e5a761a',
      videoNumber: 1,
      iconUrl: 'app.media.icon_free',
      videoUrl: videoUrl,
      isVip: false,
      videoType: 0,
      updateCount: 50,
      totalCount: 52,
    };
    const formId = want.parameters![formInfo.FormParam.IDENTITY_KEY] as string;
    const preferencesUtil = PreferencesUtil.getInstance();
    const preference = preferencesUtil.getPreferences(this.context)
    preferencesUtil.addFormId(preference, formId);

    const id = preferencesUtil.getPreferencesValue(preference, 'id');
    if (id) {
      const title = preferencesUtil.getPreferencesValue(preference, 'title')
      const updateCount = preferencesUtil.getPreferencesValue(preference, 'updateCount')
      const imgName = preferencesUtil.getPreferencesValue(preference, 'imgName')
      const formImages = preferencesUtil.getPreferencesValue(preference, 'formImages')
      const isHistory = preferencesUtil.getPreferencesValue(preference, 'isHistory')
      const videoType = preferencesUtil.getPreferencesValue(preference, 'videoType')
      const param = JSON.stringify(preferencesUtil.getPreferencesValue(preference, 'param'))

      // imgName 为空或 formImages 无效，先返回初始数据（不包含图片），避免卡片显示空白
      const initialData: ESObject = {
        id: id,
        title: title,
        updateCount: updateCount,
        imgName: imgName,
        formImages: formImages,
        isHistory: isHistory,
        videoType: videoType,
        param: param
      }

      // 异步下载图片并更新卡片
      const downLoad = async () => {
        try {
          // 保存当前需要的数据到局部变量，避免闭包问题
          const currentFormId = formId;
          const currentId = id;
          const currentTitle = title;
          const currentUpdateCount = updateCount;
          const currentIsHistory = isHistory;
          const currentVideoType = videoType;
          const currentParam = param;

          // 从 Preferences 中获取图片 URL
          const imageUrl = preferencesUtil.getPreferencesValue(preference, 'imageUrl');
          if (!imageUrl) {
            return;
          }

          const tempDir = this.context.tempDir;
          const tmpFile = `${tempDir}/image_${currentFormId}_${Date.now()}.png`;

          const downloadTask = await request.downloadFile(this.context, {
            url: imageUrl as string,
            filePath: tmpFile
          });
          downloadTask.on('complete', () => {
            // 下载完成后获取文件描述符
            const file = fs.openSync(tmpFile);
            const uniqueKey = `img_${currentFormId}_${Date.now()}`;
            let imgMap:Record<string, number> = {};
            imgMap[uniqueKey] = file.fd;
            
            const formData: ESObject = {
              id: currentId,
              title: currentTitle,
              updateCount: currentUpdateCount,
              imgName: uniqueKey,
              formImages: imgMap,
              isHistory: currentIsHistory,
              videoType: currentVideoType,
              param: currentParam
            }
            try {
              formProvider.updateForm(currentFormId, formBindingData.createFormBindingData(formData));
            } catch (e) {
            }
          });
        } catch (e) {
        }
      }
      downLoad()
      
      return formBindingData.createFormBindingData(initialData);
    } else {
      const data: ESObject = {
        id: hotData.id,
        title: hotData.title,
        updateCount: hotData.updateCount,
        imgName: '',
        formImages:{} as Record<string, number>,
        isHistory:false,
        videoType: 0,
      }
      try {
        const downLoad = async () => {
          // 保存当前需要的数据到局部变量，避免闭包问题
          const currentFormId = formId;
          const currentImageUrl:string = hotData.imageUrl;
          const tempDir = this.context.tempDir;
          const tmpFile = `${tempDir}/image_${currentFormId}_${Date.now()}.png`;
          
          const downloadTask = await request.downloadFile(this.context, {
            url: currentImageUrl,
            filePath: tmpFile
          });
          downloadTask.on('complete', () => {
            // 下载完成后获取文件描述符
            const file = fs.openSync(tmpFile);
            const uniqueKey = `img_${currentFormId}_${Date.now()}`;
            let imgMap:Record<string, number> = {};
            imgMap[uniqueKey] = file.fd;
            data.imgName = uniqueKey;
            data.formImages = imgMap;
            try {
              formProvider.updateForm(currentFormId, formBindingData.createFormBindingData(data));
            } catch (e) {
            }
          });
        }
        downLoad()

      } catch (e) {
      }

      return formBindingData.createFormBindingData(data);
    }

  }

  onCastToNormalForm(formId: string) {
    // Called when the form provider is notified that a temporary form is successfully
    // converted to a normal form.
  }

  onUpdateForm(formId: string) {
    // Called to notify the form provider to update a specified form.
  }

  async onFormEvent(formId: string, message: string) {
    // Called when a specified message event defined by the form provider is triggered.

  }

  onRemoveForm(formId: string) {
    // Called to notify the form provider that a specified form has been destroyed.
  }

  onAcquireFormState(want: Want) {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
}