import {
  AvoidArea,
  CommonConstants,
  DialogUtils,
  GlobalContext,
  GlobalInfoModel,
  rightArrow,
  StringUtil
} from '@ohos_agcit/children_education_utils';
import { emitter } from '@kit.BasicServicesKit';
import { AppStorageV2 } from '@kit.ArkUI';

@Builder
export function TimeCtrlBuilder() {
  TimeCtrl();
}

@ComponentV2
export struct TimeCtrl {
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  @Local lunchEndTime: string = CommonConstants.EMPTY_STRING;
  @Local nightStartTime: string = CommonConstants.EMPTY_STRING;
  @Local nightEndTime: string = CommonConstants.EMPTY_STRING;
  @Local timeLimit: string = CommonConstants.EMPTY_STRING;
  @Local lunchStartTime: string = CommonConstants.EMPTY_STRING;
  @Local lunchTimeState: boolean = false;
  @Local nightTimeState: boolean = false;
  private timeArray: Resource = $r('app.strarray.time_array');
  private selectTime: Date = new Date()
  @Local globalInfo: GlobalInfoModel =
    AppStorageV2.connect<GlobalInfoModel>(GlobalInfoModel, () => new GlobalInfoModel())!;

  build() {
    NavDestination() {
      Column() {
        Scroll() {
          Column({ space: 12 }) {
            textTitleBuilder('每日播放');
            Row() {
              textCommonBuilder('每日使用时长');
              Blank();
              Text(this.timeLimit)
                .fontSize(14)
                .fontFamily('鸿蒙黑体')
                .fontWeight(FontWeight.Regular)
                .opacity(0.6)
                .padding({
                  right: '3%',
                });
              rightArrow();
            }
            .alignItems(VerticalAlign.Center)
            .backgroundColor($r('sys.color.comp_background_list_card'))
            .borderRadius(16)
            .rowExtend(12, 14)
            .height(56)
            .onClick(() => {
              DialogUtils.textPickerDialog(this.getUIContext(), this.timeArray, (sexValue: string) => {
                this.timeLimit = sexValue;
              });
            });

            textTitleBuilder('禁止观看时间');
            Column() {
              Row() {
                textCommonBuilder('晚间休息');
                Blank();
                Toggle({ type: ToggleType.Switch, isOn: this.nightTimeState })
                  .selectedColor($r('sys.color.comp_background_emphasize'))
                  .switchPointColor($r('sys.color.comp_background_list_card'))
                  .onChange((nightIsOn: boolean) => {
                    this.nightTimeState = nightIsOn;
                    let startTimeIsNull = StringUtil.isEmpty(this.nightStartTime);
                    let endTimeIsNull = StringUtil.isEmpty(this.nightEndTime);
                    let b = startTimeIsNull || endTimeIsNull;
                    if (nightIsOn && b) {
                      //自定义吐司
                      DialogUtils.showToast('请选择开始和结束时间', {
                        fontColor: Color.Black,
                        backgroundColor: '#99e3dcdc',
                        duration: 1500,
                        alignment: Alignment.Center,
                      });
                    }
                  });
              }
              .rowExtend(12, 12);

              divider();

              Row() {
                textCommonBuilder('开始时间');
                Blank();
                Text(this.nightStartTime).padding({ right: 4 });
                rightArrow()
              }
              .rowExtend(12, 12)
              .onClick(() => {
                this.getUIContext().showTimePickerDialog({
                  selected: this.selectTime,
                  useMilitaryTime: true,
                  disappearTextStyle: { color: Color.Black, font: { size: 14, weight: 400 } },
                  textStyle: { color: Color.Black, font: { size: 16, weight: 400 } },
                  selectedTextStyle: { color: Color.Black, font: { size: 20, weight: 500 } },
                  acceptButtonStyle: { fontColor: Color.Black, fontSize: 16, fontWeight: 500 },
                  cancelButtonStyle: { fontColor: Color.Black, fontSize: 16, fontWeight: 500 },
                  onAccept: (value: TimePickerResult) => {
                    this.nightStartTime = this.getMinuteValue(value.hour) + ':' + this.getMinuteValue(value.minute);
                  }
                })
              });

              divider();

              Row() {
                textCommonBuilder('结束时间');
                Blank();
                Text(this.nightEndTime).padding({ right: 4 });
                rightArrow()
              }
              .rowExtend(12, 12)
              .onClick(() => {
                this.getUIContext().showTimePickerDialog({
                  selected: this.selectTime,
                  useMilitaryTime: true,
                  disappearTextStyle: { color: Color.Black, font: { size: 14, weight: 400 } },
                  textStyle: { color: Color.Black, font: { size: 16, weight: 400 } },
                  selectedTextStyle: { color: Color.Black, font: { size: 20, weight: 500 } },
                  acceptButtonStyle: { fontColor: Color.Black, fontSize: 16, fontWeight: 500 },
                  cancelButtonStyle: { fontColor: Color.Black, fontSize: 16, fontWeight: 500 },
                  onAccept: (value: TimePickerResult) => {
                    this.nightEndTime = this.getMinuteValue(value.hour) + ':' + this.getMinuteValue(value.minute);
                  }
                })
              });
            }
            .columnExtend();

            Column() {
              Row() {
                textCommonBuilder('午间休息');
                Blank();
                Toggle({ type: ToggleType.Switch, isOn: this.lunchTimeState })
                  .selectedColor($r('sys.color.comp_background_emphasize'))
                  .switchPointColor($r('sys.color.comp_background_list_card'))
                  .onChange((lunchIsOn: boolean) => {
                    this.lunchTimeState = lunchIsOn;
                    let startTimeIsNull = StringUtil.isEmpty(this.lunchStartTime);
                    let endTimeIsNull = StringUtil.isEmpty(this.lunchEndTime);
                    let b = startTimeIsNull || endTimeIsNull;
                    if (lunchIsOn && b) {
                      //自定义吐司
                      DialogUtils.showToast('请选择开始和结束时间', {
                        fontColor: Color.Black,
                        backgroundColor: '#99e3dcdc',
                        duration: 1500,
                        alignment: Alignment.Center,
                      });
                    }
                  });
              }
              .rowExtend(12, 12)

              divider();

              Row() {
                textCommonBuilder('开始时间');
                Blank();
                Text(this.lunchStartTime).padding({ right: 4 });
                rightArrow()
              }
              .rowExtend(12, 12)
              .onClick(() => {
                this.getUIContext().showTimePickerDialog({
                  selected: this.selectTime,
                  useMilitaryTime: true,
                  disappearTextStyle: { color: Color.Black, font: { size: 14, weight: 400 } },
                  textStyle: { color: Color.Black, font: { size: 16, weight: 400 } },
                  selectedTextStyle: { color: Color.Black, font: { size: 20, weight: 500 } },
                  acceptButtonStyle: { fontColor: Color.Black, fontSize: 16, fontWeight: 500 },
                  cancelButtonStyle: { fontColor: Color.Black, fontSize: 16, fontWeight: 500 },
                  onAccept: (value: TimePickerResult) => {
                    this.lunchStartTime = this.getMinuteValue(value.hour) + ':' + this.getMinuteValue(value.minute);
                  }
                })
              });

              divider();

              Row() {
                textCommonBuilder('结束时间');
                Blank();
                Text(this.lunchEndTime).padding({ right: 4 });
                rightArrow()
              }
              .rowExtend(12, 12)
              .onClick(() => {
                this.getUIContext().showTimePickerDialog({
                  selected: this.selectTime,
                  useMilitaryTime: true,
                  disappearTextStyle: { color: Color.Black, font: { size: 14, weight: 400 } },
                  textStyle: { color: Color.Black, font: { size: 16, weight: 400 } },
                  selectedTextStyle: { color: Color.Black, font: { size: 20, weight: 500 } },
                  acceptButtonStyle: { fontColor: Color.Black, fontSize: 16, fontWeight: 500 },
                  cancelButtonStyle: { fontColor: Color.Black, fontSize: 16, fontWeight: 500 },
                  onAccept: (value: TimePickerResult) => {
                    this.lunchEndTime = this.getMinuteValue(value.hour) + ':' + this.getMinuteValue(value.minute);
                  }
                })
              });
            }
            .columnExtend();

            Row() {
              Button('保存')
                .width(CommonConstants.FULL_PERCENT)
                .backgroundColor('#FFD15D')
                .fontColor($r('sys.color.font_primary'))
                .fontSize($r('sys.float.Body_L'))
                .onClick(() => {
                  GlobalContext.getContext().setObject(CommonConstants.LUNCH_TIME_STATE, this.lunchTimeState);
                  GlobalContext.getContext().setObject(CommonConstants.NIGHT_TIME_STATE, this.nightTimeState);
                  if (this.lunchTimeState) {
                    GlobalContext.getContext().setObject(CommonConstants.LUNCH_START_TIME, this.lunchStartTime);
                    GlobalContext.getContext().setObject(CommonConstants.LUNCH_END_TIME, this.lunchEndTime);
                  }
                  if (this.nightTimeState) {
                    GlobalContext.getContext().setObject(CommonConstants.NIGHT_START_TIME, this.nightStartTime);
                    GlobalContext.getContext().setObject(CommonConstants.NIGHT_END_TIME, this.nightEndTime);
                  }
                  GlobalContext.getContext().setObject(CommonConstants.TIME_LIMIT, this.timeLimit);

                  let convertValue = converTimeLimit(this.timeLimit);
                  let timeControl: emitter.EventData = {
                    data: {
                      'timeLimit': convertValue,
                      'lunchTimeState': this.lunchTimeState,
                      'nightTimeState': this.nightTimeState,
                      'lunchStartTime': this.lunchStartTime,
                      'lunchEndTime': this.lunchEndTime,
                      'nightStartTime': this.nightStartTime,
                      'nightEndTime': this.nightEndTime,
                    },
                  };
                  emitter.emit(CommonConstants.TIME_CONTROL, timeControl);

                  DialogUtils.showToast('保存成功', {
                    fontColor: Color.Black,
                    backgroundColor: '#99e3dcdc',
                    duration: 1500,
                    alignment: Alignment.Center,
                    uiContext: this.getUIContext()
                  });
                });
            }.padding({ top: 170, bottom: 70 });
          }
          .padding({ right: 16, left: 16 })
          .backgroundColor('#F1F3F5')
        }
      }
      .height('100%')
      .backgroundColor('#F1F3F5')
    }
    .onShown(() => {
      const lunchState = GlobalContext.getContext().getObject(CommonConstants.LUNCH_TIME_STATE) as boolean;
      const nightState = GlobalContext.getContext().getObject(CommonConstants.NIGHT_TIME_STATE) as boolean;
      const lunchStartTime = GlobalContext.getContext().getObject(CommonConstants.LUNCH_START_TIME) as string;
      const lunchEndTime = GlobalContext.getContext().getObject(CommonConstants.LUNCH_END_TIME) as string;
      const nightStartTime = GlobalContext.getContext().getObject(CommonConstants.NIGHT_START_TIME) as string;
      const nightEndTime = GlobalContext.getContext().getObject(CommonConstants.NIGHT_END_TIME) as string;
      const timeLimit = GlobalContext.getContext().getObject(CommonConstants.TIME_LIMIT) as string;
      this.timeLimit = timeLimit || this.timeLimit;
      this.lunchStartTime = lunchStartTime || this.lunchStartTime;
      this.lunchEndTime = lunchEndTime || this.lunchEndTime;
      this.nightStartTime = nightStartTime || this.nightStartTime;
      this.nightEndTime = nightEndTime || this.nightEndTime;
      this.lunchTimeState = lunchState === undefined?this.lunchTimeState:lunchState ;
      this.nightTimeState = nightState === undefined?this.nightTimeState: nightState;
    })
    .margin({
      top: this.getUIContext().px2vp(this.avoidArea.topRectHeight),
    })
    .title('时长控制')
    .onBackPressed(() => {
      this.globalInfo.navStack.pop();
      return true;
    });
  }

  getMinuteValue(minute: number): string {
    if (minute < 10) {
      return '0' + minute;
    }
    return '' + minute;
  }
}

@Builder
function divider() {
  Divider().width('85%').alignSelf(ItemAlign.Center);
}

@Builder
function textCommonBuilder(text: ResourceStr) {
  Text(text)
    .fontSize(16)
    .fontFamily('鸿蒙黑体')
    .fontWeight(FontWeight.Medium)
    .opacity(0.9);
}

@Builder
function textTitleBuilder(text: ResourceStr) {
  Text(text)
    .fontSize(14)
    .fontFamily('鸿蒙黑体')
    .fontWeight(FontWeight.Regular)
    .opacity(0.6)
    .width(CommonConstants.FULL_PERCENT)
    .padding({ left: 12, top: 16 });
}

@Extend(Column)
function columnExtend() {
  .backgroundColor($r('sys.color.white')).borderRadius(16).height(152).justifyContent(FlexAlign.SpaceEvenly);
}

@Extend(Row)
function rowExtend(left: number, right: number) {
  .width(CommonConstants.FULL_PERCENT).padding({ left: left, right: right });
}


function converTimeLimit(timeLimit: string): number {
  if (timeLimit.endsWith('分钟')) {
    return Number(timeLimit.replace('分钟', ''));
  } else if (timeLimit.endsWith('小时')) {
    return Number(timeLimit.replace('小时', '')) * 60;
  } else {
    return 1440;
  }
}
