# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pytables/pytables-2.2.1.ebuild,v 1.1 2010/11/05 16:03:39 xarthisius Exp $

EAPI="3"

PYTHON_DEPEND="2"

inherit distutils eutils git

EGIT_REPO_URI="http://github.com/pymc-devs/pymc.git"
DESCRIPTION="Markov chain Monte Carlo for Python."
HOMEPAGE="http://code.google.com/p/${PN} http://pypi.python.org/pypi/${PN}"

SLOT="0"
KEYWORDS="~amd64-linux ~x86-linux"
LICENSE="MIT"

DEPEND="
	dev-python/pytables
	dev-python/numpy
"

S="${WORKDIR}/${PV}"
DISTUTILS_GLOBAL_OPTIONS=("config_fc" "--fcompiler=gfortran")

src_compile() {
        distutils_src_compile
}