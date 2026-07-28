import { describe, expect, it, Level } from '@ohos/hypium';
import nativeTest from 'libentry_test.so';

export default function SdlLoadSuite() {
  describe('SdlLoadSuite', () => {
    it('loads SDL2 2.0.12 and initializes the core', Level.LEVEL1, () => {
      const result = nativeTest.runLoadSuite();
      expect(result.failures).assertEqual(0);
      expect(result.message).assertEqual('');
      expect(result.assertions).assertLarger(0);
    });
  });
}
