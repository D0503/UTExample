import { deviceInfo } from '@kit.BasicServicesKit';
import { display } from '@kit.ArkUI';

export class DeviceUtil {
  public static isPhone(): boolean {
    return deviceInfo.deviceType === 'phone'
  }

  public static isPortrait(): boolean {
    let orientation = display.getDefaultDisplaySync().orientation
    return orientation === 0 || orientation === 2
  }

  public static isLandSpace(): boolean {
    let orientation = display.getDefaultDisplaySync().orientation
    return orientation === 1 || orientation === 3
  }
}
