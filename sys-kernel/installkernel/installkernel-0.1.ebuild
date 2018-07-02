# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Installkernel script for Portage-powered Android systems"
HOMEPAGE="https://github.com/KireinaHoro/installkernel"
SRC_URI="https://github.com/KireinaHoro/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~arm64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
sys-kernel/preinit
app-arch/cpio
dev-util/abootimg
"

src_install() {
	into /bin
	dobin installkernel
}
