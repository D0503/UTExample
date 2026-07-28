#include "napi/native_api.h"
#include "tinyxml2.h"

#include <string>
#include <vector>

namespace {

bool ReadUtf8(napi_env env, napi_value value, std::string &result)
{
    size_t length = 0;
    if (napi_get_value_string_utf8(env, value, nullptr, 0, &length) != napi_ok) {
        return false;
    }
    std::vector<char> buffer(length + 1);
    size_t copied = 0;
    if (napi_get_value_string_utf8(env, value, buffer.data(), buffer.size(), &copied) != napi_ok) {
        return false;
    }
    result.assign(buffer.data(), copied);
    return true;
}

napi_value ParseTitle(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc != 1) {
        napi_throw_type_error(env, nullptr, "parseTitle expects one XML string");
        return nullptr;
    }

    std::string xml;
    if (!ReadUtf8(env, args[0], xml)) {
        napi_throw_type_error(env, nullptr, "parseTitle expects a string");
        return nullptr;
    }

    tinyxml2::XMLDocument document;
    if (document.Parse(xml.c_str(), xml.size()) != tinyxml2::XML_SUCCESS) {
        napi_throw_error(env, nullptr, document.ErrorStr());
        return nullptr;
    }

    const tinyxml2::XMLElement *title = document.FirstChildElement("document");
    if (title != nullptr) {
        title = title->FirstChildElement("title");
    }
    if (title == nullptr || title->GetText() == nullptr) {
        napi_throw_error(env, nullptr, "XML does not contain document/title text");
        return nullptr;
    }

    napi_value result;
    napi_create_string_utf8(env, title->GetText(), NAPI_AUTO_LENGTH, &result);
    return result;
}

napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor descriptors[] = {
        {"parseTitle", nullptr, ParseTitle, nullptr, nullptr, nullptr, napi_default, nullptr}
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

extern "C" __attribute__((constructor)) void RegisterEntryModule()
{
    napi_module_register(&module);
}
