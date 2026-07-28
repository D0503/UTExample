# libuv Base Demo

这是未适配 HarmonyOS 线程亲和性接口的故障复现工程。它包含 libuv `v1.50.0` 完整源码，
CMake 已能正确进入 OHOS/Linux 平台源码，但 `thread.c` 仍调用
`pthread_setaffinity_np` / `pthread_getaffinity_np`。因此预期结果是针对这两个接口的
编译错误，而不是路径、依赖或 CMake 配置错误。

构建、测试与 Golden 对照说明见上级目录的 `README.md`。
