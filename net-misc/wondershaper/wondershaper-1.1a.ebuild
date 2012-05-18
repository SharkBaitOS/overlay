# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils

DESCRIPTION="a QoS script"
HOMEPAGE="http://lartc.org/wondershaper"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DEPEND=""
RDEPEND="sys-apps/iproute2"

IUSE="+htb"

src_prepare() {
	epatch "${FILESDIR}/${P}.patch"
	for FILE in rc.skel Makefile append-return-1.awk
	do
	    cp "${FILESDIR}"/${FILE} "${S}"/ || die "copy ${FILE} failed"
	done
	use htb && { cp -f wshaper.htb wshaper || die "copy wshaper.htb failed" ; }
}

src_install() {
	doinitd ${PN}
	newconfd ${PN}.config ${PN}
	dodoc ChangeLog README TODO VERSION
}
