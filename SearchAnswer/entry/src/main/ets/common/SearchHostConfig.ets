let shallowWindowParam: boolean = false;

export function setShallowWindowParam(enabled: boolean): void {
  shallowWindowParam = enabled;
}

export function getShallowWindowParam(): boolean {
  return shallowWindowParam;
}
