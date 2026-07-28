#ifndef SDL2_HARMONY_CORE_TESTS_H
#define SDL2_HARMONY_CORE_TESTS_H

#include <string>

struct SuiteResult {
    int assertions = 0;
    int failures = 0;
    std::string message;
};

SuiteResult RunSdlLoadSuite();
SuiteResult RunSdlRenderSuite();
SuiteResult RunSdlGuiStateSuite();

#endif
