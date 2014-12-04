# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyplusplus/pyplusplus-9999.ebuild,v 1.1 2013/12/06 13:35:53 heroxbd Exp $

EAPI=5

inherit R-packages git-r3

DESCRIPTION="Tools for visualising densities"
HOMEPAGE="https://github.com/hadley/densityvis"

EGIT_REPO_URI="https://github.com/hadley/${PN}.git"

LICENSE=MIT
SLOT=0

DEPEND="dev-lang/R"
RDEPEND="${DEPEND}"
