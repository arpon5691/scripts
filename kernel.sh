
# Making out directory
mkdir out

# Cloning GCC and CLANG
git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 --depth=1 gcc
git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 --depth=1 gcc32
git clone https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 --depth=1 clang

# Some nigga exports
export KBUILD_BUILD_USER="tesla"
export KBUILD_JOBS="$((`grep -c '^processor' /proc/cpuinfo`))"
export ARCH=arm64 && export SUBARCH=arm64

# Here we go
make O=out clean
make O=out mrproper
make O=out ARCH=arm64 vendor/violet-perf_defconfig
make -j$(nproc --all) O=out ARCH=arm64 CC="$(pwd)/clang/clang-r370808/bin/clang" CLANG_TRIPLE="aarch64-linux-gnu-" CROSS_COMPILE="$(pwd)/gcc/bin/aarch64-linux-android-" CROSS_COMPILE_ARM32="$(pwd)/gcc32/bin/arm-linux-androideabi-" | tee log.log

# Refining the kernel
git clone https://github.com/tesla59/AnyKernel3 zipper
cp out/arch/arm64/boot/Image.gz-dtb zipper
cd zipper
zip -r9 hydrakernel-$(TZ=Asia/Kolkata date +'%Y%m%d-%H%M').zip * -x README.md hydrakernel-$(TZ=Asia/Kolkata date +'%Y%m%d-%H%M').zip

# Uploading will be done later
