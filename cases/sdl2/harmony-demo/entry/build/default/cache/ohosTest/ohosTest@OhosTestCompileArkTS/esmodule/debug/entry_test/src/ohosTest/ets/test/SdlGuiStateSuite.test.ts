import { describe, expect, it } from "@package:pkg_modules/.ohpm/@ohos+hypium@1.0.25/pkg_modules/@ohos/hypium/index";
import entryTest from "@app:com.thirdparty.validation.sdl2/entry_test/entry_test";
import type { SuiteResult } from "@app:com.thirdparty.validation.sdl2/entry_test/entry_test";
export default function SdlGuiStateSuite(): void {
    describe('SdlGuiStateSuite', () => {
        it('tracks deterministic native GUI state', 0, () => {
            const result: SuiteResult = entryTest.runGuiStateSuite();
            expect(result.failures).assertEqual(0);
            expect(result.assertions).assertLarger(10);
        });
    });
}
