#!/usr/bin/env bash
set -e

# === User-configurable knobs ===
CCACHE_SIZE="${CCACHE_SIZE:-75G}"          # default 75 GB
LINEAGE_BRANCH="${LINEAGE_BRANCH:-lineage-20.0}"
BUILD_TARGET="${BUILD_TARGET:-recoveryimage}" 
# Options: recoveryimage, bootimage, bacon, kernel

# === Setup environment ===
export USE_CCACHE=1
export CCACHE_DIR=/home/circleci/.ccache
ccache -M $CCACHE_SIZE

echo ">>> Building LineageOS $LINEAGE_BRANCH for cannong"
echo ">>> Build target: $BUILD_TARGET"
echo ">>> Ccache size: $CCACHE_SIZE"

# === Initialize repo if not already ===
if [ ! -d ".repo" ]; then
  repo init -u https://github.com/LineageOS/android.git -b $LINEAGE_BRANCH --git-lfs
fi

# === Sync sources ===
repo sync -c --no-tags --no-clone-bundle -j$(nproc) || repo sync -c --no-tags --no-clone-bundle -j1

# === Build ===
source build/envsetup.sh
lunch lineage_cannong-userdebug
make $BUILD_TARGET -j$(nproc)

# === Collect artifacts ===
OUT=out/target/product/cannong
mkdir -p ~/artifacts
case "$BUILD_TARGET" in
  recoveryimage) cp "$OUT/recovery.img" ~/artifacts/ ;;
  bootimage)    cp "$OUT/boot.img" ~/artifacts/ ;;
  bacon)        cp "$OUT/lineage-"*.zip ~/artifacts/ ;;
  kernel)       cp "$OUT/obj/KERNEL_OBJ/arch/arm64/boot/Image.gz-dtb" ~/artifacts/ ;;
esac
