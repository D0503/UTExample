import { iap } from '@kit.IAPKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { MemberList } from '../model/Index';

export class MemberStatusUtil {
  static logTag: string = 'MemberStatusUtil';
  static domainId: number = 0x0000;
  
  static queryPurchase(uiContext: common.UIAbilityContext): Promise<MemberList> {
    // 查询是否有当前用户的会员购买记录
    let memberList: MemberList = new MemberList();
    let autoRenewParam: iap.QueryPurchasesParameter = {
      productType: iap?.ProductType.AUTORENEWABLE,
      queryType: iap?.PurchaseQueryType.CURRENT_ENTITLEMENT,
    };
    let nonRenewParam: iap.QueryPurchasesParameter = {
      productType: iap?.ProductType.NONRENEWABLE,
      queryType: iap?.PurchaseQueryType.ALL,
    };

    let nonConsumeParam: iap.QueryPurchasesParameter = {
      productType: iap?.ProductType.NONCONSUMABLE,
      queryType: iap?.PurchaseQueryType.CURRENT_ENTITLEMENT,
    };

    const emptyResult: iap.QueryPurchaseResult = {
      purchaseDataList: [],
      continuationToken: ''
    };

    const autoRenewPromise =
      iap.queryPurchases(uiContext, autoRenewParam)
        .catch((error: BusinessError): iap.QueryPurchaseResult => {
          hilog.error(MemberStatusUtil.domainId, MemberStatusUtil.logTag,
            `autoRenew query failed. errCode=${error.code}, msg=${error.message}`);
          return emptyResult;
        });

    const nonRenewPromise =
      iap.queryPurchases(uiContext, nonRenewParam)
        .catch((error: BusinessError): iap.QueryPurchaseResult => {
          hilog.error(MemberStatusUtil.domainId, MemberStatusUtil.logTag,
            `nonRenew query failed. errCode=${error.code}, msg=${error.message}`
          );
          return emptyResult;
        });

    const nonConsumePromise =
      iap.queryPurchases(uiContext, nonConsumeParam)
        .catch((error: BusinessError): iap.QueryPurchaseResult => {
          hilog.error(MemberStatusUtil.domainId, MemberStatusUtil.logTag,
            `nonConsume query failed. errCode=${error.code}, msg=${error.message}`
          );
          return emptyResult;
        });

    return Promise.all([
      autoRenewPromise,
      nonRenewPromise,
      nonConsumePromise
    ]).then(res => {
      memberList.renewList = res[0]?.purchaseDataList ?? [];
      memberList.nonRenewList = res[1]?.purchaseDataList ?? [];
      memberList.nonConsumeList = res[2]?.purchaseDataList ?? [];
      return memberList;
    });
  }
}