# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Preinit files for Portage-powered Android systems"
HOMEPAGE="https://github.com/KireinaHoro/preinit"
SRC_URI="https://github.com/KireinaHoro/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~arm64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
sys-apps/busybox[static]
"

src_install() {
	insinto /usr/share/eselect/modules
	doins preinit.eselect
	insinto /usr/lib/preinit/devices
	cd devices
	for a in *; do
		doins -r $a
	done
}

pkg_postinst() {
	device=$(sed -E -n 's/.*androidboot.hardware=(\S*).*/\1/p' /proc/cmdline)
	if [ -d "/usr/lib/preinit/$device" ] ; then
		eselect preinit set $device
		einfo "Preinit files selected for device $device. If this device is not"
		einfo "$device, choose the correct one with \`eselect preinit set <codename>\`."
	else
		if [ -z "$device" ] ; then
			ewarn "We failed to detect the device codename, thus we're unable to select preinit"
			ewarn "files for this device. To manually select, run \`eselect preinit list\` and"
			ewarn "select accordingly."
		else
			ewarn "The device $device is not yet supported by preinit. Create your own initramfs"
			ewarn "and bootimg.cfg according to $HOMEPAGE ,"
			ewarn "place them in /usr/lib/preinit/custom, and then select 'custom' with \`eselect"
			ewarn "preinit set custom\`. Create pull request to add a working device."
		fi
	fi
}
