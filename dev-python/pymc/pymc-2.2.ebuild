# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pytables/pytables-2.2.1.ebuild,v 1.1 2010/11/05 16:03:39 xarthisius Exp $

EAPI=3

PYTHON_DEPEND=2

inherit distutils

DESCRIPTION="Markov Chain Monte Carlo sampling toolkit."
HOMEPAGE="http://code.google.com/p/${PN} http://pypi.python.org/pypi/${PN}"
SRC_URI="http://pypi.python.org/packages/source/p/pymc/${P}.tar.gz"

SLOT=0
KEYWORDS="~amd64-linux ~x86-linux"
LICENSE=AFL

DEPEND="dev-python/setuptools
	dev-python/pytables
	dev-python/numpy
	virtual/blas"

S="${WORKDIR}/${P}"
DISTUTILS_GLOBAL_OPTIONS=( config_fc --fcompiler=gfortran )
