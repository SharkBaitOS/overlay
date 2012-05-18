# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/crossdev/crossdev-20100108.ebuild,v 1.1 2010/01/08 10:52:54 vapier Exp $

EAPI="3"

SRC_URI="mirror://gentoo/${P}.tar.lzma
	http://dev.gentoo.org/~vapier/dist/${P}.tar.lzma"

KEYWORDS="~x86-linux"

DESCRIPTION="Gentoo Cross-toolchain generator"
HOMEPAGE="http://www.gentoo.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND=">=sys-apps/portage-2.1
	app-shells/bash
	!sys-devel/crossdev-wrappers"
DEPEND=""

src_prepare() {
	sed -i -e 's,/etc,${EPREFIX}/etc,' \
	       -e 's,/var,${EPREFIX}/var,' \
	       -e's,/usr,${EPREFIX}/usr,' ${S}/crossdev
}

src_install() {
	emake install DESTDIR="${ED}" || die
}
