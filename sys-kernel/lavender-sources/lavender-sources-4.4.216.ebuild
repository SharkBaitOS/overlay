# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

ETYPE="sources"
K_DEFCONFIG="sharkbait-lavender_defconfig"
K_SECURITY_UNSUPPORTED=1
EXTRAVERSION="-${PN}/-*"
inherit kernel-2
detect_version
detect_arch

inherit git-r3
EGIT_REPO_URI="https://github.com/WantGuns/android_kernel_xiaomi_lavender-1"
EGIT_BRANCH="lxc"
EGIT_CHECKOUT_DIR="${WORKDIR}/linux-${PV}-lavender"

DESCRIPTION="Xiaomi Redmi Note 7 kernel sources"
HOMEPAGE="https://github.com/WantGuns/android_kernel_xiaomi_lavender"

KEYWORDS="~arm64"

src_unpack() {
	git-r3_src_unpack
	unpack_set_extraversion
}
