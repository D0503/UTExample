import { describe, expect, it, Level } from '@ohos/hypium';
import libuvTest, { NativeTestResult } from 'libentry_test.so';

export default function LibuvAffinitySuite() {
  describe('LibuvAffinitySuite', () => {
    it('reads, sets, verifies, and restores an allowed CPU', Level.LEVEL0, () => {
      const result: NativeTestResult = libuvTest.runAffinitySuite();
      expect(result.failures.join(',')).assertEqual('');
      expect(result.failed).assertEqual(0);
      expect(result.passed).assertEqual(6);
    });
  });
}
