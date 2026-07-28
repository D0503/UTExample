# SDL2 HarmonyOS GUI 验证 Case

该 case 验证带 GUI 能力的 C/C++ 三方库 SDL2 能否以源码方式集成到
HarmonyOS Native 应用，并在 MateBook Pro PC 模拟器中自动验证加载、离屏
渲染、指针交互、拖动和键盘输入。

## 来源

- 鸿蒙适配项目：https://gitcode.com/CPF-ApplicationTPC/ohos_sdl2
- 固定提交：`77fc66603a1ddfafca45daf6367824a10ff05562`
- SDL 版本：2.0.12
- 许可证：Zlib

`library/` 以上述提交中构建 SDL2 所需的 tracked source 为基线。为避免把上游
演示应用和其他平台的桌面 IDE 工程混入验证 case，快照排除了
`ohos-project/`、Visual Studio 和 Xcode 工程；保留了根 CMake 配置、
许可证及来源说明、`cmake/`、`include/`、`src/`、CMake 模板和构建可能使用
的 Wayland 协议文件。自动化执行期间不下载源码、不切换版本，也不动态应用补丁。

该 case 在源码快照中包含一项 HarmonyOS 触摸修正：
`src/video/ohos/SDL_ohostouch.c` 统一将 `DOWN`、`MOVE`、`UP` 的像素坐标
按 SDL 约定归一化。原适配仅归一化 `DOWN`，会导致拖动事件把像素值作为
0–1 坐标传入 SDL，滑块等连续交互失真。这项修正也是本 case 实机验证发现的
移植阻碍点之一。

该 SDL2 鸿蒙端口的 CMake 还依赖 cJSON。`third_party/cjson/` 固定为
[cJSON v1.7.15](https://github.com/DaveGamble/cJSON/releases/tag/v1.7.15)
源码；归档来源是端口声明的
`https://gitee.com/mirrors/cJSON/repository/archive/v1.7.15.zip`，SHA-256 为
`7a10eccfbf907bf0d6adc695dc7e503f33b83f50a8f31470b82f92352ecc57e4`，
与端口内 `cmake/DownloadCJSON.cmake` 声明一致，许可证为 MIT。
ohosTest CMake 通过 `CJSON_SOURCE_DIR` 显式引用该本地目录，正式构建不会
联网下载传递依赖。

该鸿蒙适配并非完整 SDL2 API 实现。上游说明当前适配了 74 个接口，覆盖基础
能力、窗口、音视频和渲染等模块；未适配接口不属于本 case 的通过承诺。

## 目录

```text
sdl2/
├── case.json
├── README.md
├── library/       # 固定的 SDL2 2.0.12 鸿蒙适配源码
├── third_party/
│   └── cjson/     # 固定的 cJSON v1.7.15 传递依赖
└── harmony-demo/  # 独立 HarmonyOS Native GUI 应用
```

## 验证范围

| Level | Suite | Runner | 内容 |
|---|---|---|---|
| L1 | `SdlLoadSuite` | `napi-ohostest` | SDL 版本、初始化和测试动态库加载 |
| L2 | `SdlRenderSuite` | `napi-ohostest` | 确定性的 Surface 填充、像素读取和渲染基础能力 |
| L2 | `SdlGuiStateSuite` | `napi-ohostest` | 按钮、滑块和键盘状态机的确定性原生测试 |
| L3 | `SdlPointerUiSuite` | `ui-ohostest` | 点击按钮、拖动滑块并断言 native 状态变化 |
| L3 | `SdlKeyboardUiSuite` | `ui-ohostest` | 聚焦渲染区域、注入键盘输入并断言 native 状态 |

## GUI 自动化边界

HarmonyOS UiTest 可以通过组件 `.id(...)` selector 定位承载 SDL 内容的
ArkUI `NodeContainer`，并取得其屏幕边界。SDL2 动态节点适配器会在容器中创建
内部 XComponent；SDL 在该 XComponent 内部绘制的按钮、
滑块和文本只是像素，不会成为 ArkUI 或无障碍节点，因此不能用 UiTest
selector 直接定位。

GUI suite 以 NodeContainer 边界为基准计算相对坐标，注入点击、拖动和键盘事件，
随后读取页面暴露的 native 状态探针进行确定性断言。截图只作为渲染证据留存，
不做容易受分辨率、缩放和 GPU 差异影响的严格像素比较。

## 目标环境与执行方式

目标运行环境是 DevEco Studio 的 **MateBook Pro** PC 模拟器，要求具备
display、pointer、keyboard 和 GPU 能力。自动化系统负责注入 SDK、签名、
设备地址等所有 case 共用配置，并根据 `case.json` 构建、安装业务 HAP 和
ohosTest HAP。

Native suite 由 `OpenHarmonyTestRunner` 按 selector 执行，例如：

```shell
hdc shell aa test \
  -b com.thirdparty.validation.sdl2 \
  -m entry_test \
  -s unittest OpenHarmonyTestRunner \
  -s class SdlLoadSuite
```

将最后一个参数替换为 `SdlRenderSuite`、`SdlPointerUiSuite` 或
`SdlGuiStateSuite`、`SdlKeyboardUiSuite` 可分别执行其余 suite。两个 UI
suite 还会启动业务 Ability，并通过 UiTest 完成交互注入与结果采集。

## MateBook Pro 模拟器验证说明

在 HarmonyOS PC 模拟器上可以用 HDC 暴露的 UiTest Shell 命令完成无人值守
输入与状态断言。当前验证使用 `127.0.0.1:5555`，页面中
`sdlSurface` 的边界为 `[515,351][2605,1675]`，实测结果如下：

- 点击 SDL 按钮后：`buttonClicks=1`
- 将滑块拖至轨道约 75% 后：`slider=0.742`
- 注入字母 A 后：`keyboardEvents=1;lastKeyCode=97`

当前 MateBook Pro 模拟器运行时中，ohosTest 进程里的
`@ohos.UiTest.Driver.create()` 返回 `null`，设备日志对应 UiTest daemon IPC
连接不可用；开启 `persist.ace.testmode.enabled=1` 后仍然如此。因此：

1. `SdlPointerUiSuite` 和 `SdlKeyboardUiSuite` 已完成编译，保留为支持
   UiTest daemon 的真机或后续模拟器镜像的首选方案；
2. 当前模拟器验证使用 `hdc shell uitest uiInput ...` 注入点击、滑动和按键，
   再用 `uitest dumpLayout` 读取 `nativeStatus` 断言；
3. 自动化平台应把 `Driver.create()`/daemon IPC 失败分类为测试基础设施失败，
   不应直接判为 SDL2 兼容性失败。

Shell fallback 仍然属于 UiTest 自动化，但坐标是设备屏幕坐标。流水线执行时应先
通过 `dumpLayout` 取得 `sdlSurface` 边界，再按与两个 UI suite 相同的比例
计算输入点，不要硬编码上述 MateBook Pro 坐标。
