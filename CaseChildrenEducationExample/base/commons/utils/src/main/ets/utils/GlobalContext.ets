/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { PreferencesUtil } from './PreferencesUtil'
export class GlobalContext {
  public  context:Context | null = null;
  private constructor() {
  }

  private static instance: GlobalContext;
  private _objects = new Map<string, Object>();

  public static getContext(): GlobalContext {
    if (!GlobalContext.instance) {
      GlobalContext.instance = new GlobalContext();
    }
    return GlobalContext.instance;
  }

  getObject(value: string): Object | undefined {
    const preferencesUtil = PreferencesUtil.getInstance();
    const preference = preferencesUtil.getPreferences(this.context as Context)
    return preferencesUtil.getPreferencesValue(preference, value) || undefined;
  }

  setObject(key: string, objectClass: Object): void {
    const preferencesUtil = PreferencesUtil.getInstance();
    const preference = preferencesUtil.getPreferences(this.context as Context)
    preferencesUtil.preferencesPut(preference, key, objectClass)
  }

  /**
   * 将数据存入缓存中
   */
  public put(key: string, value: Object): void {
    const preferencesUtil = PreferencesUtil.getInstance();
    const preference = preferencesUtil.getPreferences(this.context as Context)
    preferencesUtil.preferencesPut(preference, key, value)
  }

  /**
   * 获取缓存中的数据
   */
  public get<T>(key: string): T {
    const preferencesUtil = PreferencesUtil.getInstance();
    const preference = preferencesUtil.getPreferences(this.context as Context)
    return preferencesUtil.getPreferencesValue(preference, key) as T;
  }


  /**
   * 缓存中的数据是否存在
   */
  public has(key: string): boolean {
    const preferencesUtil = PreferencesUtil.getInstance();
    const preference = preferencesUtil.getPreferences(this.context as Context)
    return preferencesUtil.hasPreferencesKey(preference, key);
  }


  /**
   * 移除缓存
   */
  public remove(key: string) {
    const preferencesUtil = PreferencesUtil.getInstance();
    const preference = preferencesUtil.getPreferences(this.context as Context)
    return preferencesUtil.deletePreferencesByKey(preference, key);    // this._objects.delete(key);
  }

  /**
   * 清除缓存数据
   */
  public clear() {
    const preferencesUtil = PreferencesUtil.getInstance();
    return preferencesUtil.removePreferencesFromCache(this.context as Context)
  }
}