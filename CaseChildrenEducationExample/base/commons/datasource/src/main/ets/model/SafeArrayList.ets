
export class SafeArrayList<T> {
  private list: Array<T>;
  
  constructor(list: T[]) {
    this.list = list
  }

  forEach(cb: (item: T, index: number) => void) {
    try {
      this.list.forEach(cb);
    } catch (e) {
      console.error('forEach failed', e);
    }
  }

  add(item: T) {
    try {
      this.list.push(item);
    } catch (e) {
      console.error('add failed', e);
    }
  }

  removeByIndex(index: number) {
    try {
      if (index >= 0 && index < this.list.length) {
        this.list.splice(index, 1);
      }
    } catch (e) {
      console.error('remove failed', e);
    }
  }

  getCapacity(): number {
    try {
      return this.list.length;
    } catch {
      return 0;
    }
  }

  getRaw() {
    return this.list;
  }
}
