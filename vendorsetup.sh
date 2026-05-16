#!/bin/bash

RET=0
echo "- Applying Aperture Mediatek HFPS Mode"
cd packages/apps/Aperture
curl https://raw.githubusercontent.com/gutssnv/patches/refs/heads/sixteen/packages/apps/Aperture/0001-Aperture-Enable-MediaTek-HFPS-Mode-for-60-FPS-video-.patch | git am || {
  RET=$?
  git am --abort >/dev/null 2>&1
}
cd ../../../
echo "- Applying WPA3 Patch"
cd external/wpa_supplicant_8
curl https://raw.githubusercontent.com/gutssnv/patches/refs/heads/sixteen/external/wpa_supplicant_8/do_not_set_NL80211_WPA_VERSION_3.patch | git am || {
  RET=$?
  git am --abort >/dev/null 2>&1
}
cd ../../

echo "- Applying vendor prebuilt symbol fix"
python3 - <<'EOF'
import re
from pathlib import Path

TARGET_LIBS = {"libsegmention", "libvideofilmeffect"}
bp = Path("vendor/infinix/X6882/Android.bp")

if not bp.exists():
    print(f"  [ERROR] {bp} not found"); exit(1)

content = bp.read_text()
original = content

def patch_block(m):
    block = m.group(0)
    nm = re.search(r'name:\s*"([^"]+)"', block)
    if not nm or nm.group(1) not in TARGET_LIBS: return block
    if "allow_undefined_symbols" in block: print(f"  [SKIP] {nm.group(1)}"); return block
    print(f"  [PATCH] {nm.group(1)} ✓")
    return re.sub(r'(name:\s*"' + re.escape(nm.group(1)) + r'",?\s*\n)', r'\1    allow_undefined_symbols: true,\n', block)

patched = re.compile(r'cc_prebuilt_library_shared\s*\{[^}]*(?:\{[^}]*\}[^}]*)?\}', re.DOTALL).sub(patch_block, content)
if patched == original: print("  [INFO] No changes needed")
else: bp.write_text(patched); print(f"  [DONE] {bp} patched")
EOF
RET=$?

if [ $RET -ne 0 ]; then
  echo "ERROR: Patch is not applied! Maybe it's already patched, or you'll have to adapt it to this specific rom source?"
else
  echo "OK: All patched"
fi
