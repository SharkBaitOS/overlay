# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1


DESCRIPTION="MongoDB-backed Python dict-like interface"
HOMEPAGE="https://github.com/turicas/mongodict/"
SRC_URI="mirror://pypi/m/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="dev-python/pymongo"


