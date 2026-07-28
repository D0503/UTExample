#include "tinyxml2_tests.h"

#include "tinyxml2.h"

#include <cstring>
#include <string>

namespace {

void Check(NativeTestResult &result, bool condition, const char *name)
{
    if (condition) {
        ++result.passed;
    } else {
        result.failures.emplace_back(name);
    }
}

} // namespace

NativeTestResult RunLoadSuite()
{
    NativeTestResult result;
    Check(result,
        TINYXML2_MAJOR_VERSION == 11 &&
        TINYXML2_MINOR_VERSION == 0 &&
        TINYXML2_PATCH_VERSION == 0,
        "version_is_11_0_0");

    tinyxml2::XMLDocument document;
    Check(result, document.ErrorID() == tinyxml2::XML_SUCCESS, "document_constructs");
    return result;
}

NativeTestResult RunCoreSuite()
{
    NativeTestResult result;

    tinyxml2::XMLDocument valid;
    Check(result,
        valid.Parse("<document><title>HarmonyOS</title></document>") == tinyxml2::XML_SUCCESS &&
        std::strcmp(valid.FirstChildElement("document")->FirstChildElement("title")->GetText(), "HarmonyOS") == 0,
        "parses_valid_document");

    tinyxml2::XMLPrinter printer;
    valid.Print(&printer);
    Check(result,
        std::string(printer.CStr()).find("<title>HarmonyOS</title>") != std::string::npos,
        "serializes_document");

    tinyxml2::XMLDocument entity;
    entity.Parse("<value>HarmonyOS &amp; tinyxml2</value>");
    Check(result,
        entity.FirstChildElement("value") != nullptr &&
        std::strcmp(entity.FirstChildElement("value")->GetText(), "HarmonyOS & tinyxml2") == 0,
        "decodes_entities");

    tinyxml2::XMLDocument malformed;
    Check(result, malformed.Parse("<document>") != tinyxml2::XML_SUCCESS, "rejects_malformed_xml");

    tinyxml2::XMLDocument missing;
    missing.Parse("<document/>");
    Check(result,
        missing.FirstChildElement("document")->FirstChildElement("title") == nullptr,
        "handles_missing_element");

    tinyxml2::XMLDocument reusable;
    bool repeated = true;
    for (int index = 0; index < 10; ++index) {
        reusable.Clear();
        repeated = repeated &&
            reusable.Parse("<root><value>1</value></root>") == tinyxml2::XML_SUCCESS;
    }
    Check(result, repeated, "supports_repeated_parse_and_clear");

    return result;
}
