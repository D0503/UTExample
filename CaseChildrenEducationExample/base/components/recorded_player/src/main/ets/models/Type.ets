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

export interface MoreItem {
  itemId: string;
  label: string;
  icon: Resource;
}

@ObservedV2
export class ReportItem {
  reason: string
  @Trace isSelected: boolean

  constructor(reason: string, isSelected: boolean) {
    this.reason = reason
    this.isSelected = isSelected
  }
}

@ObservedV2
export class MovieItem {
  movieId: string;
  @Trace movieTitle: string;
  movieUrl: string
  learnProgress: number = 0; // 进度
  constructor(movieId: string, movieTitle: string, learnProgress: number, movieUrl: string) {
    this.movieId = movieId
    this.movieTitle = movieTitle
    this.learnProgress = learnProgress
    this.movieUrl = movieUrl
  }
}
