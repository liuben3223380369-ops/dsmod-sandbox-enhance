#!/bin/sh
echo "=== 系统 ==="; uname -m; cat /etc/alpine-release
echo "=== 权限 ==="; grep -E 'CapEff|Seccomp|NoNewPrivs' /proc/self/status
echo "=== 命令 ==="
for c in bash git python3 pip jq rg fd vim tmux htop openssl sqlite3 jadx \
         apktool aapt2 zipalign dexdump java curl wget tree unzip zip; do
  printf '%-10s %s\n' "$c" "$(command -v $c || echo MISSING)"
done
echo "=== python 模块 ==="
python3 -c "import apkid;print('apkid',apkid.__version__)" 2>&1
python3 -c "import frida;print('frida',frida.__version__)" 2>&1
echo "=== 网络 ==="
curl -sS -o /dev/null -w 'tuna %{http_code}\n' https://mirrors.tuna.tsinghua.edu.cn/alpine/
