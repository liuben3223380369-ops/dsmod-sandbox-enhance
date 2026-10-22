# dsmod-sandbox-enhance

把「只有 BusyBox」的 Alpine/PRoot 容器补成可用的 Android 逆向工作台。
环境：aarch64 · Alpine 3.20 · uid=0（PRoot 假 root）· 无真内核权限。

## 已增强（实测通过）
| 类别 | 内容 |
|---|---|
| Shell | bash 5.2 + bash-completion，`SHELL` 可切 |
| 核心命令 | GNU coreutils / findutils / grep / sed / gawk（修掉 BusyBox 不支持 `rm -rf`、`grep --include`） |
| 检索 | ripgrep `rg`、fd、tree、file、jq |
| 编辑/多任务 | vim、tmux、less、htop |
| 版本管理 | git 2.45 |
| 密码学/数据 | openssl、sqlite3 |
| 语言 | python3 3.12 + pip（tuna 源） |
| 反编译 | jadx 1.5.0（`/opt/jadx`）、apktool 2.9.3（wrapper） |
| 打包 | aapt2 / zipalign / dexdump（`/opt/dt/bin`，已加入 PATH） |
| APK 侦察 | apkid 3.2.0（yara 规则识别加固壳） |

## 不可用（PRoot 硬限制，非配置问题）
| 项 | 原因 | 证据 |
|---|---|---|
| frida-server 本机注入 | 需 `ptrace`，PRoot 不透传 | `CapEff: 0` |
| frida python 绑定 | musl/aarch64 无 wheel，源码编译 meson 失败 | `Failed building wheel for frida` |
| strace / gdb attach | 同上 ptrace | — |
| 改 /system、内核模块、iptables | 无 capability | `CapEff: 0000000000000000` |
| 完整进程列表 | `hidepid=invisible` | `/proc` mount opts |

### frida 替代路线
- 真机有 root：PC 侧跑 `frida` + 目标机跑 `frida-server`
- 无 root：LSPatch 打补丁，或 `frida-gadget` 塞进 APK 的 lib
- 远程：容器内只需 `frida-tools` 客户端即可连远端设备，但本环境装不上；在 PC 侧装即可

## 用法
    sh bootstrap.sh     # 一键装齐（约 5 分钟，含 jadx 100 MB 下载）
    sh verify.sh        # 逐项自检，输出 MISSING 项

## 镜像
- Alpine: `mirrors.tuna.tsinghua.edu.cn/alpine/v3.20`
- PyPI:   `pypi.tuna.tsinghua.edu.cn/simple`
- GitHub: `ghfast.top` 前缀加速

## PATH
`/etc/profile.d/10-dt.sh` 已写入 `/opt/dt/bin:/opt/jadx/bin`，新 shell 自动生效；
当前 shell 执行 `. /etc/profile.d/10-dt.sh`。

## 命令落地方式（重要）
所有工具都是 `/usr/local/bin/` 下的 sh wrapper，**不依赖 PATH 是否加载 profile**。
即使 `env -i sh -c 'command -v aapt2'` 也能找到。
