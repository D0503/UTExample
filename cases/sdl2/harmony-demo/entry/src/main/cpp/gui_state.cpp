#include "gui_state.h"

#include <algorithm>
#include <mutex>

namespace {

std::mutex g_stateMutex;
GuiStateSnapshot g_state;
bool g_sliderDragging = false;

bool IsWithin(float value, float minimum, float maximum)
{
    return value >= minimum && value <= maximum;
}

void UpdateSlider(float normalizedX)
{
    constexpr float kSliderStart = 0.20F;
    constexpr float kSliderEnd = 0.80F;
    g_state.sliderValue =
        std::clamp((normalizedX - kSliderStart) / (kSliderEnd - kSliderStart), 0.0F, 1.0F);
}

} // namespace

GuiStateSnapshot GetGuiState()
{
    std::lock_guard<std::mutex> lock(g_stateMutex);
    return g_state;
}

void ResetGuiState()
{
    std::lock_guard<std::mutex> lock(g_stateMutex);
    g_state = GuiStateSnapshot{};
    g_sliderDragging = false;
}

void MarkGuiFrameRendered()
{
    std::lock_guard<std::mutex> lock(g_stateMutex);
    g_state.renderReady = true;
    ++g_state.frameCount;
}

void HandleGuiPointerDown(float normalizedX, float normalizedY)
{
    std::lock_guard<std::mutex> lock(g_stateMutex);
    constexpr float kButtonLeft = 0.125F;
    constexpr float kButtonRight = 0.375F;
    constexpr float kButtonTop = 0.275F;
    constexpr float kButtonBottom = 0.425F;
    if (IsWithin(normalizedX, kButtonLeft, kButtonRight) &&
        IsWithin(normalizedY, kButtonTop, kButtonBottom)) {
        ++g_state.buttonClickCount;
    }

    constexpr float kSliderHitTop = 0.53F;
    constexpr float kSliderHitBottom = 0.67F;
    g_sliderDragging = IsWithin(normalizedY, kSliderHitTop, kSliderHitBottom);
    if (g_sliderDragging) {
        UpdateSlider(normalizedX);
    }
}

void HandleGuiPointerMotion(float normalizedX, float normalizedY)
{
    std::lock_guard<std::mutex> lock(g_stateMutex);
    if (g_sliderDragging && IsWithin(normalizedY, 0.45F, 0.75F)) {
        UpdateSlider(normalizedX);
    }
}

void HandleGuiPointerUp()
{
    std::lock_guard<std::mutex> lock(g_stateMutex);
    g_sliderDragging = false;
}

void HandleGuiKeyDown(int keyCode)
{
    std::lock_guard<std::mutex> lock(g_stateMutex);
    ++g_state.keyboardEventCount;
    g_state.lastKeyCode = keyCode;
}
