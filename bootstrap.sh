#!/bin/sh
# dsmod-sandbox-enhance · Alpine/PRoot aarch64
set -e
apk add --no-cache ca-certificates bash bash-completion coreutils findutils \
  grep sed gawk less file jq which htop tmux vim git openssl sqlite \
  ripgrep fd ncurses-terminfo python3 py3-pip python3-dev py3-virtualenv \
  build-base linux-headers libffi-dev openssl-dev
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip install --break-system-packages --no-cache-dir apkid || true
pip install --break-system-packages --no-cache-dir frida-tools || \
  echo "WARN: frida 需编译，musl/aarch64 可能失败；客户端能力降级"
mkdir -p /opt/jadx && cd /opt/jadx
curl -L --retry 3 -o jadx.zip \
  https://ghfast.top/https://github.com/skylot/jadx/releases/download/v1.5.0/jadx-1.5.0.zip
unzip -o -q jadx.zip -d /opt/jadx
chmod +x /opt/jadx/bin/jadx /opt/jadx/bin/jadx-gui 2>/dev/null || true
ln -sf /opt/jadx/bin/jadx /usr/local/bin/jadx
mkdir -p /etc/profile.d
cat > /etc/profile.d/10-dt.sh <<'P'
export PATH="/opt/dt/bin:/opt/jadx/bin:$PATH"
P
chmod +x /etc/profile.d/10-dt.sh
cat > /usr/local/bin/apktool <<W
#!/bin/sh
exec java -jar /opt/dt/jar/apktool.jar "$@"
W
chmod +x /usr/local/bin/apktool
echo "done"
