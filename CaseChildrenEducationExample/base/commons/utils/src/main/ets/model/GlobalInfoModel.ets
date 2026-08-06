/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { RouterModule } from '../utils/RouterModule'

@ObservedV2
export class GlobalInfoModel {
  private static _instance: GlobalInfoModel;
  @Trace navStack: NavPathStack = RouterModule.getStack();

  public static get instance() {
    if (!GlobalInfoModel._instance) {
      GlobalInfoModel._instance = new GlobalInfoModel();
    }
    return GlobalInfoModel._instance;
  }
}
