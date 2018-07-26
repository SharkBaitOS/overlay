# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Virtual for Android kernel sources"
SLOT="0"
KEYWORDS="~arm64"
IUSE=""

RDEPEND="
	|| (
		sys-kernel/angler-sources
	)"
