# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/debootstrap/debootstrap-1.0.38.ebuild,v 1.1 2011/11/21 19:46:55 jer Exp $

inherit eutils

DESCRIPTION="Debian/Ubuntu bootstrap scripts"
HOMEPAGE="http://packages.qa.debian.org/d/debootstrap.html"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${PV}.tar.gz
	mirror://gentoo/devices.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86-linux"
IUSE=""

RDEPEND="sys-devel/binutils
	net-misc/wget
	>=app-arch/dpkg-1.14.20"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${PN}_${PV}.tar.gz
	cp "${DISTDIR}"/devices.tar.gz "${S}"
}

src_compile() {
	return
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc TODO debian/changelog
	doman debootstrap.8
}

pkg_postinst() {
	elog "To check Release files against a keyring"
	elog " (--keyring=K), please install app-crypt/gnupg."
}
