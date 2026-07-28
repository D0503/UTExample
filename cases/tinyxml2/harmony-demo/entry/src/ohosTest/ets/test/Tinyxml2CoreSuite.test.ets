import { describe, expect, it, Level } from '@ohos/hypium';
import tinyxml2Test from 'libentry_test.so';

export default function Tinyxml2CoreSuite() {
  describe('Tinyxml2CoreSuite', () => {
    it('executes representative XML operations and error paths', Level.LEVEL0, () => {
      const result = tinyxml2Test.runCoreSuite();
      expect(result.failures.join(',')).assertEqual('');
      expect(result.failed).assertEqual(0);
      expect(result.passed).assertEqual(6);
    });
  });
}
