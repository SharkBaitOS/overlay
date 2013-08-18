# use sysroot of toolchain to get include and library at compile time work
# Benda Xu <heroxbd@gentoo.org> (17 Jun, 2013)

if [[ ${CATEGORY} == sys-devel ]] && [[ ${PN} == gcc || ${PN} == binutils || ${PN} == libtool ]] \
	&& [[ ${EBUILD_PHASE} == unpack ]]; then
	elog "append --with-sysroot=${EPREFIX} to configure for Prefix libc"
	EXTRA_ECONF+="--with-sysroot=${EPREFIX}"
fi

