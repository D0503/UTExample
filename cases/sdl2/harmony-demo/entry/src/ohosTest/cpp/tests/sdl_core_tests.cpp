#include "sdl_core_tests.h"

#include "SDL.h"

#include <cstdint>

namespace {

void Check(SuiteResult &result, bool condition, const char *name)
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

Uint32 ReadPixel(const SDL_Surface *surface, int x, int y)
{
    const auto *row = static_cast<const std::uint8_t *>(surface->pixels) + y * surface->pitch;
    switch (surface->format->BytesPerPixel) {
        case 1:
            return row[x];
        case 2:
            return *reinterpret_cast<const std::uint16_t *>(row + x * 2);
        case 3: {
            const std::uint8_t *pixel = row + x * 3;
#if SDL_BYTEORDER == SDL_BIG_ENDIAN
            return (static_cast<Uint32>(pixel[0]) << 16) |
                (static_cast<Uint32>(pixel[1]) << 8) |
                static_cast<Uint32>(pixel[2]);
#else
            return static_cast<Uint32>(pixel[0]) |
                (static_cast<Uint32>(pixel[1]) << 8) |
                (static_cast<Uint32>(pixel[2]) << 16);
#endif
        }
        case 4:
            return *reinterpret_cast<const std::uint32_t *>(row + x * 4);
        default:
            return 0;
    }
}

} // namespace

SuiteResult RunSdlLoadSuite()
{
    SuiteResult result;

    SDL_version version{};
    SDL_GetVersion(&version);
    Check(result, version.major == 2, "major version is 2");
    Check(result, version.minor == 0, "minor version is 0");
    Check(result, version.patch == 12, "patch version is 12");

    SDL_Quit();
    Check(result, SDL_Init(0) == 0, "SDL_Init(0) succeeds");
    Check(result, SDL_WasInit(0) == 0, "SDL_WasInit(0) reports no initialized subsystem");
    SDL_Quit();

    return result;
}

SuiteResult RunSdlRenderSuite()
{
    SuiteResult result;
    SDL_Surface *surface = SDL_CreateRGBSurfaceWithFormat(
        0, 32, 32, 32, SDL_PIXELFORMAT_RGBA32);
    Check(result, surface != nullptr, "RGBA32 surface is created");
    if (surface == nullptr) {
        result.message += result.message.empty() ? SDL_GetError() : std::string("; ") + SDL_GetError();
        return result;
    }

    const Uint32 background = SDL_MapRGBA(surface->format, 0, 0, 0, 255);
    const Uint32 center = SDL_MapRGBA(surface->format, 20, 120, 220, 255);
    SDL_Rect rect{8, 8, 16, 16};
    Check(result, SDL_FillRect(surface, nullptr, background) == 0, "background fill succeeds");
    Check(result, SDL_FillRect(surface, &rect, center) == 0, "center fill succeeds");

    bool locked = false;
    if (SDL_MUSTLOCK(surface)) {
        locked = SDL_LockSurface(surface) == 0;
        Check(result, locked, "surface lock succeeds");
    }

    if (!SDL_MUSTLOCK(surface) || locked) {
        Uint8 red = 0;
        Uint8 green = 0;
        Uint8 blue = 0;
        Uint8 alpha = 0;
        SDL_GetRGBA(ReadPixel(surface, 0, 0), surface->format, &red, &green, &blue, &alpha);
        Check(result,
            red == 0 && green == 0 && blue == 0 && alpha == 255,
            "background pixel is opaque black");

        SDL_GetRGBA(ReadPixel(surface, 16, 16), surface->format, &red, &green, &blue, &alpha);
        Check(result,
            red == 20 && green == 120 && blue == 220 && alpha == 255,
            "center pixel has expected RGBA value");
    }

    if (locked) {
        SDL_UnlockSurface(surface);
    }
    SDL_FreeSurface(surface);
    return result;
}
