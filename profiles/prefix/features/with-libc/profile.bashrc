# use sysroot of toolchain to get include and library at compile time work
# Benda Xu <heroxbd@gentoo.org> (17 Jun, 2013)

if [[ ${CATEGORY} == sys-devel ]] && [[ ${PN} == gcc || ${PN} == binutils || ${PN} == libtool ]] \
	&& [[ ${EBUILD_PHASE} == unpack ]]; then
	elog "append --with-sysroot=${EPREFIX} to configure for Prefix libc"
	EXTRA_ECONF+="--with-sysroot=${EPREFIX}"
fi

# from bintuils info page: In case a sysroot prefix is configured, and
# the filename starts with the `/' character, and the script being
# processed was located inside the sysroot prefix, the filename will
# be looked for in the sysroot prefix. Otherwise, the linker will try
# to open the file in the current directory. glibc will append libdir
# and slibdir, which is prepended with $EPREFIX, to libc.so and
# libpthread.so linker scripts. That will cause double prefix if ld is
# configured with sysroot support.
# This is a dirty hack here, suggestion for alternatives welcome.
# Benda Xu <heroxbd@gentoo.org> (17 Jun, 2013)

if [[ ${CATEGORY}/${PN} == sys-libs/glibc ]]; then
        eblit-src_install-post() {
                elog "fixing ldscripts to prevent double prefix with sysroot-enabled ld"
                for lds in "$ED"usr/lib/lib{c,pthread}.so; do
                        sed -i "s,$EPREFIX,,g" "$lds"
                done
        }
fi

