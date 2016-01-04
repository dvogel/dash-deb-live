#!/usr/bin/env bash

set -o nounset

TARGETPATH="$TARGETPATH"
EFIPATH="$EFIPATH"


cd "${TARGETPATH}/boot"
for f in $(ls -1 vmlinuz-*); do
    kernel_version_tag="${f##vmlinuz-}"
done

if [[ "${kernel_version_tag}" == "" ]]; then
    echo "No kernel found in ${TARGETPATH}/boot"
    echo "Be sure there is a kernel package installed."
    exit
fi

# Generate a initrd image that includes the USB disk modules required to boot
# from USB.
chroot "${TARGETPATH}" /usr/sbin/update-initramfs -c -k "${kernel_version_tag}" -v

# Copy the kernel, system map, config, and initrd image over to the EFI
# partition and rename them to remove the version so that we don't have to
# regenerate the syslinux.cfg file.
for f in $(ls -1 *-"${kernel_version_tag}"); do
    dstfile="${f%%-${kernel_version_tag}}"
    cp -v "${f}" "${EFIPATH}/EFI/SYSLINUX/${dstfile}"
done
