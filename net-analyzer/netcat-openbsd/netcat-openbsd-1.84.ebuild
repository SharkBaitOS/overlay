# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs rpm

DESCRIPTION="the network swiss army knife openbsd porting"
HOMEPAGE="http://www.openbsd.org/cgi-bin/cvsweb/src/usr.bin/nc/"
SRC_URI="http://vault.centos.org/5.7/os/SRPMS/nc-1.84-10.fc6.src.rpm"
LICENSE="as-is"
SLOT="0"

KEYWORDS="~amd64 ~x86 ~x86-linux"

IUSE="static"

RDEPEND=">=dev-libs/glib-2
        !net-analyzer/netcat
        !net-analyzer/gnu-netcat"

#disable mirrors
RESTRICT="mirror"

S=${WORKDIR}/nc

src_unpack() {
        #unpack the source and do package patching
        rpm_src_unpack
        cd "${S}"
        epatch "../nc-1.84-glib.patch"
        epatch "../nc-1.78-pollhup.patch"
        epatch "../nc-1.82-reuseaddr.patch"
        epatch "../nc-gcc_signess.patch"
        epatch "../nc-1.84-connect_with_timeout.patch"
        epatch "../nc-1.84-udp_stop.patch"
        epatch "../nc-1.84-udp_port_scan.patch"
        epatch "../nc-1.84-crlf.patch"
        epatch "../nc-1.84-verb.patch"

}

src_compile() {
        use static && export STATIC="-static"
        COMPILER=$(tc-getCC)
        ${COMPILER} ${CFLAGS} `pkg-config --cflags --libs glib-2.0` netcat.c \
        atomicio.c socks.c -o nc.openbsd || die
}

src_install() {
        # INSTDIR is an ugly hack. I bet that there is a better way do define this
        INSTDIR="/usr/bin"
        dobin nc.openbsd || die "dobin failed"
        dodoc README*
        doman nc.1
        docinto scripts
        dodoc scripts/*
        dosym ${INSTDIR}/nc.openbsd ${INSTDIR}/nc
}

