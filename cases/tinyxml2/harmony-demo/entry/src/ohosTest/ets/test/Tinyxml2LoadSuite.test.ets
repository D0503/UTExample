import { describe, expect, it, Level } from '@ohos/hypium';
import tinyxml2Test from 'libentry_test.so';

export default function Tinyxml2LoadSuite() {
  describe('Tinyxml2LoadSuite', () => {
    it('loads native library and exposes version 11.0.0', Level.LEVEL0, () => {
      const result = tinyxml2Test.runLoadSuite();
      expect(result.failures.join(',')).assertEqual('');
      expect(result.failed).assertEqual(0);
      expect(result.passed).assertEqual(2);
    });
  });
}
