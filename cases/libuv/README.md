# libuv HarmonyOS Base / Golden demos

这两个工程均固定携带 libuv `v1.50.0` 完整源码，互不共享文件，可分别用 DevEco Studio 打开。

| 工程 | bundleName | 预期 |
| --- | --- | --- |
| `libuv-base-demo` | `com.thirdparty.validation.libuv.base` | 在 `library/src/unix/thread.c` 的 `pthread_setaffinity_np` / `pthread_getaffinity_np` 处编译失败 |
| `libuv-golden-demo` | `com.thirdparty.validation.libuv.golden` | 编译业务 HAP 和 ohosTest HAP；页面及测试全部通过 |

## 差异与修复原理

两个工程都只增加了让 libuv CMake 将 `OHOS` 识别成 Linux 兼容平台的必要配置。Base 保留上游
`v1.50.0` 的线程亲和性实现，因此会调用 HarmonyOS SDK 未声明的两个 `pthread_*affinity_np`
接口。Golden 按 libuv 官方提交 `b807450e` 的方式，将 `__OHOS__` 与 Android 放在同一分支，
通过 `pthread_gettid_np()` 获得线程 ID，再调用 `sched_setaffinity()` /
`sched_getaffinity()`。

亲和性测试先读取当前线程允许使用的 CPU 集合，从中选择第一个可用 CPU，完成设置、读回和
恢复。它不假设 CPU 0 可用，也不要求模拟器至少有两个 CPU。

## 构建

在任一工程根目录运行：

```powershell
& 'E:\DevEco Studio\tools\ohpm\bin\ohpm.bat' install --all

& 'E:\DevEco Studio\tools\node\node.exe' `
  'E:\DevEco Studio\tools\hvigor\bin\hvigorw.js' clean --no-daemon

& 'E:\DevEco Studio\tools\node\node.exe' `
  'E:\DevEco Studio\tools\hvigor\bin\hvigorw.js' `
  --mode module -p product=default -p module=entry@default -p buildMode=debug `
  assembleHap --no-daemon

& 'E:\DevEco Studio\tools\node\node.exe' `
  'E:\DevEco Studio\tools\hvigor\bin\hvigorw.js' `
  --mode module -p product=default -p module=entry@ohosTest -p buildMode=debug `
  assembleHap --no-daemon
```

工程目标为 HarmonyOS 6.1 / API 23，设备类型 `2in1`，Native ABI 仅 `x86_64`。
OHPM 安装的 Hypium/Hamock 只用于测试开发；libuv 不使用在线运行时依赖。

## 安装与运行

先在 DevEco Studio 启动 x86_64 MateBook Pro / 2in1 模拟器。签名后，可用 DevEco Studio
直接运行；也可对实际生成的 HAP 执行：

```powershell
& 'E:\DevEco Studio\sdk\default\openharmony\toolchains\hdc.exe' install -r <业务HAP>
& 'E:\DevEco Studio\sdk\default\openharmony\toolchains\hdc.exe' install -r <ohosTest-HAP>
```

Golden 页面应显示 libuv `1.50.0`、`PASS`，并列出事件循环、定时器、工作队列、线程和
CPU 亲和性。ohosTest 包含 Load、Core、Affinity 三组测试。
