#include "libuv_checks.h"
#include "uv.h"

#include <algorithm>
#include <atomic>
#include <cstring>
#include <vector>

namespace {

void Check(LibuvTestResult& result, bool condition, const char* name)
{
    if (condition) {
        ++result.passed;
    } else {
        result.failures.emplace_back(name);
    }
}

void TimerCallback(uv_timer_t* handle)
{
    *static_cast<bool*>(handle->data) = true;
}

struct WorkState {
    bool worked = false;
    bool completed = false;
};

void WorkCallback(uv_work_t* request)
{
    static_cast<WorkState*>(request->data)->worked = true;
}

void AfterWorkCallback(uv_work_t* request, int status)
{
    static_cast<WorkState*>(request->data)->completed = (status == 0);
}

void ThreadCallback(void* argument)
{
    static_cast<std::atomic<bool>*>(argument)->store(true);
}

void Merge(LibuvTestResult& target, LibuvTestResult source)
{
    target.passed += source.passed;
    target.failures.insert(target.failures.end(), source.failures.begin(), source.failures.end());
}

} // namespace

LibuvTestResult RunLoadSuite()
{
    LibuvTestResult result;
    result.version = uv_version_string();
    Check(result, uv_version() == UV_VERSION_HEX, "dynamic_library_version_api");
    Check(result, result.version == "1.50.0", "version_is_1_50_0");

    uv_loop_t loop;
    const int initResult = uv_loop_init(&loop);
    Check(result, initResult == 0, "event_loop_initializes");
    if (initResult == 0) {
        Check(result, uv_loop_close(&loop) == 0, "event_loop_closes");
    }
    return result;
}

LibuvTestResult RunCoreSuite()
{
    LibuvTestResult result;
    result.version = uv_version_string();
    uv_loop_t loop;
    if (uv_loop_init(&loop) != 0) {
        Check(result, false, "core_event_loop_initializes");
        return result;
    }

    bool timerFired = false;
    uv_timer_t timer;
    int timerResult = uv_timer_init(&loop, &timer);
    if (timerResult == 0) {
        timer.data = &timerFired;
        timerResult = uv_timer_start(&timer, TimerCallback, 1, 0);
    }
    uv_run(&loop, UV_RUN_DEFAULT);
    Check(result, timerResult == 0 && timerFired, "timer_callback_fires");
    uv_close(reinterpret_cast<uv_handle_t*>(&timer), nullptr);
    uv_run(&loop, UV_RUN_DEFAULT);

    WorkState workState;
    uv_work_t workRequest;
    workRequest.data = &workState;
    const int queueResult = uv_queue_work(&loop, &workRequest, WorkCallback, AfterWorkCallback);
    uv_run(&loop, UV_RUN_DEFAULT);
    Check(result, queueResult == 0 && workState.worked && workState.completed, "work_queue_completes");

    std::atomic<bool> threadRan(false);
    uv_thread_t thread;
    const int createResult = uv_thread_create(&thread, ThreadCallback, &threadRan);
    const int joinResult = createResult == 0 ? uv_thread_join(&thread) : createResult;
    Check(result, createResult == 0 && joinResult == 0 && threadRan.load(), "thread_creates_and_joins");
    Check(result, uv_loop_close(&loop) == 0, "core_event_loop_closes");
    return result;
}

LibuvTestResult RunAffinitySuite()
{
    LibuvTestResult result;
    result.version = uv_version_string();
    const int maskSize = uv_cpumask_size();
    Check(result, maskSize > 0, "cpu_mask_size_available");
    if (maskSize <= 0) {
        return result;
    }

    std::vector<char> original(static_cast<size_t>(maskSize), 0);
    std::vector<char> target(static_cast<size_t>(maskSize), 0);
    std::vector<char> readback(static_cast<size_t>(maskSize), 0);
    uv_thread_t self = uv_thread_self();
    const int getResult = uv_thread_getaffinity(&self, original.data(), original.size());
    Check(result, getResult == 0, "cpu_affinity_reads");
    if (getResult != 0) {
        return result;
    }

    const auto firstAllowed = std::find(original.begin(), original.end(), 1);
    Check(result, firstAllowed != original.end(), "allowed_cpu_exists");
    if (firstAllowed == original.end()) {
        return result;
    }
    const size_t selected = static_cast<size_t>(firstAllowed - original.begin());
    target[selected] = 1;

    const int setResult = uv_thread_setaffinity(&self, target.data(), nullptr, target.size());
    const int readbackResult =
        setResult == 0 ? uv_thread_getaffinity(&self, readback.data(), readback.size()) : setResult;
    const bool selectedCpuSet = readbackResult == 0 && readback[selected] == 1;
    const int restoreResult = uv_thread_setaffinity(&self, original.data(), nullptr, original.size());
    Check(result, setResult == 0, "cpu_affinity_sets_allowed_cpu");
    Check(result, selectedCpuSet, "cpu_affinity_reads_back");
    Check(result, restoreResult == 0, "cpu_affinity_restores");
    return result;
}

LibuvTestResult RunAllSuites()
{
    LibuvTestResult result;
    result.version = uv_version_string();
    Merge(result, RunLoadSuite());
    Merge(result, RunCoreSuite());
    Merge(result, RunAffinitySuite());
    return result;
}
