//original script by psy_man , no credits belong to me
//if you are editing this,remember to change defconfig!

KERNEL_DIR=$PWD
$DEVICENAME="mido"
ANYKERNEL_DIR=$KERNEL_DIR/AnyKernel2
DTBTOOL=$KERNEL_DIR/dtbTool
CCACHEDIR=../CCACHE/scorpio
TOOLCHAINDIR=~/toolchain/aarch64-linux-android-5.3
DATE=$(date +"%d%m%Y")
KERNEL_NAME="Lasagna-Kernel"
DEVICE="-mido-"
VER="-v0.1-"
TYPE="Oreo"
FINAL_ZIP="$KERNEL_NAME""$DEVICE""$DATE""$VER""$TYPE".zip

rm -rf $ANYKERNEL_DIR/$DEVICENAME/*.ko && rm $ANYKERNEL_DIR/$DEVICENAME/zImage $ANYKERNEL_DIR/$DEVICENAME/dtb
rm $KERNEL_DIR/arch/arm64/boot/Image.gz $KERNEL_DIR/arch/arm64/boot/dt.img $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb

if [ ! -d "$TOOLCHAINDIR" ]; then
  mkdir ~/toolchain
  wget https://bitbucket.org/UBERTC/aarch64-linux-android-5.3-kernel/get/1144fd2773c1.zip -P ~/toolchain
  unzip ~/toolchain/1144fd2773c1.zip -d ~/toolchain
  mv ~/toolchain/UBERTC-aarch64-linux-android-5.3-kernel-1144fd2773c1 ~/toolchain/aarch64-linux-android-5.3
  rm ~/toolchain/1144fd2773c1.zip
fi

export ARCH=arm64
export KBUILD_BUILD_USER="ANDR-oid"
export KBUILD_BUILD_HOST="PastaMachine"
export CROSS_COMPILE=$TOOLCHAINDIR/bin/aarch64-linux-android-
export LD_LIBRARY_PATH=$TOOLCHAINDIR/lib/
export USE_CCACHE=1
export CCACHE_DIR=$CCACHEDIR/.ccache

make clean && make mrproper
make mido_defconfig
make -j$( nproc --all )

./dtbTool -s 2048 -o arch/arm64/boot/dt.img -p scripts/dtc/ arch/arm/boot/dts/qcom/
cp $KERNEL_DIR/arch/arm64/boot/dt.img $ANYKERNEL_DIR/$DEVICENAME/dtb
cp $KERNEL_DIR/arch/arm64/boot/Image.gz $ANYKERNEL_DIR/$DEVICENAME/zImage
cp $KERNEL_DIR/drivers/staging/qcacld-2.0/wlan.ko $ANYKERNEL_DIR/$DEVICENAME/
cp $KERNEL_DIR/drivers/char/hw_random/msm_rng.ko $ANYKERNEL_DIR/$DEVICENAME/
cp $KERNEL_DIR/drivers/char/hw_random/rng-core.ko $ANYKERNEL_DIR/$DEVICENAME/
cp $KERNEL_DIR/drivers/char/rdbg.ko $ANYKERNEL_DIR/$DEVICENAME/
cp $KERNEL_DIR/drivers/spi/spidev.ko $ANYKERNEL_DIR/$DEVICENAME/
cp $KERNEL_DIR/drivers/input/evbug.ko $ANYKERNEL_DIR/$DEVICENAME/
cp $KERNEL_DIR/crypto/ansi_cprng.ko $ANYKERNEL_DIR/$DEVICENAME/
cp $KERNEL_DIR/drivers/mmc/card/mmc_test.ko $ANYKERNEL_DIR/$DEVICENAME/
cp $KERNEL_DIR/drivers/video/backlight/lcd.ko $ANYKERNEL_DIR/$DEVICENAME/
cp $KERNEL_DIR/drivers/video/backlight/backlight.ko $ANYKERNEL_DIR/$DEVICENAME/
cp $KERNEL_DIR/drivers/video/backlight/generic_bl.ko $ANYKERNEL_DIR/$DEVICENAME/
cd $ANYKERNEL_DIR/$DEVICENAME
zip -r9 $FINAL_ZIP * -x *.zip $FINAL_ZIP
