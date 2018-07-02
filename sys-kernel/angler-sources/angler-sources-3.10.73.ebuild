# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

ETYPE="sources"
K_DEFCONFIG="sharkbait_angler_defconfig"
K_SECURITY_UNSUPPORTED=1
EXTRAVERSION="-${PN}/-*"
inherit kernel-2
detect_version
detect_arch

inherit git-r3
EGIT_REPO_URI="https://github.com/KireinaHoro/android_kernel_huawei_angler.git -> angler-linux.git"
EGIT_BRANCH="sharkbait"
EGIT_CHECKOUT_DIR="${WORKDIR}/linux-${PV}-angler"

DESCRIPTION="Huawei Nexus 6P kernel sources"
HOMEPAGE="https://github.com/KireinaHoro/android_kernel_huawei_angler"

KEYWORDS="~arm64"

src_unpack() {
	git-r3_src_unpack
	unpack_set_extraversion
}
