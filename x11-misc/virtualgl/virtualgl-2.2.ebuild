# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# x11-misc/virtualgl

EAPI="2"

inherit flag-o-matic

DESCRIPTION="Run OpenGL applications on remote display software with full 3D hardware acceleration"
HOMEPAGE="http://www.virtualgl.org/"
SRC_URI="mirror://sourceforge/${PN}/VirtualGL/${PV}/VirtualGL-${PV}.tar.gz"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
SLOT="0"
LICENSE="LGPL-2.1 wxWinLL-3.1"
RESTRICT="mirror"

IUSE=""
# IUSE="ssl"

RDEPEND="media-libs/libjpeg-turbo[static-libs]
         x11-libs/libX11
		 x11-libs/libXext
		 x11-libs/libXau
		 media-libs/mesa"
#         ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/vgl"

src_prepare() {
	# Change /usr/doc -> /usr/share/doc
	sed -i -e 's:docdir=$(prefix):docdir=$(prefix)/share:' Makefile

	sed -ie 's,-L/usr,-L${EPREFIX}/usr,g' Makerules.linux
	# Add zlib to ssl build (this should be conditional on dev-libs/openssl[+zlib])
#	has_version 'dev-libs/openssl[zlib]' || sed -i -e 's/-lcrypto -Wl,-Bdynamic/-lcrypto -Wl,-Bdynamic -lz/' Makerules.linux
}

src_compile() {
	# For some reason, it creates build-time symlinks to /usr/lib/gcc/ARCH/VERSION/{,32}/libstdc++.a
	addpredict /usr/lib/gcc
	append-ldflags -fpic,-Wall
	append-flags -fpic -Wall
	
	emake LJTLIB=${EPREFIX}/usr/lib  # $(use ssl && echo "USESSL=yes SSLINC=/usr/include/openssl SSLLIB=/usr/lib")
	use amd64 && emake M32=yes LJTLIB=${EPREFIX}/usr/lib32
}

src_install() {
	emake install $(use amd64 && echo LJTDIR=${EPREFIX}/usr || echo LJTLIB=${EPREFIX}/usr/lib) prefix="${ED}"/usr || die "installation failed"	
	dodoc BUILDING.txt
	# /usr/bin/glxinfo conflicts with x11-misc/mesa-progs
	# alternatively, we could rename this "vglxinfo" or something
	rm "${D}/usr/bin/glxinfo"
	
	# (could set up vglusers group and/or run vglserver_config if reasonable defaults exist)
}