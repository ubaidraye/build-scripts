#!/bin/bash
rm -rf prebuilts/clang
rm -rf lineage/scripts
rm -rf hardware/motorola
rm -rf device/motorola
rm -rf kernel/motorola
rm -rf vendor/motorola
rm -rf .repo/local_manifests

repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 16 -g default,-mips,-darwin,-notdefault
/opt/crave/resync.sh || repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

# clone devicetrees
git clone https://github.com/ubaidraye/android_device_motorola_eqs -b infinity-16 device/motorola/eqs
git clone https://github.com/ubaidraye/android_device_motorola_sm8475-common -b infinity-16 device/motorola/sm8475-common 

# clone kernel
git clone https://github.com/ubaidraye/android_kernel_motorola_sm8475 -b lineage-23.2 kernel/motorola/sm8475
git clone https://github.com/ubaidraye/android_kernel_motorola_sm8475-modules -b lineage-23.2 kernel/motorola/sm8475-modules
git clone https://github.com/ubaidraye/android_kernel_motorola_sm8475-devicetrees -b lineage-23.2 kernel/motorola/sm8475-devicetrees

# clone vendor
git clone https://github.com/ubaidraye/proprietary_vendor_motorola_eqs -b lineage-23.2 vendor/motorola/eqs --depth=1
git clone https://github.com/ubaidraye/proprietary_vendor_motorola_sm8475-common -b lineage-23.2 vendor/motorola/sm8475-common --depth=1

# clone hardware source
git clone https://github.com/lineageos/android_hardware_motorola hardware/motorola
git clone https://github.com/LineageOS/scripts.git lineage/scripts

# apply kernelsu-next
cd kernel/motorola/sm8475
curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" | bash -
cd ../../..

export BUILD_USERNAME=RayeUB
export BUILD_HOSTNAME=crave
export DISABLE_STUB_VALIDATION=true

. build/envsetup.sh
lunch infinity_eqs-userdebug
make installclean
m bacon -j$(nproc --all)
