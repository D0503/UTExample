#include "napi/native_api.h"
#include "libuv_checks.h"

namespace {

napi_value ToNapiResult(napi_env env, const LibuvTestResult& nativeResult)
{
    napi_value result;
    napi_create_object(env, &result);

    napi_value version;
    napi_create_string_utf8(env, nativeResult.version.c_str(), NAPI_AUTO_LENGTH, &version);
    napi_set_named_property(env, result, "version", version);

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

napi_value RunAll(napi_env env, napi_callback_info)
{
    return ToNapiResult(env, RunAllSuites());
}

napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor descriptors[] = {
        {"runAll", nullptr, RunAll, nullptr, nullptr, nullptr, napi_default, nullptr}
    };
    napi_define_properties(env, exports, 1, descriptors);
    return exports;
}

} // namespace

static napi_module module = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = nullptr,
    .reserved = {nullptr}
};

extern "C" __attribute__((constructor)) void RegisterEntryModule()
{
    napi_module_register(&module);
}
