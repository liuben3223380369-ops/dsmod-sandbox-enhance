#!/bin/sh
set -e
apk add --no-cache ca-certificates bash bash-completion coreutils findutils \
  grep sed gawk less file jq which htop tmux vim git openssl sqlite \
  ripgrep fd ncurses-terminfo python3 py3-pip py3-virtualenv
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip install --break-system-packages --no-cache-dir apkid frida-tools || \
  echo "WARN: frida-tools 在 musl/aarch64 可能无 wheel，客户端功能降级"
mkdir -p /opt/jadx && cd /opt/jadx
curl -L --retry 3 -o jadx.zip \
  https://ghfast.top/https://github.com/skylot/jadx/releases/download/v1.5.0/jadx-1.5.0.zip
unzip -o -q jadx.zip -d /opt/jadx
chmod +x /opt/jadx/bin/jadx /opt/jadx/bin/jadx-gui 2>/dev/null || true
ln -sf /opt/jadx/bin/jadx /usr/local/bin/jadx
echo "done"
