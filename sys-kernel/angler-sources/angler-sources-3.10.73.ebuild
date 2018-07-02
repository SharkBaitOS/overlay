# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
UNIPATCH_STRICTORDER="yes"
K_NOUSENAME="yes"
K_NOSETEXTRAVERSION="yes"
K_NOUSEPR="yes"
K_SECURITY_UNSUPPORTED="1"
K_BASE_VER="3.10"
K_EXP_GENPATCHES_NOUSE="1"
K_FROM_GIT="yes"
ETYPE="sources"
CKV="${PVR/-r/-git}"

# only use this if it's not an _rc/_pre release
[ "${PV/_pre}" == "${PV}" ] && [ "${PV/_rc}" == "${PV}" ] && OKV="${PV}"
inherit git-r3 kernel-2
detect_version

DESCRIPTION="Device-specific kernel sources from AOSP project adapted for Gentoo"
HOMEPAGE="https://www.kernel.org"
EGIT_REPO_URI="https://github.com/KireinaHoro/android_kernel_huawei_angler"

KEYWORDS="~arm64"
IUSE=""

RDEPEND="
sys-kernel/installkernel
"
DEPEND="${RDEPEND}
	>=sys-devel/patch-2.7.5"

pkg_postinst() {
	postinst_sources
}
