# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit distutils

DESCRIPTION="MyHDL is a Python package for using Python as a hardware description and verification language."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

RESTRICT="nomirror"
HOMEPAGE="http://www.myhdl.org/"
RDEPEND="virtual/python"
IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86-linux"
LICENSE="LPGL-2.1"

src_install() {
	distutils_src_install
	dodoc *.txt
	cp -r doc/* example cosimulation ${D}/usr/share/doc/${PF}
}

