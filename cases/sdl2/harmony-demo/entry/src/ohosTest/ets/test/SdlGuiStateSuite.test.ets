import { describe, expect, it } from '@ohos/hypium';
import entryTest, { SuiteResult } from 'libentry_test.so';

export default function SdlGuiStateSuite(): void {
  describe('SdlGuiStateSuite', () => {
    it('tracks deterministic native GUI state', 0, () => {
      const result: SuiteResult = entryTest.runGuiStateSuite();
      expect(result.failures).assertEqual(0);
      expect(result.assertions).assertLarger(10);
    });
  });
}
