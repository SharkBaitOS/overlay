# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit ninja-utils

A_URI=http://aosp.airelinux.org/platform/build

# blueprint is a source level dependency of soong.
SRC_URI="${A_URI}/${PN}/+archive/android-${PV/p/r}.tar.gz -> ${P}.tar.gz
	${A_URI}/blueprint/+archive/android-${PV/p/r}.tar.gz -> blueprint-${PV}.tar.gz"
DESCRIPTION="JSON-like build system for Android."
HOMEPAGE="${A_URI}/${PN}"
LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT=0

DEPEND="dev-lang/go
	dev-util/ninja"
RDEPEND="dev-lang/go"

PATCHES=(
	"${FILESDIR}"/blueprint-test-go-1.10.patch
	"${FILESDIR}"/soong-bootstrap-clean.patch
	"${FILESDIR}"/soong-no-kernel-header.patch
)

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
	ln -s build/soong/bootstrap.bash || die
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
	sed -n '/\/\/.*host bionic/,$p' < build/soong/Android.bp > "${T}"/Android.bp
	insinto /usr/share/soong
	doins "${T}"/Android.bp
}
