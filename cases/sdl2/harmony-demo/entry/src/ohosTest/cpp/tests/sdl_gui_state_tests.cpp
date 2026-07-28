#include "sdl_core_tests.h"

#include "gui_state.h"

#include <cmath>

namespace {

void CheckGuiState(SuiteResult &result, bool condition, const char *name)
{
    ++result.assertions;
    if (condition) {
        return;
    }

    ++result.failures;
    if (!result.message.empty()) {
        result.message += "; ";
    }
    result.message += name;
}

bool NearlyEqual(float left, float right)
{
    return std::fabs(left - right) < 0.001F;
}

} // namespace

SuiteResult RunSdlGuiStateSuite()
{
    SuiteResult result;

    ResetGuiState();
    GuiStateSnapshot state = GetGuiState();
    CheckGuiState(result, !state.renderReady, "reset clears render-ready");
    CheckGuiState(result, state.frameCount == 0, "reset clears frame count");
    CheckGuiState(result, state.buttonClickCount == 0, "reset clears button clicks");
    CheckGuiState(result, NearlyEqual(state.sliderValue, 0.5F), "reset centers slider");
    CheckGuiState(result, state.keyboardEventCount == 0, "reset clears keyboard events");
    CheckGuiState(result, state.lastKeyCode == 0, "reset clears last key code");

    MarkGuiFrameRendered();
    MarkGuiFrameRendered();
    state = GetGuiState();
    CheckGuiState(result, state.renderReady, "first rendered frame marks GUI ready");
    CheckGuiState(result, state.frameCount == 2, "rendered frames are counted");

    HandleGuiPointerDown(0.25F, 0.35F);
    state = GetGuiState();
    CheckGuiState(result, state.buttonClickCount == 1, "button center increments click count");

    HandleGuiPointerDown(0.50F, 0.60F);
    HandleGuiPointerMotion(0.95F, 0.60F);
    state = GetGuiState();
    CheckGuiState(result, NearlyEqual(state.sliderValue, 1.0F), "slider clamps at right edge");

    HandleGuiPointerMotion(0.05F, 0.60F);
    state = GetGuiState();
    CheckGuiState(result, NearlyEqual(state.sliderValue, 0.0F), "slider clamps at left edge");

    HandleGuiKeyDown(2017);
    state = GetGuiState();
    CheckGuiState(result, state.keyboardEventCount == 1, "keyboard events are counted");
    CheckGuiState(result, state.lastKeyCode == 2017, "last key code is retained");

    return result;
}
