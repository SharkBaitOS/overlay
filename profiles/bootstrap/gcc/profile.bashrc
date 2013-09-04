# disable gcc bootstrap which cleans out LDFLAGS essential for this phase.
[[ ${PN} == "gcc" ]] && { EXTRA_ECONF='--disable-bootstrap'; GCC_MAKE_TARGET='all'; }
