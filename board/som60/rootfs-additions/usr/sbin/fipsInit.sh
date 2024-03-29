#!/bin/sh

INIT=/usr/sbin/init

fail() {
	echo -e "\nFIPS Integrity check Failed: $1\n"
	/usr/sbin/reboot -f
}

mount -t proc proc /proc 2>/dev/null
PROC_MOUNT=$?
BOOT_MOUNT=false

read -r cmdline </proc/cmdline
for x in ${cmdline}; do
	case "$x" in
	ubi.block=*)
		KERNEL=/dev/ubi0_$((${x#*,} - 1))
		;;

	root=/dev/mmcblk0p*)
		KERNEL=/boot/kernel.itb
		BOOT_MOUNT=true
		;;

	initlrd=*)
		INIT=${x#initlrd=}
		;;
	esac
done

[ -f /dev/hwrng ] && chmod 644 /dev/hwrng

[ -f /proc/sys/crypto/fips_enabled ] &&
	read -r FIPS_ENABLED </proc/sys/crypto/fips_enabled

if [ "${FIPS_ENABLED}" = "1" ] && [ -n "${KERNEL}" ]; then
	echo "FIPS Integrity check Started"

	mount -o mode=1777,nosuid,nodev -t tmpfs tmpfs /tmp 2>/dev/null && \
		TMP_MOUNT=true || TMP_MOUNT=false

	if ${BOOT_MOUNT}; then
		mkdir -p /boot
		mount -t vfat -o noatime,ro /dev/mmcblk0p1 /boot 2>/dev/null || \
			fail "Cannot mount /boot: $?"
	fi

	[ -f /lib/fipscheck/Image.lzma.hmac ] && IMGTYP=lzma || IMGTYP=gz

	/usr/sbin/dumpimage -T flat_dt -p 0 -o /tmp/Image.${IMGTYP} ${KERNEL} >/dev/null || \
		fail "Cannot extract kernel image error: $?"

	if [ -f /usr/lib/libcrypto.so.1.0.0 ]; then
		FIPSCHECK_DEBUG=stderr /usr/bin/fipscheck /tmp/Image.${IMGTYP} /usr/lib/libcrypto.so.1.0.0 || \
			fail "fipscheck error: $?"
	else
		ossl-fipsload -B
		FIPSCHECK_DEBUG=stderr /usr/bin/fipscheck /tmp/Image.${IMGTYP} /usr/lib/ossl-modules/fips.so || \
			fail "fipscheck error: $?"
	fi

	#shred -zufn 0 /tmp/Image.${IMGTYP}
	rm -f /tmp/Image.${IMGTYP}

	${BOOT_MOUNT} && umount /boot
	${TMP_MOUNT} && umount /tmp

	# trigger kernel crypto gcm self-test
	modprobe tcrypt mode=35 || fail "Boot gcm(aes) test failed: $?"
	modprobe -r tcrypt

	echo "FIPS Integrity check Success"
fi

[ ${PROC_MOUNT} -eq 0 ] && umount /proc

echo "Launching: ${INIT}"

if [ "${INIT#*.}" = "sh" ]; then
	. ${INIT}
else
	exec ${INIT}
fi
