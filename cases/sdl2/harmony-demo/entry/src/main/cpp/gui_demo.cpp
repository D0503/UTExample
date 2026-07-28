#include "gui_state.h"

#include "SDL.h"

#include <algorithm>

namespace {

SDL_Rect RelativeRect(int width, int height, float x, float y, float w, float h)
{
    return SDL_Rect{
        static_cast<int>(x * width),
        static_cast<int>(y * height),
        std::max(1, static_cast<int>(w * width)),
        std::max(1, static_cast<int>(h * height))
    };
}

void RenderGui(SDL_Renderer *renderer, int width, int height)
{
    const GuiStateSnapshot state = GetGuiState();
    SDL_SetRenderDrawColor(renderer, 20, 25, 34, 255);
    SDL_RenderClear(renderer);

    SDL_Rect button = RelativeRect(width, height, 0.125F, 0.275F, 0.25F, 0.15F);
    const Uint8 buttonBlue = state.buttonClickCount == 0 ? 220 : 255;
    SDL_SetRenderDrawColor(renderer, 30, 120, buttonBlue, 255);
    SDL_RenderFillRect(renderer, &button);
    SDL_SetRenderDrawColor(renderer, 160, 205, 255, 255);
    SDL_RenderDrawRect(renderer, &button);

    SDL_Rect sliderTrack = RelativeRect(width, height, 0.20F, 0.59F, 0.60F, 0.02F);
    SDL_SetRenderDrawColor(renderer, 75, 90, 105, 255);
    SDL_RenderFillRect(renderer, &sliderTrack);
    const float knobX = 0.20F + state.sliderValue * 0.60F;
    SDL_Rect sliderKnob = RelativeRect(width, height, knobX - 0.015F, 0.56F, 0.03F, 0.08F);
    SDL_SetRenderDrawColor(renderer, 55, 205, 110, 255);
    SDL_RenderFillRect(renderer, &sliderKnob);

    SDL_Rect input = RelativeRect(width, height, 0.15F, 0.74F, 0.70F, 0.12F);
    SDL_SetRenderDrawColor(renderer, 42, 49, 62, 255);
    SDL_RenderFillRect(renderer, &input);
    SDL_SetRenderDrawColor(renderer, 155, 165, 180, 255);
    SDL_RenderDrawRect(renderer, &input);

    SDL_RenderPresent(renderer);
    MarkGuiFrameRendered();
}

float Normalize(int value, int extent)
{
    return extent > 0 ? static_cast<float>(value) / static_cast<float>(extent) : 0.0F;
}

} // namespace

extern "C" __attribute__((visibility("default"))) int main(int, char **)
{
    ResetGuiState();
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS) != 0) {
        return 1;
    }

    int windowWidth = 960;
    int windowHeight = 640;
    SDL_DisplayMode displayMode{};
    if (SDL_GetCurrentDisplayMode(0, &displayMode) == 0) {
        windowWidth = displayMode.w;
        windowHeight = displayMode.h;
    }
    SDL_Window *window = SDL_CreateWindow(
        "SDL2 HarmonyOS GUI validation",
        SDL_WINDOWPOS_UNDEFINED,
        SDL_WINDOWPOS_UNDEFINED,
        windowWidth,
        windowHeight,
        SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE);
    if (window == nullptr) {
        SDL_Quit();
        return 2;
    }

    SDL_Renderer *renderer = SDL_CreateRenderer(
        window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (renderer == nullptr) {
        renderer = SDL_CreateRenderer(window, -1, 0);
    }
    if (renderer == nullptr) {
        SDL_DestroyWindow(window);
        SDL_Quit();
        return 3;
    }

    bool running = true;
    bool dirty = true;
    while (running) {
        SDL_Event event{};
        while (SDL_PollEvent(&event) != 0) {
            int width = 1;
            int height = 1;
            SDL_GetWindowSize(window, &width, &height);
            switch (event.type) {
                case SDL_QUIT:
                    running = false;
                    break;
                case SDL_MOUSEBUTTONDOWN:
                    HandleGuiPointerDown(
                        Normalize(event.button.x, width),
                        Normalize(event.button.y, height));
                    dirty = true;
                    break;
                case SDL_MOUSEBUTTONUP:
                    HandleGuiPointerUp();
                    dirty = true;
                    break;
                case SDL_MOUSEMOTION:
                    HandleGuiPointerMotion(
                        Normalize(event.motion.x, width),
                        Normalize(event.motion.y, height));
                    dirty = true;
                    break;
                case SDL_FINGERDOWN:
                    HandleGuiPointerDown(event.tfinger.x, event.tfinger.y);
                    dirty = true;
                    break;
                case SDL_FINGERUP:
                    HandleGuiPointerUp();
                    dirty = true;
                    break;
                case SDL_FINGERMOTION:
                    HandleGuiPointerMotion(event.tfinger.x, event.tfinger.y);
                    dirty = true;
                    break;
                case SDL_KEYDOWN:
                    HandleGuiKeyDown(static_cast<int>(event.key.keysym.sym));
                    dirty = true;
                    break;
                case SDL_WINDOWEVENT:
                    dirty = true;
                    break;
                default:
                    break;
            }
        }

        if (dirty || GetGuiState().frameCount == 0) {
            int width = 1;
            int height = 1;
            SDL_GetRendererOutputSize(renderer, &width, &height);
            RenderGui(renderer, width, height);
            dirty = false;
        }
        SDL_Delay(16);
    }

    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}
