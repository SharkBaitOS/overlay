# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit ninja-utils git-r3
EGIT_REPO_URI=https://github.com/KireinaHoro/android_build_${PN}
EGIT_CHECKOUT_DIR=${WORKDIR}/${P}/build/${PN}

A_URI=http://aosp.airelinux.org/platform/build
# blueprint is a source level dependency of soong.
MPV=8.1.0_p41
SRC_URI="${A_URI}/blueprint/+archive/android-${MPV/p/r}.tar.gz -> blueprint-${MPV}.tar.gz
	https://github.com/LineageOS/android_vendor_lineage/archive/lineage-15.1.tar.gz -> vendor-lineage-15.1.tar.gz"
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
	"${FILESDIR}"/soong-9999-bootstrap-clean.patch
	"${FILESDIR}"/soong-no-kernel-header.patch
	"${FILESDIR}"/soong-no-bootstrap.patch
	"${FILESDIR}"/soong-gentoo-toolchain.patch
)

src_unpack() {
	git-r3_src_unpack

	mkdir -p "${S}"/vendor || die
	cd "${S}"/vendor || die
	unpack vendor-lineage-15.1.tar.gz
	mv android_vendor_lineage-lineage-15.1 lineage || die

	mkdir -p "${S}"/build/blueprint || die
	cd "${S}"/build/blueprint || die
	unpack blueprint-${MPV}.tar.gz
}

src_prepare() {
	default
	ln -s build/soong/root.bp Android.bp || die
	ln -s build/soong/bootstrap.bash || die

	for c in vendor/lineage/*; do
		[[ ${c} = */build ]] || rm -r ${c} || die
	done
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
	sed -n '/\/\/.*host bionic/,$p' < build/soong/Android.bp > "${T}"/Android.bp
	sed '/build = \[/,+3d' < build/soong/root.bp > "${T}"/root.bp
	insinto /usr/share/soong
	doins "${T}"/{Android,root}.bp
}
