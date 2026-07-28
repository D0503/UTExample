#ifndef LIBUV_CHECKS_H
#define LIBUV_CHECKS_H

#include <string>
#include <vector>

struct LibuvTestResult {
    int passed = 0;
    std::string version;
    std::vector<std::string> failures;
};

LibuvTestResult RunLoadSuite();
LibuvTestResult RunCoreSuite();
LibuvTestResult RunAffinitySuite();
LibuvTestResult RunAllSuites();

#endif
