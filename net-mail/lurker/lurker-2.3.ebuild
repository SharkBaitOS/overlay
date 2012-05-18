# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit eutils autotools flag-o-matic webapp

DESCRIPTION="Lurker is a mailing list archiver designed for capacity, speed, simplicity, and configurability."
HOMEPAGE="http://lurker.sourceforge.net/"
MIMELIB_URI="mirror://sourceforge/lurker/mimelib-3.1.1.tar.gz"
SRC_URI="mirror://sourceforge/lurker/${P}.tar.gz ${MIMELIB_URI}"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~x86-linux"
IUSE=""

RDEPEND=""

DEPEND="sys-libs/zlib
	dev-libs/libxslt"

need_httpd_cgi

S=${WORKDIR}/${P}
MIMELIB=${WORKDIR}/mimelib

pkg_setup() {
	webapp_pkg_setup
}

src_configure() {
	echo "jopa!"
	cd ${S}
	ln -s ${MIMELIB} mimelib
	echo ${S}
	econf --with-mimelib-local \
	      --with-default-www-dir=${MY_HTDOCSDIR} \
	      --with-cgi-bin-dir=${MY_CGIBINDIR} \
	|| die "econf failed"
}

src_compile() {
	cd ${S}
	emake || die "make failed"
}

src_install() {
	webapp_src_preinst
	emake install DESTDIR=${D} || die "install failed"
	emake install-config DESTDIR=${D} || die "install-config failed"
	dodoc ChangeLog FAQ INSTALL README AUTHORS COPYING
	# mv ${ED}/etc/lurker/lurker.conf ${D}${MY_HOSTROOTDIR} || die
	# webapp_configfile ${D}${MY_HOSTROOTDIR}/lurker.conf
	# webapp_postinst_txt en INSTALL
	# webapp_src_install
}

pkg_postinst() {
	ewarn "The lurker.conf file will be installed into your "
	ewarn "document root directory for the virtual host."
	ewarn "use the command:"
	ewarn "webapp-config -I -d / -h lurker.example.org lurker 2.3"
	ewarn "to install lurker for each virtual host and then edit"
	ewarn "the lurker.conf file for that host."
	ewarn
	ewarn "You should also have access control in place over the"
	ewarn "lurker website. There is a sample apache configuration"
	ewarn "file in /etc/lurker/apache.conf that you could include"
	ewarn "in your apache configuration."
}
