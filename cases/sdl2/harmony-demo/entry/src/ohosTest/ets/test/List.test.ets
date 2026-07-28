import SdlLoadSuite from './SdlLoadSuite.test';
import SdlRenderSuite from './SdlRenderSuite.test';
import SdlGuiStateSuite from './SdlGuiStateSuite.test';
import SdlPointerUiSuite from './SdlPointerUiSuite.test';
import SdlKeyboardUiSuite from './SdlKeyboardUiSuite.test';

export default function testsuite() {
  SdlLoadSuite();
  SdlRenderSuite();
  SdlGuiStateSuite();
  SdlPointerUiSuite();
  SdlKeyboardUiSuite();
}
