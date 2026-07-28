import LibuvLoadSuite from "@bundle:com.thirdparty.validation.libuv.golden/entry_test/ets/test/LibuvLoadSuite.test";
import LibuvCoreSuite from "@bundle:com.thirdparty.validation.libuv.golden/entry_test/ets/test/LibuvCoreSuite.test";
import LibuvAffinitySuite from "@bundle:com.thirdparty.validation.libuv.golden/entry_test/ets/test/LibuvAffinitySuite.test";
export default function testsuite() {
    LibuvLoadSuite();
    LibuvCoreSuite();
    LibuvAffinitySuite();
}
