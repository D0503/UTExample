import { Want } from '@kit.AbilityKit';
import { abilityDelegatorRegistry, Component, Driver, ON, Rect } from '@kit.TestKit';

const BUSINESS_BUNDLE_NAME: string = 'com.thirdparty.validation.sdl2';
const BUSINESS_ABILITY_NAME: string = 'EntryAbility';
const COMPONENT_TIMEOUT_MS: number = 15000;
const STATE_POLL_INTERVAL_MS: number = 100;
let sharedDriver: Driver | undefined = undefined;
let businessAbilityStarted: boolean = false;

export interface NativeGuiState {
  frames: number;
  buttonClicks: number;
  slider: number;
  keyboardEvents: number;
  lastKeyCode: number;
}

export interface GuiTestSession {
  driver: Driver;
  surface: Component;
}

function parseNumberField(status: string, name: string): number {
  const fields: string[] = status.split(';');
  const prefix: string = `${name}=`;
  for (let index: number = 0; index < fields.length; index++) {
    if (fields[index].startsWith(prefix)) {
      const value: number = Number(fields[index].substring(prefix.length));
      if (!Number.isNaN(value)) {
        return value;
      }
    }
  }
  throw new Error(`nativeStatus does not contain a numeric ${name} field: ${status}`);
}

export function parseNativeGuiState(status: string): NativeGuiState {
  return {
    frames: parseNumberField(status, 'frames'),
    buttonClicks: parseNumberField(status, 'buttonClicks'),
    slider: parseNumberField(status, 'slider'),
    keyboardEvents: parseNumberField(status, 'keyboardEvents'),
    lastKeyCode: parseNumberField(status, 'lastKeyCode')
  };
}

export function getDriver(): Driver {
  if (sharedDriver === undefined) {
    sharedDriver = Driver.create();
  }
  if (!sharedDriver) {
    throw new Error('UiTest Driver.create returned null in suite beforeAll');
  }
  return sharedDriver;
}

export async function startGuiTestSession(driver: Driver): Promise<GuiTestSession> {
  const delegator = abilityDelegatorRegistry.getAbilityDelegator();
  if (!driver) {
    throw new Error(
      'UiTest driver is unavailable; initialize Driver.create() once in the suite beforeAll'
    );
  }
  const want: Want = {
    bundleName: BUSINESS_BUNDLE_NAME,
    abilityName: BUSINESS_ABILITY_NAME
  };
  if (!businessAbilityStarted) {
    await delegator.startAbility(want);
    businessAbilityStarted = true;
  }

  const surface: Component = await driver.waitForComponent(ON.id('sdlSurface'), COMPONENT_TIMEOUT_MS);
  if (!surface) {
    throw new Error(`sdlSurface was not reachable within ${COMPONENT_TIMEOUT_MS} ms`);
  }

  const ready: Component = await driver.waitForComponent(ON.id('renderReady'), COMPONENT_TIMEOUT_MS);
  if (!ready) {
    throw new Error(`renderReady was not reachable within ${COMPONENT_TIMEOUT_MS} ms`);
  }
  const deadline: number = Date.now() + COMPONENT_TIMEOUT_MS;
  while (Date.now() < deadline) {
    if ((await ready.getText()) === 'true') {
      return { driver, surface };
    }
    await driver.delayMs(STATE_POLL_INTERVAL_MS);
  }
  throw new Error(`renderReady did not become true within ${COMPONENT_TIMEOUT_MS} ms`);
}

export async function readNativeGuiState(driver: Driver): Promise<NativeGuiState> {
  const status: Component = await driver.waitForComponent(ON.id('nativeStatus'), COMPONENT_TIMEOUT_MS);
  if (!status) {
    throw new Error(`nativeStatus was not reachable within ${COMPONENT_TIMEOUT_MS} ms`);
  }
  return parseNativeGuiState(await status.getText());
}

export async function waitForNativeGuiState(
  driver: Driver,
  predicate: (state: NativeGuiState) => boolean,
  description: string,
  timeoutMs: number = COMPONENT_TIMEOUT_MS
): Promise<NativeGuiState> {
  const deadline: number = Date.now() + timeoutMs;
  let lastState: NativeGuiState = await readNativeGuiState(driver);
  while (Date.now() < deadline) {
    lastState = await readNativeGuiState(driver);
    if (predicate(lastState)) {
      return lastState;
    }
    await driver.delayMs(STATE_POLL_INTERVAL_MS);
  }
  throw new Error(
    `${description}; last state: frames=${lastState.frames};buttonClicks=${lastState.buttonClicks};` +
    `slider=${lastState.slider};keyboardEvents=${lastState.keyboardEvents};lastKeyCode=${lastState.lastKeyCode}`
  );
}

export function pointInBounds(bounds: Rect, xRatio: number, yRatio: number): number[] {
  const x: number = Math.round(bounds.left + (bounds.right - bounds.left) * xRatio);
  const y: number = Math.round(bounds.top + (bounds.bottom - bounds.top) * yRatio);
  return [x, y];
}

export async function captureGuiEvidence(driver: Driver, fileName: string): Promise<string> {
  const filesDir: string = abilityDelegatorRegistry.getAbilityDelegator().getAppContext().filesDir;
  const path: string = `${filesDir}/${fileName}`;
  const captured: boolean = await driver.screenCap(path);
  if (!captured) {
    throw new Error(`UiTest screenCap failed: ${path}`);
  }
  return path;
}
