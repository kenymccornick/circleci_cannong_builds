# Automated LineageOS build pipeline for Redmi Note 9T using CircleCI

This repo contains:
- `.circleci/config.yml` → CircleCI job definition
- `build.sh` → build helper script
- `.repo/local_manifests/roomservice.xml` → static manifest for device, vendor, and kernel trees

## 🚀 Usage

1. Fork this repo and adjust `roomservice.xml` to point to your own forks of:
   - `android_device_xiaomi_cannon`
   - `android_vendor_xiaomi_cannon`
   - `android_kernel_xiaomi_cannon`

2. Push changes to GitHub. CircleCI will automatically trigger a build.

3. Artifacts (e.g. `recovery.img`, `boot.img`, or full `lineage-*.zip`) will be available in the **Artifacts** tab of CircleCI.

## 🔧 Build Options

You can control the build with environment variables in CircleCI:

- `LINEAGE_BRANCH` → defaults to `lineage-20.0`
- `BUILD_TARGET` → one of `recoveryimage`, `bootimage`, `bacon`, `kernel`
- `CCACHE_SIZE` → defaults to `75G`

Example: set `BUILD_TARGET=bacon` in CircleCI to produce a flashable ROM zip.

## 📂 Output

Artifacts are copied to `~/artifacts` inside the CircleCI job and exposed in the CircleCI UI.

## 📜 License

MIT
