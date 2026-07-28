import { describe, expect, it, Level } from "@package:pkg_modules/.ohpm/@ohos+hypium@1.0.25/pkg_modules/@ohos/hypium/index";
import libuvTest from "@app:com.thirdparty.validation.libuv.golden/entry_test/entry_test";
import type { NativeTestResult } from "@app:com.thirdparty.validation.libuv.golden/entry_test/entry_test";
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
