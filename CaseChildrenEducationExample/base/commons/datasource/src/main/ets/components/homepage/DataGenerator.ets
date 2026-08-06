import { VideoCard, VideoCardDetail } from '../../model/Video';
import { common } from '@kit.AbilityKit';

export interface SelectedPageData {
  bannerArray: Array<string>,
  hobbyCategory: Array<VideoCard>,
  premiumVideoZero: Array<VideoCard>; // 0-3岁，精品互动视频
  premiumVideoThree: Array<VideoCard>; // 3-6岁，精品互动视频
  premiumVideoSix: Array<VideoCard>; // 6岁以上，精品互动视频
  hotAnimation: Array<VideoCard>; // 热门动画榜
  audioStory: Array<VideoCard>; //音频故事专区
  classicStory: Array<VideoCard>; //音频故事专区
}

export interface VideoCollection {
  videoCard: VideoCard,
  videoCardDetailList: Array<VideoCardDetail>
}

interface ChinesePageData {
  singStory: Array<VideoCard>; // 听故事 学叙事
  threeCharacter: Array<VideoCard>; // 三字经 磨耳朵
}

interface CartoonPageData {
  videoType1: Array<VideoCard> // 超级汽车
  videoType2: Array<VideoCard> // 多米
  videoType3: Array<VideoCard> // 趣味大百科
}

export class DataGenerator {
  /**
   * 精选列表首页
   */
  static getSelectedPageData(uiContext: UIContext): SelectedPageData {
    let context = uiContext.getHostContext() as common.UIAbilityContext;
    let cloudUrl = DataGenerator.getString(context, 'cloud_datastore')

    return {
      bannerArray: [
        cloudUrl +
          'v0/children-education-kqxc3/common%2Fhellorf_2238528999%E5%B0%8F.jpg?token=b01fd85a-053a-4653-8907-7393b07af849',
        cloudUrl + 'v0/children-education-kqxc3/common_1%2Fpicture_1.png?token=169b0e6a-f05a-486e-acff-5f9c5903e40e',
        cloudUrl + 'v0/children-education-kqxc3/common_1%2Fpicture_25.PNG?token=570b7734-aa1e-4243-a8ba-e91f18c4aba7',
        cloudUrl +
          'v0/children-education-kqxc3/common%2Fhellorf_2238528999%E5%B0%8F.jpg?token=b01fd85a-053a-4653-8907-7393b07af849',
        cloudUrl + 'v0/children-education-kqxc3/common_1%2Fpicture_1.png?token=169b0e6a-f05a-486e-acff-5f9c5903e40e',
        cloudUrl + 'v0/children-education-kqxc3/common_1%2Fpicture_25.PNG?token=570b7734-aa1e-4243-a8ba-e91f18c4aba7',
      ],
      hobbyCategory: [
        {
          id: '0001',
          title: '语数英',
          describe: '学习语数英',
          tags: [],
          updateCount: 30,
          videoType: 0,
          totalCount: 30,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common_1%2Fpicture_19.jpg?token=bcceb593-7c20-41b6-b63b-73f360a8f119',
          isVip: true,
        },
        {
          id: '0002',
          title: '听故事',
          describe: '开始听故事',
          tags: [],
          updateCount: 15,
          videoType: 0,
          totalCount: 15,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common_1%2Fpicture_24.PNG?token=cb66665b-0cd8-4b4a-8838-cec7ef7ae9f6',
          isVip: true,
        },
      ],
      premiumVideoZero: [
        {
          id: '0011',
          title: '零基础英语，26字母加200+高频单词',
          describe: '零基础英语，26字母加200+高频单词，零基础英语，26字母加200+高频单词',
          tags: ['0-3岁', '英语蒙1', '认知'],
          updateCount: 26,
          videoType: 0,
          totalCount: 26,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F314423795_huge%E5%B0%8F.jpg?token=b433d8fd-4c3d-452e-90d2-21d0598e7082',
          isVip: true,
        },
        {
          id: '0012',
          title: '零基础语文，拼音字母唐诗三百首',
          describe: '零基础语文，拼音字母唐诗三百首，零基础语文，拼音字母唐诗三百首',
          tags: ['0-3岁', '英语蒙2', '认知'],
          videoType: 0,
          updateCount: 26,
          totalCount: 26,
          imageUrl: cloudUrl + 'v0/children-education-kqxc3/common%2F78.png?token=9d2b52ff-c6de-4bb0-9e5d-edf5c53e09f1',
          isVip: true,
        },
        {
          id: '0013',
          title: '听Alex老师讲故事，轻松学习开心打卡200+高频词',
          describe: '',
          tags: ['0-3岁', '英语蒙3', '认知'],
          videoType: 0,
          updateCount: 26,
          totalCount: 26,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common_1%2Fpicture_30.jpg?token=e74e58df-c1fc-4c69-bdd2-cff3bf235ad9',
          isVip: true,
        },
        {
          id: '0014',
          title: '听Alex老师讲故事，轻松学习开心打卡300+高频词',
          describe: '',
          tags: ['0-3岁', '英语蒙3', '认知'],
          videoType: 0,
          updateCount: 26,
          totalCount: 26,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common_1%2Fpicture_30.jpg?token=e74e58df-c1fc-4c69-bdd2-cff3bf235ad9',
          isVip: true,
        },
        {
          id: '0015',
          title: '听Alex老师讲故事，轻松学习开心打卡400+高频词',
          describe: '',
          tags: ['0-3岁', '英语蒙3', '认知'],
          videoType: 0,
          updateCount: 26,
          totalCount: 26,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common_1%2Fpicture_30.jpg?token=e74e58df-c1fc-4c69-bdd2-cff3bf235ad9',
          isVip: true,
        },
        {
          id: '0016',
          title: '听Alex老师讲故事，轻松学习开心打卡500+高频词',
          describe: '',
          tags: ['0-3岁', '英语蒙3', '认知'],
          videoType: 0,
          updateCount: 26,
          totalCount: 26,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common_1%2Fpicture_30.jpg?token=e74e58df-c1fc-4c69-bdd2-cff3bf235ad9',
          isVip: true,
        },
        {
          id: '0017',
          title: '听Alex老师讲故事，轻松学习开心打卡600+高频词',
          describe: '',
          tags: ['0-3岁', '英语蒙3', '认知'],
          videoType: 0,
          updateCount: 26,
          totalCount: 26,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common_1%2Fpicture_30.jpg?token=e74e58df-c1fc-4c69-bdd2-cff3bf235ad9',
          isVip: true,
        },
        {
          id: '0018',
          title: '听Alex老师讲故事，轻松学习开心打卡700+高频词',
          describe: '',
          tags: ['0-3岁', '英语蒙3', '认知'],
          videoType: 0,
          updateCount: 26,
          totalCount: 26,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common_1%2Fpicture_30.jpg?token=e74e58df-c1fc-4c69-bdd2-cff3bf235ad9',
          isVip: true,
        },
        {
          id: '0019',
          title: '听Alex老师讲故事，轻松学习开心打卡800+高频词',
          describe: '',
          tags: ['0-3岁', '英语蒙3', '认知'],
          videoType: 0,
          updateCount: 26,
          totalCount: 26,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common_1%2Fpicture_30.jpg?token=e74e58df-c1fc-4c69-bdd2-cff3bf235ad9',
          isVip: true,
        },
      ],
      premiumVideoThree: [
        {
          id: '0001',
          title: '3-6岁，26字母加200高频词',
          describe: '',
          tags: ['3-6岁', '英语启蒙', '认知'],
          videoType: 0,
          updateCount: 51,
          totalCount: 52,
          imageUrl: cloudUrl + 'v0/children-education-kqxc3/common%2F12.png?token=9ea099ec-8907-4e49-bc23-7f6d82cf026b',
          isVip: true,
        },
        {
          id: '0001',
          title: '跟Alex老师唱儿歌、3-6岁',
          describe: '',
          tags: ['3-6岁', '英语启蒙', '认知'],
          videoType: 0,
          updateCount: 51,
          totalCount: 52,
          imageUrl: cloudUrl + 'v0/children-education-kqxc3/common%2F12.png?token=9ea099ec-8907-4e49-bc23-7f6d82cf026b',
          isVip: true,
        },
        {
          id: '0001',
          title: '3-6岁，趣味互动练习',
          describe: '',
          tags: ['3-6岁', '英语启蒙', '认知'],
          videoType: 0,
          updateCount: 51,
          totalCount: 52,
          imageUrl: cloudUrl + 'v0/children-education-kqxc3/common%2F12.png?token=9ea099ec-8907-4e49-bc23-7f6d82cf026b',
          isVip: true,
        },
      ],
      premiumVideoSix: [
        {
          id: '0001',
          title: '6岁以上，26字母加200高频词',
          describe: '',
          tags: ['6岁以上', '英语启蒙', '认知'],
          videoType: 0,
          updateCount: 51,
          totalCount: 52,
          imageUrl: cloudUrl + 'v0/children-education-kqxc3/common%2F12.png?token=9ea099ec-8907-4e49-bc23-7f6d82cf026b',
          isVip: true,
        },
        {
          id: '0001',
          title: '跟Alex老师唱儿歌、6岁以上',
          describe: '',
          tags: ['6岁以上', '英语启蒙', '认知'],
          videoType: 0,
          updateCount: 51,
          totalCount: 52,
          imageUrl: cloudUrl + 'v0/children-education-kqxc3/common%2F12.png?token=9ea099ec-8907-4e49-bc23-7f6d82cf026b',
          isVip: true,
        },
        {
          id: '0001',
          title: '6岁以上，趣味互动练习',
          describe: '',
          tags: ['6岁以上', '英语启蒙', '认知'],
          videoType: 0,
          updateCount: 51,
          totalCount: 52,
          imageUrl: cloudUrl + 'v0/children-education-kqxc3/common%2F12.png?token=9ea099ec-8907-4e49-bc23-7f6d82cf026b',
          isVip: true,
        },
      ],
      hotAnimation: [
        {
          id: '0006',
          title: '超级汽车第四季',
          describe: '超级汽车，守护正义和美好',
          tags: [],
          videoType: 0,
          updateCount: 50,
          totalCount: 52,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2Fhellorf_2239162006.jpg?token=cbaaca3d-e3b7-4005-8c27-36fa87224b86',
          isVip: true,
        },
        {
          id: '0007',
          title: '神奇恐龙世界',
          describe: '探索神秘的恐龙世界',
          tags: [],
          videoType: 0,
          updateCount: 47,
          totalCount: 52,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2Fshutterstock_679276597_1024.jpg?token=4ab020b1-b2ed-476f-aa63-e3398d3264d9',
          isVip: false,
        },
        {
          id: '0008',
          title: '宝贝多米益智乐园第二季',
          describe: '多米与朋友们的精彩生活',
          tags: [],
          videoType: 0,
          updateCount: 36,
          totalCount: 52,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common_1%2Fpicture_1.png?token=169b0e6a-f05a-486e-acff-5f9c5903e40e',
          isVip: false,
        },
        {
          id: '0009',
          title: '海洋世界',
          describe: '探索神秘的恐龙世界',
          tags: [],
          videoType: 0,
          updateCount: 43,
          totalCount: 52,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common_1%2Fpicture_11.jpg?token=13019971-43ce-4659-a56b-07f8b73ecd70',
          isVip: true,
        },
      ],
      audioStory: [
        {
          id: 'audioStory00001',
          title: '神秘海洋探索记',
          describe: '深海寻宝，利用海洋知识破解谜案',
          tags: [],
          videoType: 1,
          updateCount: 144,
          totalCount: 144,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F%E7%9F%A9%E5%BD%A2%203416(15).png?token=f4457e7c-5a6b-4662-9681-57d5c90b2ecb',
          isVip: true,
        },
        {
          id: 'audioStory00002',
          title: '百科知识大全',
          describe: '深海寻宝，利用海洋知识破解谜案',
          tags: [],
          videoType: 1,
          updateCount: 26,
          totalCount: 26,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F%E7%9F%A9%E5%BD%A2%203416(12).png?token=49764103-5df1-4659-b517-5f3ed06c17fc',
          isVip: true,
        },
        {
          id: 'audioStory00003',
          title: '天空飞翔记',
          describe: '深海寻宝，利用海洋知识破解谜案',
          tags: [],
          videoType: 1,
          updateCount: 166,
          totalCount: 166,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common_1%2Fpicture_14.PNG?token=02e2ec85-e6de-47c3-972e-a34a2dd78794',
          isVip: true,
        },
        {
          id: 'audioStory00004',
          title: '神秘海洋探索记',
          describe: '深海寻宝，利用海洋知识破解谜案',
          tags: [],
          videoType: 1,
          updateCount: 144,
          totalCount: 144,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F%E7%9F%A9%E5%BD%A2%203416(15).png?token=f4457e7c-5a6b-4662-9681-57d5c90b2ecb',
          isVip: true,
        },
        {
          id: 'audioStory00005',
          title: '百科知识大全',
          describe: '深海寻宝，利用海洋知识破解谜案',
          tags: [],
          videoType: 1,
          updateCount: 26,
          totalCount: 26,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F%E7%9F%A9%E5%BD%A2%203416(12).png?token=49764103-5df1-4659-b517-5f3ed06c17fc',
          isVip: true,
        }
      ],
      classicStory: [
        {
          id: '00013',
          title: '小羊肖恩',
          describe: '',
          tags: [],
          videoType: 0,
          updateCount: 144,
          totalCount: 144,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F%E7%9F%A9%E5%BD%A2%203416(1).png?token=4cfcead3-d195-4053-ac94-f4385532719a',
          isVip: false,
        },
        {
          id: '00014',
          title: '巧克力工厂',
          describe: '',
          tags: [],
          videoType: 0,
          updateCount: 144,
          totalCount: 144,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F%E7%9F%A9%E5%BD%A2%203416(4).png?token=e01b46fa-2f57-4462-b533-1aa4d7143124',
          isVip: true,
        },
        {
          id: '00015',
          title: '卖火柴的小女孩',
          describe: '',
          tags: [],
          videoType: 0,
          updateCount: 144,
          totalCount: 144,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common_1%2Fpicture_31.jpg?token=52f9c394-6b0e-4d7a-b0a2-6f374e80210d',
          isVip: false,
        },
        {
          id: '00016',
          title: '童话公主',
          describe: '',
          tags: [],
          videoType: 0,
          updateCount: 144,
          totalCount: 144,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F%E7%9F%A9%E5%BD%A2%203416(9).png?token=1e36d825-8fee-4ba2-8301-3484fa2f934d',
          isVip: true,
        }]
    }
  }

  /**
   * 精品互动视频-更多
   */
  static getPremiumInteractiveVideoData(uiContext: UIContext): Array<VideoCard> {
    let context = uiContext.getHostContext() as common.UIAbilityContext;
    let cloudUrl = DataGenerator.getString(context, 'cloud_datastore')
    return [
      {
        id: '00017',
        title: '零基础英语，26字母加200高频词',
        describe: '',
        tags: ['3-8岁', '英语启蒙', '认知'],
        videoType: 0,
        updateCount: 26,
        totalCount: 26,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2F314423795_huge%E5%B0%8F.jpg?token=b433d8fd-4c3d-452e-90d2-21d0598e7082',
        isVip: true,
      },
      {
        id: '00018',
        title: '跟Alex老师唱儿歌、学英语',
        describe: '',
        tags: ['3-8岁', '英语启蒙', '认知'],
        videoType: 0,
        updateCount: 26,
        totalCount: 26,
        imageUrl: cloudUrl + 'v0/children-education-kqxc3/common%2F78.png?token=9d2b52ff-c6de-4bb0-9e5d-edf5c53e09f1',
        isVip: true,
      },
      {
        id: '00019',
        title: '象形演绎汉字，趣味互动练习',
        describe: '',
        tags: ['3-8岁', '英语启蒙', '认知'],
        videoType: 0,
        updateCount: 26,
        totalCount: 26,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common_1%2Fpicture_30.jpg?token=e74e58df-c1fc-4c69-bdd2-cff3bf235ad9',
        isVip: true,
      },
      {
        id: '00020',
        title: '零基础英语，26字母加200高频词',
        describe: '',
        tags: ['3-8岁', '英语启蒙', '认知'],
        videoType: 0,
        updateCount: 26,
        totalCount: 26,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common_1%2Fpicture_29.jpg?token=1555687a-611d-4ef4-88cb-9ce43fa2f442',
        isVip: true,
      },
      {
        id: '00021',
        title: '跟Alex老师唱儿歌、学英语',
        describe: '',
        tags: ['3-8岁', '英语启蒙', '认知'],
        videoType: 0,
        updateCount: 26,
        totalCount: 26,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common_1%2Fpicture_6.jpg?token=e28a06c5-1bdb-46d1-906e-36efa6d02b20',
        isVip: true,
      },
      {
        id: '00022',
        title: '象形演绎汉字，趣味互动练习',
        describe: '',
        tags: ['3-8岁', '英语启蒙', '认知'],
        videoType: 0,
        updateCount: 26,
        totalCount: 26,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common_1%2Fpicture_21.jpg?token=a5fa49c6-f4d0-4d0e-a7ff-1624e0984937',
        isVip: true,
      },
    ];
  }

  /**
   * 热门动画榜-更多
   */
  static getHotAnimationData(context: common.UIAbilityContext): Array<VideoCard> {
    // let context = uiContext.getHostContext() as common.UIAbilityContext;
    let cloudUrl = DataGenerator.getString(context, 'cloud_datastore')
    return [
      {
        id: '00023',
        title: '超级汽车第四季',
        describe: '超级汽车，守护正义和美好',
        tags: ['变身', '救援', '勇敢正义'],
        videoType: 0,
        updateCount: 50,
        totalCount: 52,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2Fhellorf_2239162006.jpg?token=cbaaca3d-e3b7-4005-8c27-36fa87224b86',
        isVip: true,
      },
      {
        id: '00024',
        title: '宝贝多米益智乐园第二季',
        describe: '益智大闯关，启蒙认知趣味多',
        tags: ['数字', '颜色形状'],
        videoType: 0,
        updateCount: 47,
        totalCount: 52,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2Fshutterstock_679276597_1024.jpg?token=4ab020b1-b2ed-476f-aa63-e3398d3264d9',
        isVip: true,
      },
      {
        id: '00025',
        title: '宝贝多米第三季',
        describe: '多米与朋友们的精彩生活',
        tags: ['日常生活', '习惯培养'],
        videoType: 0,
        updateCount: 36,
        totalCount: 52,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2Fshutterstock_679276597_1024.jpg?token=4ab020b1-b2ed-476f-aa63-e3398d3264d9',
        isVip: true,
      },
      {
        id: '00026',
        title: '贝乐虎之超级警长',
        describe: '超级警长推理破案打击罪犯',
        tags: ['逻辑', '破解谜题', '抓捕坏人'],
        videoType: 0,
        updateCount: 10,
        totalCount: 52,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2F%E7%9F%A9%E5%BD%A2%203416(28).png?token=2845fb27-f45d-4c05-8d75-3f19494d88bb',
        isVip: true,
      },
      {
        id: '00027',
        title: '超级汽车第四季',
        describe: '超级汽车，守护正义和美好',
        tags: ['变身', '救援', '勇敢正义'],
        videoType: 0,
        updateCount: 50,
        totalCount: 52,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2F%E7%9F%A9%E5%BD%A2%203416(28).png?token=2845fb27-f45d-4c05-8d75-3f19494d88bb',
        isVip: true,
      },
      {
        id: '00028',
        title: '宝贝多米益智乐园第二季',
        describe: '益智大闯关，启蒙认知趣味多',
        tags: ['数字', '颜色形状'],
        videoType: 0,
        updateCount: 47,
        totalCount: 52,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2Fhellorf_2239162006.jpg?token=cbaaca3d-e3b7-4005-8c27-36fa87224b86',
        isVip: true,
      },
      {
        id: '00029',
        title: '宝贝多米第三季',
        describe: '多米与朋友们的精彩生活',
        tags: ['日常生活', '习惯培养'],
        videoType: 0,
        updateCount: 36,
        totalCount: 52,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2Fhellorf_2239162006.jpg?token=cbaaca3d-e3b7-4005-8c27-36fa87224b86',
        isVip: true,
      },
      {
        id: '00030',
        title: '贝乐虎之超级警长',
        describe: '超级警长推理破案打击罪犯',
        tags: ['逻辑', '破解谜题', '抓捕坏人'],
        videoType: 0,
        updateCount: 6,
        totalCount: 52,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2Fhellorf_2239162006.jpg?token=cbaaca3d-e3b7-4005-8c27-36fa87224b86',
        isVip: true,
      },
    ];
  }

  /**
   * 音频故事专区-更多
   */
  static getAudioListData(uiContext: UIContext): Array<VideoCard> {
    let context = uiContext.getHostContext() as common.UIAbilityContext;
    let cloudUrl = DataGenerator.getString(context, 'cloud_datastore')
    return [
      {
        id: '00031',
        title: '神秘海洋探索记',
        describe: '深海寻宝，利用海洋知识破解谜案，走进海洋世界',
        tags: [],
        videoType: 1,
        updateCount: 50,
        totalCount: 52,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2F%E7%9F%A9%E5%BD%A2%203416(15).png?token=f4457e7c-5a6b-4662-9681-57d5c90b2ecb',
        isVip: true,
      },
      {
        id: '00032',
        title: '百科知识大全',
        describe: '深海寻宝，利用海洋知识破解谜案',
        tags: [],
        videoType: 1,
        updateCount: 50,
        totalCount: 52,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2F%E7%9F%A9%E5%BD%A2%203416(12).png?token=49764103-5df1-4659-b517-5f3ed06c17fc',
        isVip: true,
      },
      {
        id: '00033',
        title: '神秘海洋探索记',
        describe: '深海寻宝，利用海洋知识破解谜案，走进海洋世界，接触海洋生物',
        tags: [],
        videoType: 1,
        updateCount: 49,
        totalCount: 52,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2F%E7%9F%A9%E5%BD%A2%203416(15).png?token=f4457e7c-5a6b-4662-9681-57d5c90b2ecb',
        isVip: true,
      },
      {
        id: '00034',
        title: '百科知识大全',
        describe: '深海寻宝，利用海洋知识破解谜案',
        tags: [],
        videoType: 1,
        updateCount: 49,
        totalCount: 52,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2F%E7%9F%A9%E5%BD%A2%203416(12).png?token=49764103-5df1-4659-b517-5f3ed06c17fc',
        isVip: true,
      },
      {
        id: '00035',
        title: '神秘海洋探索记',
        describe: '深海寻宝，利用海洋知识破解谜案，走进海洋世界，接触海洋生物',
        tags: [],
        videoType: 1,
        updateCount: 49,
        totalCount: 52,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2F%E7%9F%A9%E5%BD%A2%203416(12).png?token=49764103-5df1-4659-b517-5f3ed06c17fc',
        isVip: true,
      },
    ];
  }

  /**
   * 视频播放详情
   */
  static getVideoDetail(uiContext: UIContext): VideoCollection {
    let context = uiContext.getHostContext() as common.UIAbilityContext;
    let cloudUrl = DataGenerator.getString(context, 'cloud_datastore')
    let videoUrl = DataGenerator.getString(context, 'videoUrlOne')
    let videoUrlTwo = DataGenerator.getString(context, 'videoUrlTwo')
    return {
      videoCard: {
        id: '00041',
        title: '',
        describe: '',
        tags: [],
        videoType: 0,
        updateCount: 49,
        totalCount: 52,
        imageUrl: '',
        isVip: true,
      },
      videoCardDetailList: [
        {
          id: '00042',
          cardId: '1003',
          title: '风沙中的对决',
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F1756539491_huge.png?token=451028ba-72e5-4a8d-a4af-0aa54e5a761a',
          videoNumber: 1,
          iconUrl: 'app.media.icon_free',
          videoUrl: videoUrl,
          isVip: false,
        },
        {
          id: '00043',
          cardId: '1004',
          title: '拯救外星人',
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F1962349429_huge.jpg?token=1c514f1c-438b-4c8e-b947-29a0c15f2d15',
          videoNumber: 2,
          iconUrl: 'app.media.icon_free',
          videoUrl: videoUrlTwo,
          isVip: true,
        },
        {
          id: '00044',
          cardId: '1005',
          title: '保护深林',
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common_1%2Fpicture_2.jpg?token=a7eab61d-9fad-4016-95d0-89cbb5e07f55',
          videoNumber: 3,
          iconUrl: 'app.media.icon_free',
          videoUrl: videoUrl,
          isVip: true,
        },
        {
          id: '00045',
          cardId: '1006',
          title: '守护正义',
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2Fshutterstock_679276597_1024.jpg?token=4ab020b1-b2ed-476f-aa63-e3398d3264d9',
          videoNumber: 4,
          iconUrl: 'app.media.icon_free',
          videoUrl: videoUrlTwo,
          isVip: true,
        },
        {
          id: '00046',
          cardId: '1007',
          title: '爱护地球',
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F1857579025_huge%E5%B0%8F.jpg?token=3d1d30c3-eed1-48fa-892e-ec5955ff3805',
          videoNumber: 5,
          iconUrl: 'app.media.icon_free',
          videoUrl: videoUrl,
          isVip: true,
        },
        {
          id: '00047',
          cardId: '1008',
          title: '呵护动物',
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2Fhellorf_hi2240694863%E5%B0%8F.jpg?token=e48ed2d4-abcb-4ce2-913e-f3d99b7a4c59',
          videoNumber: 6,
          iconUrl: 'app.media.icon_free',
          videoUrl: videoUrlTwo,
          isVip: true,
        },
        {
          id: '00048',
          cardId: '1009',
          title: '爱护大海',
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2Fshutterstock_1682700667_1024.jpg?token=8abbee46-9b9a-40a7-bc40-fe766bce1137',
          videoNumber: 7,
          iconUrl: 'app.media.icon_free',
          videoUrl: videoUrl,
          isVip: true,
        },
        {
          id: '00049',
          cardId: '1010',
          title: '守卫蓝天',
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F202101101300434.JPG?token=11b8eb4e-c92e-48a0-9be5-84e22d4582bd',
          videoNumber: 8,
          iconUrl: 'app.media.icon_free',
          videoUrl: videoUrl,
          isVip: true,
        },
      ],
    };
  }

  /**
   * 音频播放详情
   */
  static getAudioDetail(uiContext: UIContext): VideoCollection {
    let context = uiContext.getHostContext() as common.UIAbilityContext;
    let cloudUrl = DataGenerator.getString(context, 'cloud_datastore')
    let audioUrl = DataGenerator.getString(context, 'audioUrl')
    return {
      videoCard: {
        id: '00050',
        title: '',
        describe: '',
        tags: [],
        videoType: 1,
        updateCount: 49,
        totalCount: 52,
        imageUrl: '',
        isVip: false,
      },
      videoCardDetailList: [
        {
          id: '00051',
          cardId: '1011',
          title: '加入寻宝小队-去深海探案寻宝吧!',
          imageUrl: cloudUrl + 'v0/children-education-kqxc3/common%2F78.png?token=9d2b52ff-c6de-4bb0-9e5d-edf5c53e09f1',
          videoNumber: 1,
          iconUrl: 'app.media.icon_free',
          videoUrl: audioUrl,
          isVip: false,
        },
        {
          id: '00052',
          cardId: '1012',
          title: '海底1米-爸爸妈妈变成了椰子树(1)',
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F314423795_huge%E5%B0%8F.jpg?token=b433d8fd-4c3d-452e-90d2-21d0598e7082',
          videoNumber: 2,
          iconUrl: 'app.media.icon_free',
          videoUrl: audioUrl,
          isVip: false,
        },
        {
          id: '00053',
          cardId: '1013',
          title: '海底2米-爸爸妈妈变成了椰子树(2)',
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F2188020413_huge.jpg?token=a22ab9b3-978e-46a4-bded-1c52069e1e78',
          videoNumber: 3,
          iconUrl: 'app.media.icon_free',
          videoUrl: audioUrl,
          isVip: false,
        },
        {
          id: '00054',
          cardId: '1014',
          title: '海底3米-爸爸妈妈变成了椰子树(3)',
          imageUrl: cloudUrl + 'v0/children-education-kqxc3/common%2F10.png?token=8bb5bb72-6844-4086-8693-ff95f425a00b',
          videoNumber: 4,
          iconUrl: 'app.media.icon_free',
          videoUrl: audioUrl,
          isVip: true,
        },
        {
          id: '00055',
          cardId: '1001',
          title: '海底1米-鲨鱼王子登场(1)',
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F1962349429_huge.jpg?token=1c514f1c-438b-4c8e-b947-29a0c15f2d15',
          videoNumber: 5,
          iconUrl: 'app.media.icon_free',
          videoUrl: audioUrl,
          isVip: true,
        },
        {
          id: '00056',
          cardId: '1002',
          title: '海底2米-鲨鱼王子登场(2)',
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F%E7%9F%A9%E5%BD%A2%203416(4).png?token=e01b46fa-2f57-4462-b533-1aa4d7143124',
          videoNumber: 6,
          iconUrl: 'app.media.icon_free',
          videoUrl: audioUrl,
          isVip: true,
        },
        {
          id: '0001',
          cardId: '0001',
          title: '海底3米-鲨鱼王子登场(3)',
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F%E7%9F%A9%E5%BD%A2%203416(28).png?token=2845fb27-f45d-4c05-8d75-3f19494d88bb',
          videoNumber: 7,
          iconUrl: 'app.media.icon_free',
          videoUrl: audioUrl,
          isVip: true,
        },
        {
          id: '0001',
          cardId: '0001',
          title: '海底4米-鲨鱼王子登场(4)',
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2Fshutterstock_679276597_1024.jpg?token=4ab020b1-b2ed-476f-aa63-e3398d3264d9',
          videoNumber: 8,
          iconUrl: 'app.media.icon_free',
          videoUrl: audioUrl,
          isVip: true,
        },
        {
          id: '0001',
          cardId: '0001',
          title: '海底5米-鲨鱼王子登场(5)',
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2Fshutterstock_1682700667_1024.jpg?token=8abbee46-9b9a-40a7-bc40-fe766bce1137',
          videoNumber: 9,
          iconUrl: 'app.media.icon_free',
          videoUrl: audioUrl,
          isVip: true,
        },
        {
          id: '0001',
          cardId: '0001',
          title: '海底6米-鲨鱼王子登场(6)',
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F202101101300434.JPG?token=11b8eb4e-c92e-48a0-9be5-84e22d4582bd',
          videoNumber: 10,
          iconUrl: 'app.media.icon_free',
          videoUrl: audioUrl,
          isVip: true,
        },
        {
          id: '0001',
          cardId: '0001',
          title: '海底7米-鲨鱼王子登场(7)',
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F2188020413_huge.jpg?token=a22ab9b3-978e-46a4-bded-1c52069e1e78',
          videoNumber: 11,
          iconUrl: 'app.media.icon_free',
          videoUrl: audioUrl,
          isVip: true,
        }
        ,
        {
          id: '0001',
          cardId: '0001',
          title: '海底8米-鲨鱼王子登场(8)',
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F2212620027_huge.jpg?token=aa98ddce-aaed-4d2f-87b4-a82e4386074a',
          videoNumber: 12,
          iconUrl: 'app.media.icon_free',
          videoUrl: audioUrl,
          isVip: true,
        },
      ],
    };
  }

  /**
   * 看动画
   */
  static getEnglishChildrenSongsData(uiContext: UIContext): Array<VideoCard> {
    let context = uiContext.getHostContext() as common.UIAbilityContext;
    let cloudUrl = DataGenerator.getString(context, 'cloud_datastore')
    return [
      {
        id: '1',
        title: 'Do Re Mi',
        describe: '',
        tags: [],
        videoType: 0,
        updateCount: 33,
        totalCount: 33,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2Fshutterstock_1682700667_1024.jpg?token=8abbee46-9b9a-40a7-bc40-fe766bce1137',
        isVip: true
      },
      {
        id: '2',
        title: 'The Muffin Man',
        describe: '',
        tags: [],
        videoType: 0,
        updateCount: 22,
        totalCount: 32,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2Fshutterstock_1682700667_1024.jpg?token=8abbee46-9b9a-40a7-bc40-fe766bce1137',
        isVip: true
      },
      {
        id: '3',
        title: 'Mary Had a Little Little Little Little',
        describe: '',
        tags: [],
        videoType: 0,
        updateCount: 31,
        totalCount: 41,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2Fshutterstock_1682700667_1024.jpg?token=8abbee46-9b9a-40a7-bc40-fe766bce1137',
        isVip: true
      },
      {
        id: '4',
        title: 'Five Little Ducks',
        describe: '',
        tags: [],
        videoType: 0,
        updateCount: 8,
        totalCount: 13,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common_1%2Fpicture_21.jpg?token=a5fa49c6-f4d0-4d0e-a7ff-1624e0984937',
        isVip: true
      },
      {
        id: '5',
        title: 'Do Te Mi',
        describe: '',
        tags: [],
        videoType: 0,
        updateCount: 6,
        totalCount: 17,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2Fshutterstock_1682700667_1024.jpg?token=8abbee46-9b9a-40a7-bc40-fe766bce1137',
        isVip: true
      },
      {
        id: '6',
        title: 'The Huff Man',
        describe: '',
        tags: [],
        videoType: 0,
        updateCount: 48,
        totalCount: 52,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2Fshutterstock_1682700667_1024.jpg?token=8abbee46-9b9a-40a7-bc40-fe766bce1137',
        isVip: true
      },
      {
        id: '7',
        title: 'Twinkle Little Star',
        describe: '',
        tags: [],
        videoType: 0,
        updateCount: 48,
        totalCount: 52,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common_1%2Fpicture_10.jpg?token=9834f1af-5cd3-4e69-a217-5f2e7037eef7',
        isVip: true
      },
      {
        id: '8',
        title: 'The Wheels',
        describe: '',
        tags: [],
        videoType: 0,
        updateCount: 9,
        totalCount: 51,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common_1%2Fpicture_29.jpg?token=1555687a-611d-4ef4-88cb-9ce43fa2f442',
        isVip: true
      },
      {
        id: '9',
        title: 'Mary Had a Little Little',
        describe: '',
        tags: [],
        videoType: 0,
        updateCount: 10,
        totalCount: 36,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common_1%2Fpicture_12.jpg?token=cb732777-2b34-44f5-bfb2-771d4a3a0dfc',
        isVip: true
      },
      {
        id: '10',
        title: 'Five Little Bird',
        describe: '',
        tags: [],
        videoType: 0,
        updateCount: 11,
        totalCount: 11,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2Fshutterstock_1682700667_1024.jpg?token=8abbee46-9b9a-40a7-bc40-fe766bce1137',
        isVip: true
      }
    ]
  }

  /**
   * 汉语启蒙首页
   */
  static getChinesePageData(uiContext: UIContext): ChinesePageData {
    let context = uiContext.getHostContext() as common.UIAbilityContext;
    let cloudUrl = DataGenerator.getString(context, 'cloud_datastore')
    return {
      singStory: [
        {
          id: 'singStory-01',
          title: '世界名人故事',
          describe: '儿歌 经典音乐视频',
          tags: ['3-6岁', '人文表达'],
          plateType: '互动',
          videoType: 0,
          updateCount: 47,
          totalCount: 52,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F1756539491_huge.png?token=451028ba-72e5-4a8d-a4af-0aa54e5a761a',
          isVip: false,
        },
        {
          id: 'singStory-02',
          title: '听Alex老师讲故事，轻松学习200+高频词',
          describe: '互动视频',
          tags: ['3-6岁', '高频词汇'],
          videoType: 0,
          plateType: '互动',
          updateCount: 47,
          totalCount: 52,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F1756539491_huge.png?token=451028ba-72e5-4a8d-a4af-0aa54e5a761a',
          isVip: true,
        },
        {
          id: 'singStory-03',
          title: '听Alex老师讲故事，轻松学习200+高频词',
          describe: '互动视频',
          tags: ['3-6岁', '高频词汇'],
          videoType: 0,
          plateType: '互动',
          updateCount: 47,
          totalCount: 52,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F1756539491_huge.png?token=451028ba-72e5-4a8d-a4af-0aa54e5a761a',
          isVip: true,
        },
        {
          id: 'singStory-04',
          title: '听Alex老师讲故事，轻松学习200+高频词',
          describe: '互动视频',
          tags: ['3-6岁', '高频词汇'],
          videoType: 0,
          plateType: '互动',
          updateCount: 47,
          totalCount: 52,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F1756539491_huge.png?token=451028ba-72e5-4a8d-a4af-0aa54e5a761a',
          isVip: true,
        },
        {
          id: 'singStory-05',
          title: '听Alex老师讲故事，轻松学习200+高频词',
          describe: '互动视频',
          tags: ['3-6岁', '高频词汇'],
          videoType: 0,
          plateType: '互动',
          updateCount: 47,
          totalCount: 52,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F1756539491_huge.png?token=451028ba-72e5-4a8d-a4af-0aa54e5a761a',
          isVip: true,
        },
        {
          id: 'singStory-06',
          title: '听Alex老师讲故事，轻松学习200+高频词',
          describe: '互动视频',
          tags: ['3-6岁', '高频词汇'],
          videoType: 0,
          plateType: '互动',
          updateCount: 47,
          totalCount: 52,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F1756539491_huge.png?token=451028ba-72e5-4a8d-a4af-0aa54e5a761a',
          isVip: true,
        }
      ],
      threeCharacter: [
        {
          id: '',
          title: '人之初 性本善',
          describe: '',
          tags: ['儿歌', '儿童', '音乐'],
          videoType: 0,
          updateCount: 47,
          totalCount: 52,
          plateType: '视频',
          imageUrl: cloudUrl + 'v0/children-education-kqxc3/common%2F9.png?token=9bb42244-316a-4a34-873e-5e918bb95d53',
          isVip: true,

        },
        {
          id: '',
          title: '昔孟母 择邻处',
          describe: '',
          tags: ['儿歌', '儿童', '音乐'],
          videoType: 0,
          plateType: '视频',
          updateCount: 47,
          totalCount: 52,
          imageUrl: cloudUrl + 'v0/children-education-kqxc3/common%2F9.png?token=9bb42244-316a-4a34-873e-5e918bb95d53',
          isVip: true,
        },
        {
          id: '',
          title: '养不教 父之过',
          describe: '',
          tags: ['儿歌', '儿童', '音乐'],
          videoType: 0,
          plateType: '视频',
          updateCount: 47,
          totalCount: 52,
          imageUrl: cloudUrl + 'v0/children-education-kqxc3/common%2F9.png?token=9bb42244-316a-4a34-873e-5e918bb95d53',
          isVip: true,
        },
        {
          id: '',
          title: '玉不琢 不成器',
          describe: '',
          tags: ['儿歌', '儿童', '音乐'],
          videoType: 0,
          plateType: '视频',
          updateCount: 47,
          totalCount: 52,
          imageUrl: cloudUrl + 'v0/children-education-kqxc3/common%2F9.png?token=9bb42244-316a-4a34-873e-5e918bb95d53',
          isVip: true,
        },
      ],
    }
  }

  /**
   * 儿歌首页
   */
  static getSingSongPageData(uiContext: UIContext): Array<VideoCard> {
    let context = uiContext.getHostContext() as common.UIAbilityContext;
    let cloudUrl = DataGenerator.getString(context, 'cloud_datastore')
    return [{
      id: '',
      title: '两只老虎',
      describe: '',
      tags: ['儿歌', '儿童', '音乐'],
      videoType: 0,
      updateCount: 46,
      totalCount: 52,
      imageUrl: cloudUrl + 'v0/children-education-kqxc3/common%2F5.png?token=53ef30f8-c649-4765-9c89-49ad9360a19d',
      isVip: true,
    },
      {
        id: '',
        title: '宝贝多米',
        describe: '',
        tags: ['儿歌', '儿童', '音乐'],
        videoType: 0,
        updateCount: 46,
        totalCount: 52,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2Fshutterstock_1682700667_1024.jpg?token=8abbee46-9b9a-40a7-bc40-fe766bce1137',
        isVip: true,
      },
      {
        id: '',
        title: '好宝宝',
        describe: '',
        tags: ['儿歌', '儿童', '音乐'],
        videoType: 0,
        updateCount: 46,
        totalCount: 52,
        imageUrl: cloudUrl +
          'v0/children-education-kqxc3/common%2Fshutterstock_1682700667_1024.jpg?token=8abbee46-9b9a-40a7-bc40-fe766bce1137',
        isVip: true,
      },
      {
        id: '',
        title: '春天在哪里',
        describe: '',
        tags: ['儿歌', '儿童', '音乐'],
        videoType: 0,
        updateCount: 46,
        totalCount: 52,
        imageUrl: cloudUrl + 'v0/children-education-kqxc3/common%2F5.png?token=53ef30f8-c649-4765-9c89-49ad9360a19d',
        isVip: true,
      },
    ]
  }

  /**
   * 看动画
   */
  static getCartoonPageData(uiContext: UIContext): CartoonPageData {
    let context = uiContext.getHostContext() as common.UIAbilityContext;
    let cloudUrl = DataGenerator.getString(context, 'cloud_datastore')
    return {
      videoType1: [
        {
          id: '',
          title: '超级汽车第三季',
          describe: '超级汽车，守护正义与美好',
          tags: ['变身', '救援', '勇敢正义'],
          videoType: 0,
          updateCount: 46,
          totalCount: 52,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2Fhellorf_2239162006.jpg?token=cbaaca3d-e3b7-4005-8c27-36fa87224b86',
          isVip: true,
        },
        {
          id: '',
          title: '超级汽车第四季',
          describe: '超级汽车，守护正义与美好',
          tags: ['变身', '救援', '勇敢正义'],
          videoType: 0,
          updateCount: 46,
          totalCount: 52,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2Fhellorf_2239162006.jpg?token=cbaaca3d-e3b7-4005-8c27-36fa87224b86',
          isVip: true,
        }
      ],
      videoType2: [
        {
          id: '',
          title: '宝贝多米益智乐园第一季',
          describe: '多米与朋友们的精彩生活',
          plateType: '动画',
          tags: ['童趣', '快乐成长'],
          videoType: 0,
          updateCount: 46,
          totalCount: 52,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F%E7%9F%A9%E5%BD%A2%203416(27).png?token=25b8be8c-b6b8-453b-9be1-da347fb07619',
          isVip: true,
        },
        {
          id: '',
          title: '宝贝多米益智乐园第二季',
          describe: '多米与朋友们的精彩生活',
          plateType: '动画',
          tags: ['童趣', '快乐成长'],
          videoType: 0,
          updateCount: 46,
          totalCount: 52,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F%E7%9F%A9%E5%BD%A2%203416(27).png?token=25b8be8c-b6b8-453b-9be1-da347fb07619',
          isVip: true,
        },
        {
          id: '',
          title: '宝贝多米益智乐园第三季',
          describe: '多米与朋友们的精彩生活',
          plateType: '动画',
          tags: ['童趣', '快乐成长'],
          videoType: 0,
          updateCount: 46,
          totalCount: 52,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F%E7%9F%A9%E5%BD%A2%203416(27).png?token=25b8be8c-b6b8-453b-9be1-da347fb07619',
          isVip: true,
        }
      ],
      videoType3: [
        {
          id: '',
          title: '长城的作用是什么',
          describe: '',
          tags: [],
          videoType: 0,
          updateCount: 46,
          totalCount: 52,
          imageUrl: cloudUrl + 'v0/children-education-kqxc3/common%2F1.png?token=4a55b1ab-f0bf-46fa-a438-a2a4bb670a36',
          isVip: true,
        },
        {
          id: '',
          title: '珍珠是从哪儿来的',
          describe: '',
          tags: [],
          videoType: 0,
          updateCount: 47,
          totalCount: 52,
          imageUrl: cloudUrl + 'v0/children-education-kqxc3/common%2F6.png?token=d99b20a6-472a-497e-8296-8686e77a8074',
          isVip: true,
        },
        {
          id: '',
          title: '恐龙的诞生',
          describe: '',
          tags: [],
          videoType: 0,
          updateCount: 36,
          totalCount: 52,
          imageUrl: cloudUrl +
            'v0/children-education-kqxc3/common%2F%E7%9F%A9%E5%BD%A2%203416(3).png?token=e82cbb3d-0e46-4ed2-957e-4a7e3c8b440f',
          isVip: true,
        },
        {
          id: '',
          title: '宇航员的日常',
          describe: '',
          tags: [],
          videoType: 0,
          updateCount: 10,
          totalCount: 52,
          imageUrl: cloudUrl + 'v0/children-education-kqxc3/common%2F7.png?token=b08b5509-18b6-4902-881a-006f3cdc35c9',
          isVip: true,
        },
      ]
    }
  }


  private static getString(context: common.UIAbilityContext, key: string): string {
    try {
      return context.resourceManager.getStringByNameSync(key)
    } catch (error) {
      return ''
    }
  }
}