import { describe, expect, it, Level } from "@package:pkg_modules/.ohpm/@ohos+hypium@1.0.25/pkg_modules/@ohos/hypium/index";
import tinyxml2Test from "@app:com.thirdparty.validation.tinyxml2/entry_test/entry_test";
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
