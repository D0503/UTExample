import { describe, expect, it, Level } from "@package:pkg_modules/.ohpm/@ohos+hypium@1.0.25/pkg_modules/@ohos/hypium/index";
import nativeTest from "@app:com.thirdparty.validation.sdl2/entry_test/entry_test";
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
