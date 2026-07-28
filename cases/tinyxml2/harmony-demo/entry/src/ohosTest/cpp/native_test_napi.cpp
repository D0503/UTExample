#include "napi/native_api.h"
#include "tinyxml2_tests.h"

namespace {

napi_value ToNapiResult(napi_env env, const NativeTestResult &nativeResult)
{
    napi_value result;
    napi_create_object(env, &result);

    napi_value passed;
    napi_create_int32(env, nativeResult.passed, &passed);
    napi_set_named_property(env, result, "passed", passed);

    napi_value failed;
    napi_create_int32(env, static_cast<int32_t>(nativeResult.failures.size()), &failed);
    napi_set_named_property(env, result, "failed", failed);

    napi_value failures;
    napi_create_array_with_length(env, nativeResult.failures.size(), &failures);
    for (size_t index = 0; index < nativeResult.failures.size(); ++index) {
        napi_value failure;
        napi_create_string_utf8(env, nativeResult.failures[index].c_str(), NAPI_AUTO_LENGTH, &failure);
        napi_set_element(env, failures, index, failure);
    }
    napi_set_named_property(env, result, "failures", failures);

    return result;
}

napi_value RunLoad(napi_env env, napi_callback_info)
{
    return ToNapiResult(env, RunLoadSuite());
}

napi_value RunCore(napi_env env, napi_callback_info)
{
    return ToNapiResult(env, RunCoreSuite());
}

napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor descriptors[] = {
        {"runLoadSuite", nullptr, RunLoad, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"runCoreSuite", nullptr, RunCore, nullptr, nullptr, nullptr, napi_default, nullptr}
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
