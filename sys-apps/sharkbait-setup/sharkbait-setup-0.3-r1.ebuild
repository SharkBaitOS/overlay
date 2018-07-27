# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="First setup for SharkBait systems"
HOMEPAGE="https://github.com/KireinaHoro/sharkbait-setup"
SRC_URI="https://github.com/KireinaHoro/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~arm64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
>=app-emulation/lxc-3.0.0
"

src_install() {
	exec_list=(
	deploy.sh
	pre-start.sh
	post-stop.sh
	)
	target="${EPREFIX}"/usr/lib/sharkbait-setup
	insinto	"${target}"
	exeinto	"${target}"
	for a in config devices; do
		doins -r "${a}"
	done
	for a in "${exec_list[@]}"; do
		doexe "${a}"
	done
	dosym "${target}"/deploy.sh "${EPREFIX}"/usr/bin/sharkbait-deploy
}

pkg_postinst() {
	device=$(sed -E -n 's/.*androidboot.hardware=(\S*).*/\1/p' /proc/cmdline)
	if [ -d "${EPREFIX}/usr/lib/sharkbait-setup/devices/${device}" ] ; then
		einfo "Run \`sharkbait-deploy ${device}\` to setup SharkBait for your device."
	else
		if [ -z "$device" ] ; then
			ewarn "We failed to detect the device name."
		else
			ewarn "The device $device is not yet supported by sharkbait-setup."
		fi
		ewarn "Consult Porter's guide for how to add support for this device."
	fi
}
