# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/scipy/scipy-0.13.0.ebuild,v 1.1 2013/10/28 22:42:53 bicatali Exp $

EAPI=5

inherit versionator qt4-r2

DESCRIPTION="a program to plot and analyze data and prepare them for printing"
HOMEPAGE="http://qtgrace.sourceforge.net"

MY_PV=$(replace_all_version_separators '' ${PV})

SRC_URI="mirror://sourceforge/${PN}/${PN}_src_${MY_PV}.zip"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

DEPEND="dev-qt/qtcore
	dev-qt/qtgui
	app-arch/unzip"
RDEPEND="${DEPEND}"
S="${WORKDIR}/qtgrace_src"

src_configure() {
		eqmake4 "${S}"/src/src.pro
}
