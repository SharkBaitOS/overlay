# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/binutils/binutils-2.24-r3.ebuild,v 1.8 2014/11/04 09:26:08 ago Exp $

EAPI=4

PATCHVER="1.4"
ELF2FLT_VER=""
inherit toolchain-binutils

KEYWORDS="~amd64 ~arm ~x86"

src_prepare() {
	epatch "${FILESDIR}"/${P}-runtime-sysroot.patch
	toolchain-binutils_src_prepare
}

src_configure() {
	is_cross || EXTRA_ECONF+=" $(use_enable !rap runtime-sysroot)"
	toolchain-binutils_src_configure
}

