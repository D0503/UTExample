#ifndef TINYXML2_HARMONY_TESTS_H
#define TINYXML2_HARMONY_TESTS_H

#include <string>
#include <vector>

struct NativeTestResult {
    int passed = 0;
    std::vector<std::string> failures;
};

NativeTestResult RunLoadSuite();
NativeTestResult RunCoreSuite();

#endif
