#!/bin/bash
# set -x  # debug
# set -e  # error

echo " (?) Check Podfile.lock"
echo " (?) podfile_lock_path: $podfile_lock_path"
echo " (?) maifest_lock_path: $maifest_lock_path"

envman add --key PODS_OUT_OF_SYNC --value 'true'

if [ ! -s "${podfile_lock_path}" ]; then
    echo " [!] No file found at path '${podfile_lock_path}'"
    echo " [!] Expected to find Podfile.lock"
    echo " [!] Exiting"
    exit 0
fi
if [ ! -s "${maifest_lock_path}" ]; then
    echo " [!] No file found at path '${maifest_lock_path}'"
    echo " [!] Expected to find Manifest.lock"
    echo " [!] Exiting"
    exit 0
fi

diff "${podfile_lock_path}" "${maifest_lock_path}" > /dev/null
if [ $? != 0 ] ; then
    echo " [!] The sandbox is not in sync with the Podfile.lock. Run 'pod install' or update your CocoaPods installation."
    echo " [!] Exiting"
    exit 0
fi

echo " (?) SUCCESS"
echo " (?) Pods are in sync, can skip 'pod install'"

envman add --key PODS_OUT_OF_SYNC --value 'false'

echo " (?) env get PODS_OUT_OF_SYNC: ${PODS_OUT_OF_SYNC}"
