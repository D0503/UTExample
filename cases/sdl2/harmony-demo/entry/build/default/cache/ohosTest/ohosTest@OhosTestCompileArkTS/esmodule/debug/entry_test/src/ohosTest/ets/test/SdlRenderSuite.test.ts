import { describe, expect, it, Level } from "@package:pkg_modules/.ohpm/@ohos+hypium@1.0.25/pkg_modules/@ohos/hypium/index";
import nativeTest from "@app:com.thirdparty.validation.sdl2/entry_test/entry_test";
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
