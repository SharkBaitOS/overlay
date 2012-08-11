# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/geant-python/geant-python-4.9.5.ebuild,v 1.2 2012/05/21 04:49:12 heroxbd Exp $

EAPI=4

inherit python versionator

MYP="geant$(replace_version_separator 3 .)"

DESCRIPTION="this ebuild is only for geant4.9.3 on teena"
HOMEPAGE="http://geant4.cern.ch/"
# SRC_URI="http://geant4.cern.ch/support/source/${MYP}.tar.gz"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="geant4"
SLOT="0"
IUSE="examples"

RDEPEND="=sci-physics/geant-${PV}* \
	dev-libs/boost[python]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYP}/environments/g4py"

src_unpack() { 
	mkdir -p "${S}"
	cp -a ${G4INSTALL}/environments/g4py/* "${S}"/
}

src_prepare() {
	# DISTDIR and python path patch
	epatch "${FILESDIR}"/${P}-build.patch

	# fix the visManager wrapper
	epatch "${FILESDIR}"/${PN}-4.9.5-vis-fix.patch
	epatch "${FILESDIR}"/${P}-VisAtt.patch
}

src_configure() {
	case ${CHOST} in
		x86_64-pc-linux-gnu)
			ARG=linux64
			;;
		i?86-pc-linux-gnu)
			ARG=linux
			;;
		*)
			die "platform unknown"
			;;
	esac

	./configure ${ARG} \
		--prefix="${EPREFIX}/usr" \
		--libdir="${ED}/$(python_get_sitedir)" \
		--with-g4-incdir="${G4INSTALL}/include/Geant4" \
		--with-g4-libdir="${G4INSTALL}/lib/Linux-g++" \
		--with-clhep-incdir="${EPREFIX}/usr/include" \
		--with-clhep-libdir="${EPREFIX}/usr/lib" \
		--with-python-incdir="${EPREFIX}$(python_get_includedir)" \
		--with-python-libdir="${EPREFIX}$(python_get_libdir)" \
		--with-boost-incdir="${EPREFIX}/usr/include" \
		--with-boost-libdir="${EPREFIX}/usr/lib" \
	|| die "configure failed"
}

src_install() {
	emake DESTDIR="${ED}" install
	insinto /usr/share/doc/${PF}
	dodoc 00README History AUTHORS
	use examples && doins -r examples
}
