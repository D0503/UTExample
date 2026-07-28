# 第三方库 HarmonyOS PC Bench 构建调研总结

> 面向：技术管理与 Bench 建设决策  
> 调研范围：tinyxml2、libuv、Log4Qt  
> 当前阶段：学习、候选挖掘与原型验证

## 一、总结结论

这两天的工作主要围绕“如何把第三方开源库转化为 HarmonyOS PC Bench 用例”展开。

目前形成的核心认识是：

> Bench 的关键不只是让第三方库在 HarmonyOS 上编译成功，而是找到一个真实、稳定、可测试、修复边界清晰的平台兼容问题。

一个合格的 Bench 应形成以下闭环：

```text
Base + Test
    ↓
稳定失败或功能不符合预期
    ↓
应用 Golden 修复
    ↓
Golden + 同一份 Test
    ↓
构建成功且测试全部通过
```

三个调研对象代表了三类不同情况：

| 第三方库 | 当前状态 | 建议定位 |
| --- | --- | --- |
| tinyxml2 | 已完成 HarmonyOS Native 构建验证 | 正向集成样例、公共工程模板 |
| libuv | 已完成 Base/Golden 原型及 HAP 构建 | 当前最适合转成正式 Bench 的候选 |
| Log4Qt | 已完成可行性调研，尚未构建 | 复杂框架依赖型候选，需先准备 Qt 环境 |

需要特别说明：

- libuv Golden 的业务 HAP 和 ohosTest HAP 已经构建成功。
- libuv 尚未完成调试签名、模拟器安装和连续三轮设备测试。
- Log4Qt 目前只能确认存在较重的 Qt 前置依赖，尚不能证明存在 Log4Qt 自身的 HarmonyOS 兼容缺陷。

---

## 二、HarmonyOS PC Bench 的构建方法

### 1. 候选库调研

首先需要调查：

- 上游仓库和许可证。
- 可使用的版本或 Tag。
- CMake、Make、qmake 等构建系统。
- 是否依赖网络、图形、媒体、数据库或大型框架。
- 是否已经支持 OpenHarmony/HarmonyOS。
- 是否存在官方修复提交或移植仓库。
- 是否能够在 x86_64 模拟器环境中验证。

### 2. 原样构建 Base

将固定版本源码接入 HarmonyOS 工程，先解决公共工程问题：

- CMake 源码路径。
- HarmonyOS 平台识别。
- NDK 工具链配置。
- x86_64 ABI。
- NAPI 接口。
- ArkTS 页面和 ohosTest 工程。

这个阶段只解决“让构建真正进入第三方库源码”的问题，不应提前修复目标兼容缺陷。

### 3. 判断失败是否有效

有效失败应该满足：

- 可以重复出现。
- 与 HarmonyOS API 或 ABI 差异直接相关。
- 发生在第三方库源码或其平台配置中。
- 修复范围合理。
- 可以通过公开行为测试验证。

### 4. 构建 Golden

Golden 应只修改解决目标问题所需的内容。

修复完成后需要验证：

- 业务 HAP 能够生成。
- ohosTest HAP 能够生成。
- Native 产物为 HarmonyOS x86_64 ELF。
- 没有混入 Windows/Linux 宿主库。
- 没有携带本机绝对运行路径。
- 页面和测试能够在模拟器执行。

### 5. 转换为正式 Bench

双 Demo 验证完成后，再收敛为正式结构：

```text
case/
├── base/            # 未修复基准工程
├── test.patch       # 独立测试
├── golden.patch     # 只包含标准修复
└── task.yaml        # 任务描述与验收信息
```

正式执行关系为：

```text
Base + test.patch
Base + test.patch + golden.patch
```

这样可以从结构上保证 Base 和 Golden 使用完全相同的测试。

---

## 三、三个案例集中对比

三个案例分别代表“无需明显适配”“存在清晰平台缺陷”和“前置框架过重”三种情况。

| 案例 | 关键发现 | 当前结果 | Bench 判断 |
| --- | --- | --- | --- |
| tinyxml2 | 轻量纯 C++ 库，平台相关代码很少，源码可直接由 HarmonyOS NDK 编译 | Native 接入、业务 HAP 和 ohosTest HAP 已验证 | 适合作为集成模板，但目前缺少真实鸿蒙缺陷，不宜人为制造 Base |
| libuv | `v1.50.0` 使用 HarmonyOS 缺少的 `pthread_setaffinity_np` 和 `pthread_getaffinity_np` | Base 在目标源码处稳定失败；Golden 两个 HAP 构建成功 | 具备真实问题、官方修复依据和独立测试，是当前最合适的正式 Bench 原型 |
| Log4Qt | 依赖 Qt Core、Concurrent、moc 和 Qt CMake 工具链 | 已完成可行性调研，尚未建立 Qt for HarmonyOS x86_64 环境 | 暂列复杂依赖候选；不能把“缺少 Qt”误判成 Log4Qt 适配问题 |

### tinyxml2：集成模板

- **现象：**源码可通过 CMake、NAPI 接入 HarmonyOS，并完成解析、序列化等功能验证。
- **判断：**它证明了 Native 三方库接入链路可行，但没有暴露稳定的平台兼容问题。
- **定位：**作为 Stage、Native、NAPI、ohosTest 公共模板，不直接制作缺陷型 Bench。

### libuv：有效 Bench 原型

- **现象：**Base 在 `src/unix/thread.c` 的两个线程亲和性接口处稳定失败。
- **修复：**Golden 按官方提交 `b807450e`，使用 `pthread_gettid_np + sched_set/getaffinity`。
- **验证：**相同测试覆盖版本、事件循环、定时器、工作队列、线程和 CPU 亲和性；Golden 业务与测试 HAP 已构建，Native 产物为 x86_64 ELF。
- **边界：**调试签名、模拟器安装和连续三轮测试尚未完成，暂不能表述为设备验收通过。
- **定位：**补齐设备闭环后，转成独立 `test.patch`、`golden.patch` 和正式 Bench 元数据。

### Log4Qt：复杂依赖预研

- **现象：**Log4Qt 依赖 Qt 框架；普通 Windows Qt 不能用于 HarmonyOS 模拟器。
- **前置条件：**需要 Windows 宿主 Qt 工具和 API 23、x86_64 的 Qt for HarmonyOS 目标库。
- **判断：**如果失败原因只是缺少 `Qt6Config.cmake`、`moc` 或目标 Qt 库，只能算环境问题。
- **定位：**先验证最小 Qt Core Demo，再判断是否存在 Log4Qt 自身的稳定 OHOS 源码缺陷。

---

## 四、当前遇到的核心难点

| 核心难点 | 主要影响 | 应对原则 |
| --- | --- | --- |
| 挖掘真实缺陷 | 很多库原样即可编译，调研时间可能高于修复时间 | 固定版本，确认问题可复现、有价值且规模适中 |
| 正确归因与控制 Base | 路径、依赖、SDK、架构等问题容易冒充库兼容缺陷 | 先打通公共工程链路，让 Base 只保留目标问题 |
| Golden 与 Test 可信 | 临时补丁或检查实现细节会降低评测有效性 | Golden 优先采用官方依据；Test 只验证公开行为 |
| 完成设备闭环 | HAP 构建后仍有签名、安装、运行和重复测试工作 | 统一 x86_64 环境，完成模拟器连续三轮验收 |

### 1. 挖掘真实缺陷

很多 C/C++ 库具有较好的 POSIX 兼容性，原始源码就能由 HarmonyOS NDK 编译。因此，调研阶段不能只看项目是否写了“支持 OHOS”，而要实际固定版本、接入工具链并验证。tinyxml2 就属于能够直接构建的情况，它适合作为模板，但目前缺少真实缺陷；libuv 则能在固定版本中稳定暴露线程亲和性问题，更符合 Bench 要求。

### 2. 正确归因并控制 Base

构建失败可能来自源码、CMake 平台识别、外部依赖、SDK、ABI、签名或模拟器状态。Base 必须先解决路径、工程和公共依赖问题，只留下希望被修复的目标缺陷。例如，libuv Base 能进入 `thread.c` 后再因接口缺失失败，属于有效问题；Log4Qt 如果只因为找不到 Qt 而失败，则仍是环境未就绪，不能算 Log4Qt 的鸿蒙适配缺陷。

### 3. 保证 Golden 和 Test 可信

Golden 最好来自官方提交、移植配方或明确的系统 API 替代关系。libuv 使用官方提交 `b807450e`，因此修复依据清晰。Test 则必须独立于修复方案，只验证版本、事件循环、线程和 CPU 亲和性等公开行为，不能检查是否增加 `__OHOS__`、调用某个函数或包含特定提交号。

### 4. 完成构建到设备的闭环

生成 HAP 只是中间结果，完整验收还包括 x86_64 Native 库检查、调试签名、模拟器连接、应用安装、页面运行、ohosTest 执行以及连续三轮结果一致。当前 libuv 已完成业务与测试 HAP 构建，但尚未完成设备侧三轮测试，因此汇报中需要明确区分“构建通过”和“设备验收通过”。

此外，Qt、媒体和图形等大型依赖会进一步放大任务边界。此类候选应先建设统一 SDK 和执行环境，避免单库 Bench 演变成整套生态移植。

---

## 参考资料

- libuv：<https://github.com/libuv/libuv>
- libuv 官方修复提交 `b807450e`：<https://github.com/libuv/libuv/commit/b807450e>
- tinyxml2：<https://github.com/leethomason/tinyxml2>
- OpenHarmony TPC tinyxml2 示例：<https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/tree/master/tinyxml2>
- Log4Qt：<https://github.com/MEONMedical/Log4Qt>
- Qt 6 for HarmonyOS 构建说明：<https://wiki.qt.io/Building_Qt6_for_HarmonyOS>
