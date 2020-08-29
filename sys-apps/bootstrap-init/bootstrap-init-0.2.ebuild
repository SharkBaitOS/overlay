# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Bootstrap System-As-Root Android's init inside a LXC container"
HOMEPAGE="https://gitlab.com/WantGuns/bootstrap-init"
SRC_URI="https://gitlab.com/WantGuns/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~arm64"

BDEPEND=">=sys-devel/llvm-10.0.0"
DEPEND="${BDEPEND}"

S="${WORKDIR}/${PN}-v${PV}"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	export CC=$(which clang)
	export CXX=$(which clang++)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	dobin "${BUILD_DIR}/${PN}"
}
