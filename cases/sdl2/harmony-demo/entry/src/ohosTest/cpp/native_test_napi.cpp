#include "napi/native_api.h"
#include "sdl_core_tests.h"

namespace {

napi_value ToNapiResult(napi_env env, const SuiteResult &nativeResult)
{
    napi_value result = nullptr;
    napi_create_object(env, &result);

    napi_value assertions = nullptr;
    napi_create_int32(env, nativeResult.assertions, &assertions);
    napi_set_named_property(env, result, "assertions", assertions);

    napi_value failures = nullptr;
    napi_create_int32(env, nativeResult.failures, &failures);
    napi_set_named_property(env, result, "failures", failures);

    napi_value message = nullptr;
    napi_create_string_utf8(env, nativeResult.message.c_str(), NAPI_AUTO_LENGTH, &message);
    napi_set_named_property(env, result, "message", message);

    return result;
}

napi_value RunLoad(napi_env env, napi_callback_info)
{
    return ToNapiResult(env, RunSdlLoadSuite());
}

napi_value RunRender(napi_env env, napi_callback_info)
{
    return ToNapiResult(env, RunSdlRenderSuite());
}

napi_value RunGuiState(napi_env env, napi_callback_info)
{
    return ToNapiResult(env, RunSdlGuiStateSuite());
}

napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor descriptors[] = {
        {"runLoadSuite", nullptr, RunLoad, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"runRenderSuite", nullptr, RunRender, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"runGuiStateSuite", nullptr, RunGuiState, nullptr, nullptr, nullptr, napi_default, nullptr}
    };
    napi_define_properties(env, exports, sizeof(descriptors) / sizeof(descriptors[0]), descriptors);
    return exports;
}

} // namespace

static napi_module module = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry_test",
    .nm_priv = nullptr,
    .reserved = {nullptr}
};

extern "C" __attribute__((constructor)) void RegisterEntryTestModule()
{
    napi_module_register(&module);
}
