# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-keyboard/xf86-input-keyboard-1.6.0.ebuild,v 1.7 2011/04/16 17:59:14 armin76 Exp $

EAPI=4
inherit xorg-2

DESCRIPTION="Keyboard input driver"

KEYWORDS="~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.6.3"
DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/kbproto
	x11-proto/randrproto
	x11-proto/xproto"