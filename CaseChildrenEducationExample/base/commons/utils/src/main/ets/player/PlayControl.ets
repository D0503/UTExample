import {
  History,
  VideoCollection,
  SafeArrayList,
  DataGenerator,
  VideoCard
} from '@ohos_agcit/children_education_datasource';
import { CommonConstants } from '../constants/CommonConstants';
import { GlobalContext } from '../utils/GlobalContext';
import { ArrayList } from '@kit.ArkTS';
import { PreferencesUtil } from '../utils/PreferencesUtil';
import { request } from '@kit.BasicServicesKit';
import { fileIo as fs } from '@kit.CoreFileKit'
import { formBindingData, formInfo, formProvider } from '@kit.FormKit';


export async function historyRecord(videoDetailInfo: VideoCollection, index: number, videoType:number) {
  if (!videoDetailInfo.videoCardDetailList) {
    return;
  }
  let rawList = (GlobalContext.getContext().getObject(CommonConstants.HISTORY_LIST)  || []) as History[];
  const historyList = new SafeArrayList(rawList);
  let videoCard = videoDetailInfo.videoCard;

  // 如果存在，则删除
  let hitIndex = -1;
  historyList.forEach((history: History, index: number) => {
    if (history.videoCard.title === videoCard.title) {
      hitIndex = index;
    }
  });
  if (hitIndex !== -1) {
    historyList.removeByIndex(hitIndex);
  }

  // 添加新的数据
  let history: History = {
    // 所有集数信息列表
    videoCardList: videoDetailInfo.videoCardDetailList,
    videoCard: videoCard,
    lastWatch: videoDetailInfo.videoCardDetailList[index]
  };
  historyList.add(history);

  if (historyList.getCapacity() >= 20) {
    historyList.removeByIndex(0);
  }
  GlobalContext.getContext().setObject(CommonConstants.HISTORY_LIST, historyList.getRaw());
  await loadFile(history.lastWatch as VideoCard, videoType);
}

async function loadFile(lastWatch:VideoCard, videoType:number): Promise<void> {
  const context = GlobalContext.getContext().context as Context;
  const tempDir = context.cacheDir;
  const tmpFile = `${tempDir}/image_${Date.now()}.png`;
    
  try {
    const downloadTask = await request.downloadFile(context, {
      url: lastWatch.imageUrl,
      filePath: tmpFile
    });
    // 返回一个 Promise，等待下载完成
    await new Promise<void>((resolve) => {
      downloadTask.on('complete', () => {
        // 下载完成后获取文件描述符
        const file = fs.openSync(tmpFile);

        const uniqueKey = `img_${Date.now()}`;
        let imgMap:Record<string, number> = {};
        imgMap[uniqueKey] = file.fd;

        const data: ESObject = {
          id: lastWatch.id,
          title: lastWatch.title,
          updateCount: lastWatch.updateCount || 1,
          imgName: uniqueKey,
          formImages: imgMap,
          isHistory: true,
          videoType: videoType,
          param: lastWatch
        }

        const formData = formBindingData.createFormBindingData(data);

        // 保存数据到 Preferences，供 onAddForm 使用
        const preferencesUtil = PreferencesUtil.getInstance();
        const preference = preferencesUtil.getPreferences(context);
        preferencesUtil.preferencesPut(preference, 'id', lastWatch.id);
        preferencesUtil.preferencesPut(preference, 'title', lastWatch.title);
        preferencesUtil.preferencesPut(preference, 'updateCount', lastWatch.updateCount || 1);
        preferencesUtil.preferencesPut(preference, 'imgName', uniqueKey);
        preferencesUtil.preferencesPut(preference, 'formImages', imgMap);
        preferencesUtil.preferencesPut(preference, 'isHistory', true);
        preferencesUtil.preferencesPut(preference, 'videoType', videoType);
        preferencesUtil.preferencesPut(preference, 'param', lastWatch);
        preferencesUtil.preferencesPut(preference, 'imageUrl', lastWatch.imageUrl);
        preferencesUtil.preferencesFlush(preference);

        formProvider.getPublishedRunningFormInfos().then((data: formInfo.RunningFormInfo[]) => {
          console.info(`formProvider getPublishedRunningFormInfos, data: ${JSON.stringify(data)}`);

          data.forEach((form) => {
            let formId = form.formId
            formProvider.updateForm(formId, formData)
              .then(() => console.info('更新成功'))
              .catch((err:ESObject) => console.error('更新失败', err));
          })
        }).catch((error: BusinessError) => {
          console.error(`promise error, code: ${error.code}, message: ${error.message})`);
        });

        resolve();
      });
    });

  } catch (e) {
  }
}