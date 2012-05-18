# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-mouse/xf86-input-mouse-1.7.1.ebuild,v 1.7 2011/10/03 18:02:59 josejx Exp $

EAPI=4
inherit xorg-2

DESCRIPTION="X.Org driver for mouse input devices"

KEYWORDS="~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.5.99.901"
DEPEND="${RDEPEND}"
