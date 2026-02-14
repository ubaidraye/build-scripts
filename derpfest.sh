#!/bin/bash
rm -rf prebuilts/clang/host/linux-x86
rm -rf hardware/motorola
rm -rf device/motorola
rm -rf kernel/motorola
rm -rf vendor/motorola
rm -rf .repo/local_manifests
rm -rf *.zip
rm -rf lineage/scripts

repo init -u https://github.com/DerpFest-AOSP/android_manifest.git -b 16.2 --git-lfs --no-clone-bundle --depth=1
git clone https://github.com/ubaidraye/local_manifests .repo/local_manifests

/opt/crave/resync.sh || repo sync

# apply kernelsu-next
cd kernel/motorola/sm8475
curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" | bash -

#return to roms root
cd ../../..

# clone vendor
git clone https://github.com/themuppets/proprietary_vendor_motorola_eqs vendor/motorola/eqs --depth=1

git clone https://github.com/ubaidraye/proprietary_vendor_motorola_sm8475-common -b lineage-23.2 vendor/motorola/sm8475-common --depth=1

# get A15 Vendor
wget https://mirrors.lolinet.com/firmware/lenomola/2022/eqs/official/RETAIL/EQS_RETAIL_15_V1SQS35H.58-10-8-1_subsidy_DEFAULT_regulatory_DEFAULT_cid50_CFC.xml.zip

unzip EQS_RETAIL_15_V1SQS35H.58-10-8-1*.zip -d device/motorola/eqs/A15-vendor

# extract new vendor
cd device/motorola/eqs; ./setup-makefiles.py; ./extract-files.py A15-vendor
cd ../../..

export BUILD_USERNAME=RayeUB
export BUILD_HOSTNAME=crave
export DISABLE_STUB_VALIDATION=true

. build/envsetup.sh
lunch lineage_eqs-bp4a-userdebug
make installclean
mka derp
