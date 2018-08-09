# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit ninja-utils

A_URI=https://android.googlesource.com/platform/build

# blueprint is a source level dependency of soong.
SRC_URI="${A_URI}/${PN}/+archive/3d83ebe1768d676c90e8fa3d508157f4654821e5.tar.gz -> ${P}.tar.gz
	${A_URI}/blueprint/+archive/a011038d864e3faa528ec1037a568e5824955a0f.tar.gz -> blueprint-${PV}.tar.gz"
DESCRIPTION="JSON-like build system for Android."
HOMEPAGE="${A_URI}/${PN}"
LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT=0

DEPEND="dev-lang/go
	dev-util/ninja"
RDEPEND="dev-lang/go"

src_unpack() {
	mkdir -p "${WORKDIR}"/${P}/build || die
	cd "${WORKDIR}"/${P}/build || die

	for a in ${A}; do
		mkdir ${a/-*//} || die
		pushd ${a/-*//} > /dev/null || die
		unpack ${a}
		popd > /dev/null || die
	done
}

src_prepare() {
	default
	ln -s build/soong/root.bp Android.bp || die
	ln -s build/soong/bootstrap.bash
}

src_compile() {
	BUILDDIR="${S}"/out bash -xv build/soong/bootstrap.bash || die
	eninja -v -f out/.minibootstrap/build.ninja
	eninja -v -f out/.bootstrap/build.ninja

	# go run cmd/microfactory/microfactory.go -s cmd/microfactory \
	#    -pkg-path android/soong=. -o out/soong_ui android/soong/cmd/soong_ui
	# eninja -v -f .bootstrap/build.ninja
}

src_install() {
	dobin out/.bootstrap/bin/*
	dodoc out/.bootstrap/docs/*
}
