# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

GCC_FILESDIR=${PORTDIR}/sys-devel/gcc/files
gcc_LIVE_BRANCH="master"

inherit multilib toolchain

DESCRIPTION="The GNU Compiler Collection."
SRC_URI=""

LICENSE="GPL-3 LGPL-3 || ( GPL-3 libgcc libstdc++ gcc-runtime-library-exception-3.1 ) FDL-1.2"
KEYWORDS=""

SLOT="${GCC_BRANCH_VER}-vcs"
IUSE="debug nobootstrap offline"

RDEPEND=""
DEPEND="${RDEPEND}
	amd64? ( multilib? ( gcj? ( app-emulation/emul-linux-x86-xlibs ) ) )
	>=${CATEGORY}/binutils-2.18"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.12 )"
fi

src_unpack() {
	# use the offline USE flag to prevent the ebuild from trying to update from
	# the repo.  the current sources will be used instead.
	use offline && EVCS_OFFLINE="yes"

	toolchain_src_unpack

	echo "commit ${EGIT_VERSION}" > "${S}"/gcc/REVISION

	# drop-in patches
	if ! use vanilla ; then
		if [[ -e ${FILESDIR}/${GCC_RELEASE_VER} ]]; then
			EPATCH_SOURCE="${FILESDIR}/${GCC_RELEASE_VER}" \
			EPATCH_EXCLUDE="${FILESDIR}/${GCC_RELEASE_VER}/exclude" \
			EPATCH_FORCE="yes" EPATCH_SUFFIX="patch" epatch \
			|| die "Failed during patching."
		fi
	fi

	[[ ${CHOST} == ${CTARGET} ]] && epatch "${GCC_FILESDIR}"/gcc-spec-env.patch

	use debug && GCC_CHECKS_LIST="yes"

	epatch "${FILESDIR}/gcc-4.9-extra-specs.patch"

	# single-stage build for quick patch testing
	if use nobootstrap; then
		GCC_MAKE_TARGET="all"
		EXTRA_ECONF+=" --disable-bootstrap"
	fi
}

pkg_postinst() {
	toolchain_pkg_postinst
	echo
	einfo "This gcc-4 ebuild is provided for your convenience, and the use"
	einfo "of this compiler is not supported by the Gentoo Developers."
	einfo "Please file bugs related to gcc-4 with upstream developers."
	einfo "Compiler bugs should be filed at http://gcc.gnu.org/bugzilla/"
	echo
}
