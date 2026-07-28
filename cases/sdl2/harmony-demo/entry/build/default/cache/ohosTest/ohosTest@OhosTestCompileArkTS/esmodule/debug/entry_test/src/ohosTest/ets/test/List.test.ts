import SdlLoadSuite from "@bundle:com.thirdparty.validation.sdl2/entry_test/ets/test/SdlLoadSuite.test";
import SdlRenderSuite from "@bundle:com.thirdparty.validation.sdl2/entry_test/ets/test/SdlRenderSuite.test";
import SdlGuiStateSuite from "@bundle:com.thirdparty.validation.sdl2/entry_test/ets/test/SdlGuiStateSuite.test";
import SdlPointerUiSuite from "@bundle:com.thirdparty.validation.sdl2/entry_test/ets/test/SdlPointerUiSuite.test";
import SdlKeyboardUiSuite from "@bundle:com.thirdparty.validation.sdl2/entry_test/ets/test/SdlKeyboardUiSuite.test";
export default function testsuite() {
    SdlLoadSuite();
    SdlRenderSuite();
    SdlGuiStateSuite();
    SdlPointerUiSuite();
    SdlKeyboardUiSuite();
}
