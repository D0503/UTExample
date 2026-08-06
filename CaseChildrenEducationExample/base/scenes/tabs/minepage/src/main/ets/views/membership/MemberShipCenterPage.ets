import { AvoidArea, CommonConstants, DateConstants, DateUtil } from '@ohos_agcit/children_education_utils';
import { iap } from '@kit.IAPKit';
import {
  FinishStatus,
  MemberList,
  MemberParams,
  MemberShipPage,
  PRIVACY_CONTENT,
  PRODUCTS_INFO
} from 'membership';
import { emitter } from '@kit.BasicServicesKit';
import { VipRecord } from '@ohos_agcit/children_education_datasource';
import { AppStorageV2 } from '@kit.ArkUI';

@Builder
export function MemberShipBuilder() {
  MemberShipCenterPage();
}

@ComponentV2
export struct MemberShipCenterPage {
  @Consumer(CommonConstants.APP_PATH_STACK) navPathStack: NavPathStack = new NavPathStack();
  @Consumer(CommonConstants.VIP_RECORD) vipRecord: VipRecord = new VipRecord();
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  // 购买会员商品结果回调函数
  subscribeEvent = async (params: MemberParams): Promise<void> => {
    this.getUIContext().getPromptAction().showToast({ message: this.getSubscribeMsg(params) });
    if (params.type === iap.ProductType.NONRENEWABLE && params.status === FinishStatus.FINISHED) {
      // mock计算商品到期时间
      let today = DateUtil.getTodayStr(DateConstants.DATE_FORMAT4);
      let validDate = '';
      if (params.productId === '20254') {
        validDate = DateUtil.getAmountDayStr(today, 365, DateConstants.DATE_FORMAT4);
      } else if (params.productId === '20253') {
        validDate = DateUtil.getAmountDayStr(today, 92, DateConstants.DATE_FORMAT4);
      } else {
        validDate = DateUtil.getAmountDayStr(today, 31, DateConstants.DATE_FORMAT4);
      }

      emitter.emit(CommonConstants.VIP_RECORD, {
        data: {
          'isVip': true,
          'validTime': validDate,
        },
      });
    }
  };
  // 查询用户开通的会员种类列表，沙盒场景下，已发货状态的非消耗型商品订单信息不返回
  ownedMemberEvent = async (list: MemberList): Promise<void> => {
    if (list.renewList.length || list.nonRenewList.length) {
      this.getUIContext().getPromptAction().showToast({ message: `您已拥有会员` });
    }
  };
  // 购买非周期订阅商品后从开发者服务器查询商品到期时间
  queryExpireTime = (productId: string, time?: number, validTime?: string): Promise<void> => {
    // 请求开发者服务器获取非周期订阅商品到期时间（涉及商品id、购买次数）
    return new Promise(() => {
      if (validTime !== undefined) {
        this.vipRecord.validTime = validTime
      }
    });
  };

  getSubscribeMsg(param: MemberParams) {
    let message = '';
    if (param.status === FinishStatus.FINISHED) {
      message = '会员订阅成功';
    } else if (param.status === FinishStatus.UNFINISHED) {
      message = `会员订阅失败，订阅错误码为${param.errCode}，错误原因为${param.errMsg}`;
    }
    return message;
  }

  build() {
    NavDestination() {
      MemberShipPage({
        isSheet: false,
        routerModule: this.navPathStack,
        themeColor: $r('app.color.color_member'),
        btnFontColor: $r('sys.color.font_primary'),
        linearColors: [['#FFFFFF', 0.0], ['#F5F1E5', 0.0], ['#F1D1A5', 1.0]],
        lastPurchaseProductExpireTime: this.vipRecord.validTime,
        privacyContent: PRIVACY_CONTENT,
        subscribeCallBack: this.subscribeEvent,
        queryExpireTime: this.queryExpireTime,
        ownedMemberCallBack: this.ownedMemberEvent,
        productsInfo: PRODUCTS_INFO,
      })
    }
    .hideTitleBar(true)
    .onReady((ctx) => {
      this.navPathStack = ctx.pathStack;
    })
    .onBackPressed(() => {
      this.navPathStack.pop();
      return true;
    })
  }
}


