# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

ETYPE="headers"
H_SUPPORTEDARCH="arm64"
inherit kernel-2
detect_version
detect_arch

inherit git-r3
EGIT_REPO_URI="https://github.com/WantGuns/android_kernel_xiaomi_sdm660"
EGIT_BRANCH="sharkbait"
EGIT_CHECKOUT_DIR="${WORKDIR}/linux-${PV}"

KEYWORDS="~arm64"

DEPEND="app-arch/xz-utils
	dev-lang/perl"
RDEPEND="!!media-sound/alsa-headers"

src_unpack() {
	git-r3_src_unpack
	unpack_set_extraversion
}

src_install() {
	kernel-2_src_install

	find "${ED}" '(' -iname '.install' -o -name '*.cmd' ')' -delete
	find "${ED}" -depth -type d -delete 2>/dev/null
}

src_test() {
	# Make sure no uapi/ include paths are used by accident.
	egrep -r \
		-e '# *include.*["<]uapi/' \
		"${D}" && die "#include uapi/xxx detected"

	einfo "Possible unescaped attribute/type usage"
	egrep -r \
		-e '(^|[[:space:](])(asm|volatile|inline)[[:space:](]' \
		-e '\<([us](8|16|32|64))\>' \
		.

	einfo "Missing linux/types.h include"
	egrep -l -r -e '__[us](8|16|32|64)' "${ED}" | xargs grep -L linux/types.h

	emake ARCH=$(tc-arch-kernel) headers_check
}
