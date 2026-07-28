/*
 * Callback surface expected by the OpenHarmony SDL2 port. The validation
 * demo does not request orientation, permission, IME or custom-cursor APIs.
 */
export function setTitle(_title: string): void {}
export function setWindowStyle(_fullscreen: boolean): void {}
export function setOrientation(_width: number, _height: number,
  _resizable: number, _hint: string): void {}
export function shouldMinimizeOnFocusLoss(): boolean { return false; }
export function showTextInput(_x: number, _y: number, _width: number, _height: number): void {}
export function hideTextInput(): void {}
export function requestPermission(_permission: string): void {}
export function setPointer(_cursorId: number): void {}
