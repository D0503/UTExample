import { describe, expect, it, Level } from '@ohos/hypium';
import libuvTest, { NativeTestResult } from 'libentry_test.so';

export default function LibuvCoreSuite() {
  describe('LibuvCoreSuite', () => {
    it('runs timer, work queue, and thread checks', Level.LEVEL0, () => {
      const result: NativeTestResult = libuvTest.runCoreSuite();
      expect(result.failures.join(',')).assertEqual('');
      expect(result.failed).assertEqual(0);
      expect(result.passed).assertEqual(4);
    });
  });
}
