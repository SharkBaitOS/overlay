# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools flag-o-matic

DESCRIPTION="A FUSE filesystem that provides POSIX functionality for filesystems that do not have such."
HOMEPAGE="http://sourceforge.net/projects/posixovl"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.xz"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~x86"
SLOT=0
IUSE="static"
RDEPEND=">=sys-fs/fuse-2.6.5
	sys-apps/attr"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}"

src_prepare () {
	if use static; then
		append-flags -static
		# libfuse.a calls dlopen
		append-libs dl
	fi

	eautoreconf
}
