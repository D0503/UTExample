# libuv Golden Demo

这是已适配 HarmonyOS 的可运行工程。它包含 libuv `v1.50.0` 完整源码，并采用官方提交
`b807450e` 的修复语义：在 OHOS 上使用 `pthread_gettid_np` 配合
`sched_setaffinity` / `sched_getaffinity`。

页面及 ohosTest 验证版本、事件循环、定时器、工作队列、线程和 CPU 亲和性。构建、安装和
预期结果见上级目录的 `README.md`。
