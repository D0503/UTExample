@ObservedV2
export class User {
  @Trace isLogin: boolean = false;
  @Trace userName: string = '点击登录';
  @Trace fullName: string = '';
  @Trace userAvatar: string = '';
  @Trace phone: string = '';
  @Trace gender: number = 0;
  @Trace birthDate: string = '';
  @Trace introDesc: string = '';
}