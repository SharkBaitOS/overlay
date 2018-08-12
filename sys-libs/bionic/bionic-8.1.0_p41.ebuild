# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit ninja-utils

DESCRIPTION="Lightweight libc of Android."
HOMEPAGE="https://android.googlesource.com/platform/bionic"
KEYWORDS="~amd64"

SM=( ${PN} build external/{safe-iop,libcxx{,abi},compiler-rt,libunwind{,_llvm},lzma,zlib,jemalloc} system/core )

for m in ${SM[@]}; do
	SRC_URI+="http://aosp.airelinux.org/platform/${m}/+archive/android-${PV/p/r}.tar.gz -> ${m##*/}-${PV}.tar.gz"$'\n'
done
SLOT=0

LICENSE="Apache-2.0"

DEPEND="dev-util/soong"

src_unpack() {
	for m in ${SM[@]}; do
		mkdir -p ${P}/${m} || die
		pushd ${P}/${m} > /dev/null || die
		unpack ${m##*/}-${PV}.tar.gz
		popd > /dev/null || die
	done
}

src_prepare() {
	default
	# We are building a minimal bionic for toolchains. Ignore the
	# advanced optional features like tests and debug tools.
	rm -r ${PN}/{tests,tools,benchmarks,libc/malloc_debug} || die

	cp "${EPREFIX}"/usr/share/soong/root.bp Android.bp || die
	cat >> Android.bp <<EOF || die
cc_defaults {
	name: "llvm-defaults"
}
EOF
	ln -s "${EPREFIX}"/usr/share/soong build || die

	# Remove ndk libraries. But keep ndk headers, because they are the
	# headers of the GNU/Linux sense.
	sed -e '/ndk_library/,/subdir/{/subdir/p;d}' -i bionic/libc/Android.bp || die

	local core_keep=( base liblog debuggerd libziparchive libbacktrace libcutils demangle \
						   Android.bp include libutils libsystem libvndksupport )
	mv system/core{,_delete} || die
	mkdir system/core || die
	for c in ${core_keep[@]}; do
		mv system/core{_delete/${c},/} || die
	done
	rm -r system/core_delete || die

	find "${WORKDIR}" -name Android.bp -exec sed -e '/cc_test.*{/,$d' \
		 -e "/\ssdk_version/d" \
		 -e '/ndk_library/,$d' \
		 -i {} \; || die
	sed -e '/ANDROIDMK TRANSLATION ERROR/,$d' -i external/compiler-rt/lib/asan/Android.bp || die
	sed -e '/llvm-headers/d' -i system/core/libbacktrace/Android.bp || die
	mkdir out || die
	rm ${PN}/libc/versioner-dependencies/common/clang-builtins || die
}

src_configure() {
	# relocation packer is a toxic technique with no portability.
	# https://chromium.googlesource.com/chromium/src.git/+/76ef458065798bc70114854cf4b51827005448a1/tools/relocation_packer/README.TXT
	DISABLE_RELOCATION_PACKER=true \
	soong_build -t -b out/ -d out/build.ninja.d -o out/build.ninja Android.bp || die
}

src_compile() {
	eninja -f out/build.ninja -v
}
