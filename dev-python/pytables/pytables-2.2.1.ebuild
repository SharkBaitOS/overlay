# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pytables/pytables-2.2.1.ebuild,v 1.1 2010/11/05 16:03:39 xarthisius Exp $

EAPI=2

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils

DESCRIPTION="A package for managing hierarchical datasets built on top of the HDF5 library."
HOMEPAGE="http://www.pytables.org/ http://pypi.python.org/pypi/tables"
SRC_URI="http://www.pytables.org/download/stable/tables-${PV}.tar.gz"

SLOT="0"
KEYWORDS="~amd64-linux"
LICENSE="BSD"
IUSE="doc examples"

RDEPEND="
	>=sci-libs/hdf5-1.6.5
	>=dev-python/numpy-1.2.1
	>=dev-python/numexpr-1.4.1
	dev-libs/lzo:2
	app-arch/bzip2"
DEPEND="${RDEPEND}
	>=dev-python/cython-0.12.1"

RESTRICT_PYTHON_ABIS="3.*"

S=${WORKDIR}/tables-${PV}

DOCS="ANNOUNCE.txt MIGRATING_TO_2.x.txt RELEASE_NOTES.txt THANKS"

src_test() {
	testing() {
		PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" tables/tests/test_all.py
	}
	python_execute_function testing
}

src_compile() {
    export HDF5_DIR=${EPREFIX}/usr
    export LZO_DIR=${EPREFIX}/usr
    export BZIP2_DIR=${EPREFIX}/usr
    distutils_src_compile
}

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die
	fi

	if use doc; then
		cd doc

		dohtml -r html/* || die

		docinto text
		dodoc text/* || die

		insinto /usr/share/doc/${PF}
		doins -r usersguide.pdf scripts || die
	fi
}
