#ifndef SDL2_HARMONY_GUI_STATE_H
#define SDL2_HARMONY_GUI_STATE_H

#include <cstdint>

struct GuiStateSnapshot {
    bool renderReady = false;
    std::uint64_t frameCount = 0;
    std::uint64_t buttonClickCount = 0;
    float sliderValue = 0.5F;
    std::uint64_t keyboardEventCount = 0;
    int lastKeyCode = 0;
};

GuiStateSnapshot GetGuiState();
void ResetGuiState();
void MarkGuiFrameRendered();
void HandleGuiPointerDown(float normalizedX, float normalizedY);
void HandleGuiPointerMotion(float normalizedX, float normalizedY);
void HandleGuiPointerUp();
void HandleGuiKeyDown(int keyCode);

#endif
