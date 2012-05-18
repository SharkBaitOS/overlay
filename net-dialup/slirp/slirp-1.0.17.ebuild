# Copyright 1999-2010 Tiziano MÃ¼ller
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

DESCRIPTION="TCP/IP emulator which turns an ordinary shell account into a (C)SLIP/PPP account."
HOMEPAGE="http://packages.qa.debian.org/s/slirp.html"
SRC_URI="mirror://debian/pool/main/s/${PN}/${PN}_1.0.17.orig.tar.gz
        mirror://debian/pool/main/s/${PN}/${PN}_1.0.17-4.debian.tar.gz"

LICENSE="NEWLIB"
SLOT="0"
KEYWORDS="~amd64-linux"
IUSE="+ppp"

DEPEND=""
RDEPEND=""

src_prepare() {

    epatch \
	"${WORKDIR}/debian/patches/001-update-man-fix-hyphens-as-minus.patch" \
	"${WORKDIR}/debian/patches/002-fix-arguements.patch" \
	"${WORKDIR}/debian/patches/003-socklen_t.patch" \
	"${WORKDIR}/debian/patches/004-compilation-warnings.patch" \
	"${WORKDIR}/debian/patches/005-use-snprintf.patch" \
	"${WORKDIR}/debian/patches/006-changelog-1.0.17.patch" \
	"${WORKDIR}/debian/patches/007-debian-changes.patch" \
	"${WORKDIR}/debian/patches/008-slirp-amd64-log-crash.patch"

    # We do not need extra src subdir
    mv src/* ./ && rmdir src

    epatch \
	"${FILESDIR}/${P}-perl.patch" \
	"${FILESDIR}/${P}-destdir.patch" \
	"${FILESDIR}/${P}-fullbolt.patch"
}

src_configure() {
	local myconf=""	
	use ppp || myconf="--disable-ppp"
	econf {myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc ChangeLog CONTRIB README README.NEXT TODO docs/*
	# newdoc ${WORKDIR}/README README-1.0.17
}

