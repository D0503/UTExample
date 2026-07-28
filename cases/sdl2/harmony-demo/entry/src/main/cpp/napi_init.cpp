#include "gui_state.h"

#include "napi/native_api.h"

namespace {

void SetBoolean(napi_env env, napi_value object, const char *name, bool value)
{
    napi_value property = nullptr;
    napi_get_boolean(env, value, &property);
    napi_set_named_property(env, object, name, property);
}

void SetUint64(napi_env env, napi_value object, const char *name, std::uint64_t value)
{
    napi_value property = nullptr;
    napi_create_double(env, static_cast<double>(value), &property);
    napi_set_named_property(env, object, name, property);
}

void SetInt32(napi_env env, napi_value object, const char *name, int value)
{
    napi_value property = nullptr;
    napi_create_int32(env, value, &property);
    napi_set_named_property(env, object, name, property);
}

void SetDouble(napi_env env, napi_value object, const char *name, double value)
{
    napi_value property = nullptr;
    napi_create_double(env, value, &property);
    napi_set_named_property(env, object, name, property);
}

napi_value GetState(napi_env env, napi_callback_info)
{
    const GuiStateSnapshot state = GetGuiState();
    napi_value result = nullptr;
    napi_create_object(env, &result);
    SetBoolean(env, result, "renderReady", state.renderReady);
    SetUint64(env, result, "frameCount", state.frameCount);
    SetUint64(env, result, "buttonClickCount", state.buttonClickCount);
    SetDouble(env, result, "sliderValue", state.sliderValue);
    SetUint64(env, result, "keyboardEventCount", state.keyboardEventCount);
    SetInt32(env, result, "lastKeyCode", state.lastKeyCode);
    return result;
}

napi_value ResetState(napi_env env, napi_callback_info)
{
    ResetGuiState();
    napi_value undefined = nullptr;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor descriptors[] = {
        {"getGuiState", nullptr, GetState, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"resetGuiState", nullptr, ResetState, nullptr, nullptr, nullptr, napi_default, nullptr}
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
    .nm_modname = "entry",
    .nm_priv = nullptr,
    .reserved = {nullptr}
};

extern "C" __attribute__((constructor, visibility("hidden")))
void RegisterSdl2ValidationEntryModule()
{
    napi_module_register(&module);
}
