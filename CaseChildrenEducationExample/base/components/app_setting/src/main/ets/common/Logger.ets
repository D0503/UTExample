import { hilog } from '@kit.PerformanceAnalysisKit';

/**
 * 日志打印类
 */
export class Logger {
  private static format: string = '%{public}s, %{public}s';
  private static domainId: number = 0xff00;
  private static prefixId: string = 'AppSetting';

  public static info(...args: string[]): void {
    hilog.info(Logger.domainId, Logger.prefixId, Logger.format, args);
  }

  public static error(...args: string[]): void {
    hilog.error(Logger.domainId, Logger.prefixId, Logger.format, args);
  }

  public static warn(...args: string[]): void {
    hilog.warn(Logger.domainId, Logger.prefixId, Logger.format, args);
  }


  public static debug(...args: string[]): void {
    hilog.debug(Logger.domainId, Logger.prefixId, Logger.format, args);
  }
}
