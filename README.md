# dsmod-sandbox-enhance

Alpine / PRoot 沙箱终端增强基线（aarch64 · uid=0 · 无真 root）。
目标：把「只带 BusyBox」的容器补成可用逆向工作台。

## 能增强
bash5 / GNU coreutils / findutils / grep / sed / gawk / rg / fd / jq / file / less / vim / tmux / htop / git / openssl / sqlite3 / python3+pip / jadx 1.5.0

## 不可增强（PRoot 硬限制）
- `ptrace`（frida-server 本机注入、gdb attach、strace）
- `CapEff=0`（改 /system、内核模块、iptables）
- `Seccomp: 2` + 1 filter

## 用法
    sh bootstrap.sh      # 装第一档 + python + jadx
    sh verify.sh         # 逐项自检

## 镜像
- alpine: mirrors.tuna.tsinghua.edu.cn/alpine/v3.20
- pypi:   pypi.tuna.tsinghua.edu.cn/simple
- github: ghfast.top 前缀
