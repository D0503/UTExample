# tinyxml2 HarmonyOS Native 验证 Case

该 case 验证 C++ XML 解析库 tinyxml2 能否作为源码直接集成到 HarmonyOS
Native 应用，并在模拟器或真机应用进程内完成加载和核心 API 测试。

## 来源

- 上游项目：https://github.com/leethomason/tinyxml2
- 固定版本：11.0.0
- 上游提交：9148bdf（11.0.0 release）
- 上游许可证：Zlib
- HarmonyOS 参考工程：
  https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/tree/master/tinyxml2

OpenHarmony-TPC 的 tinyxml2 示例使用 Native C++ HAP、CMake
`add_subdirectory` 和 Node-API 集成 tinyxml2，并记录在 DevEco Studio 4.0
Canary、OpenHarmony API 10 上验证通过。本 case 保留其源码集成思路，并使用
当前 DevEco Studio 工程与 C++ ohosTest 结构重新实现。

## 目录

```text
tinyxml2/
├── case.json
├── README.md
├── library/       # 手工放入的 tinyxml2 11.0.0 源码
└── harmony-demo/  # 独立 HarmonyOS Native 应用
```

`library/` 是已经可被 HarmonyOS NDK 编译的源码快照。平台不下载源码、不应用
补丁，也不切换版本。

## 验证范围

| Level | Suite | 内容 |
|---|---|---|
| L0 | 固定构建阶段 | 编译 tinyxml2、Native 模块并生成业务与测试 HAP |
| L1 | `Tinyxml2LoadSuite` | 版本、对象构造和测试动态库加载 |
| L2 | `Tinyxml2CoreSuite` | 解析、序列化、实体、错误输入和重复使用 |

tinyxml2 不依赖窗口、GPU、网络或外设，因此两个 suite 均可在 HarmonyOS
模拟器或真机运行，不需要 UI 测试。

## 执行方式

自动化系统从 `case.json` 读取 suite，通过 Hvigor 构建并安装业务 HAP 与
ohosTest HAP，然后执行：

```shell
hdc shell aa test \
  -b com.thirdparty.validation.tinyxml2 \
  -m entry_test \
  -s unittest OpenHarmonyTestRunner \
  -s class Tinyxml2LoadSuite
```

将最后一个参数替换为 `Tinyxml2CoreSuite` 可执行核心 API suite。
