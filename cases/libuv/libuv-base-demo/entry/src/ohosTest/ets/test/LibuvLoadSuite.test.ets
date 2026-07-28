import { describe, expect, it, Level } from '@ohos/hypium';
import libuvTest, { NativeTestResult } from 'libentry_test.so';

export default function LibuvLoadSuite() {
  describe('LibuvLoadSuite', () => {
    it('loads native library and verifies libuv 1.50.0', Level.LEVEL0, () => {
      const result: NativeTestResult = libuvTest.runLoadSuite();
      expect(result.failures.join(',')).assertEqual('');
      expect(result.failed).assertEqual(0);
      expect(result.passed).assertEqual(4);
    });
  });
}
