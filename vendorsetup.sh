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
python3 vendor/infinix/X6882/patch_undefined_symbols.py || {
  RET=$?
}

if [ $RET -ne 0 ]; then
  echo "ERROR: Patch is not applied! Maybe it's already patched, or you'll have to adapt it to this specific rom source?"
else
  echo "OK: All patched"
fi
