import { describe, expect, it, Level } from '@ohos/hypium';
import nativeTest from 'libentry_test.so';

export default function SdlRenderSuite() {
  describe('SdlRenderSuite', () => {
    it('fills an RGBA32 surface and reads deterministic pixels', Level.LEVEL2, () => {
      const result = nativeTest.runRenderSuite();
      expect(result.failures).assertEqual(0);
      expect(result.message).assertEqual('');
      expect(result.assertions).assertLarger(0);
    });
  });
}
