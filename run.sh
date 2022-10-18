#!/bin/bash
echo no | avdmanager create avd -f -n generic_10  --device "pixel_5" --abi $ABIS/x86_64  -k "system-images;$ANDROID;$ABIS;x86_64"
emulator -avd generic_10 -noaudio -skip-adb-auth -memory 2048 -no-snapshot -wipe-data -no-snapshot-save -verbose -nocache -accel on -engine qemu2 -qemu -enable-kvm -cpu host -m 2G
