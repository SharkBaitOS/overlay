# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# media-libs/libjpeg-turbo

EAPI="2"

DESCRIPTION="A high-performance, drop-in libjpeg replacement which uses SIMD instructions (MMX, SSE2, etc.) for x86 and x86-64 processors"
HOMEPAGE="http://libjpeg-turbo.virtualgl.org/"
# http://sourceforge.net/projects/libjpeg-turbo/files/1.0.90%20(1.1beta1)/libjpeg-turbo-1.0.90.tar.gz/download
SRC_URI="mirror://sourceforge/${PN}/${PV}%20%281.1beta1%29/${P}.tar.gz"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
SLOT="0"
LICENSE="as-is LGPL-2.1 wxWinLL-3.1"
RESTRICT="mirror"

# Shouldn't this have a PROVIDE="virtual/jpeg"?

IUSE="static-libs"
RDEPEND="!media-libs/jpeg:0"
DEPEND="${RDEPEND}
		dev-lang/nasm"


MY_S="${S}/build"
MY_S32="${S}/build32"
ECONF_SOURCE="${S}"

src_prepare() {
	mkdir "${MY_S}" "${MY_S32}" || die "Failed to create build dirs"
}

configure32() {
	local CHOST=i686-pc-linux-gnu
	local CBUILD=
	local CFLAGS="${CFLAGS} -m32"
	local CXXFLAGS="${CXXFLAGS} -m32"
	local LDFLAGS="${LDFLAGS} -m32"
	
	cd "${MY_S32}"
	einfo "Configuring 32-bit sources"
	ABI=x86 econf \
		--with-pic \
		--with-jpeg8 \
		--disable-dependency-tracking \
		$(use_enable static-libs static)
	einfo "Configuring 64-bit sources"
}
src_configure() {
	use amd64 && configure32

	cd "${MY_S}"
	econf \
		--with-pic \
		--with-jpeg8 \
		--disable-dependency-tracking \
		$(use_enable static-libs static)
}

src_compile() {
	if use amd64; then
		cd "${MY_S32}"
		einfo "Building 32-bit sources"
		emake
		einfo "Building 64-bit sources"
	fi
	
	cd "${MY_S}"
	emake
}

src_install() {
	if use amd64; then
		cd "${MY_S32}" && \
		emake install-libLTLIBRARIES DESTDIR="${D}" libdir=usr/lib32 \
		|| die "32-bit install failed"
	fi

	cd "${MY_S}"
	emake install DESTDIR="${D}" || die "install failed"
	cd "${S}"
	dodoc BUILDING.txt ChangeLog.txt example.c README-turbo.txt
	find "${D}" -name '*.la' -delete
}
