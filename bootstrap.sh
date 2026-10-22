#!/bin/sh
# dsmod-sandbox-enhance · Alpine/PRoot aarch64
set -e
apk add --no-cache ca-certificates bash bash-completion coreutils findutils \
  grep sed gawk less file jq which htop tmux vim git openssl sqlite \
  ripgrep fd ncurses-terminfo python3 py3-pip python3-dev py3-virtualenv \
  build-base linux-headers libffi-dev openssl-dev
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip install --break-system-packages --no-cache-dir apkid || true
# frida 在 musl/aarch64 需源码编译，缺 Go>=1.26 / Node>=18，预期失败，不影响其他
pip install --break-system-packages --no-cache-dir frida-tools || \
  echo "WARN: frida 不可用（musl/aarch64 无 wheel），见 README 替代路线"

# jadx
mkdir -p /opt/jadx && cd /opt/jadx
curl -L --retry 3 -o jadx.zip \
  https://ghfast.top/https://github.com/skylot/jadx/releases/download/v1.5.0/jadx-1.5.0.zip
unzip -o -q jadx.zip -d /opt/jadx
chmod +x /opt/jadx/bin/jadx /opt/jadx/bin/jadx-gui 2>/dev/null || true

# 全部工具落 /usr/local/bin，不依赖 PATH
mk() { printf '#!/bin/sh\nexec %s\n' "$1" > "/usr/local/bin/$2"; chmod +x "/usr/local/bin/$2"; }
mk "/opt/jadx/bin/jadx \"\$@\"" jadx
mk "java -jar /opt/dt/jar/apktool.jar \"\$@\"" apktool
mk "java -jar /opt/dt/jar/uber-apk-signer.jar \"\$@\"" uber-apk-signer
mk "java -cp /opt/dt/jar/r8.jar com.android.tools.r8.R8 \"\$@\"" r8
mk "java -cp /opt/dt/jar/r8.jar com.android.tools.r8.D8 \"\$@\"" d8
for t in aapt2 zipalign dexdump; do mk "/opt/dt/bin/$t \"\$@\"" "$t"; done

mkdir -p /etc/profile.d
cat > /etc/profile.d/10-dt.sh <<'P'
export PATH="/opt/dt/bin:/opt/jadx/bin:$PATH"
P
chmod +x /etc/profile.d/10-dt.sh
echo "done"
