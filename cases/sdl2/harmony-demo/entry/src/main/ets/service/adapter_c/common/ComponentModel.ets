/*
 * Derived from the OpenHarmony SDL2 port at commit
 * 77fc66603a1ddfafca45daf6367824a10ff05562 (Apache-2.0).
 */
import { Callback } from '@ohos.base';

export class XComponentModel {
  id: string;
  type: XComponentType = XComponentType.SURFACE;
  libraryname: string;
  focusable: boolean = true;
  onLoad: Callback<object> = (_event?: object) => {};
  onDestroy: () => void = () => {};
  controller: XComponentController | null = null;

  constructor(id: string, type: XComponentType, libraryname: string) {
    this.id = id;
    this.type = type;
    this.libraryname = libraryname;
  }
}
