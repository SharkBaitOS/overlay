# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/wxpython/wxpython-2.8.12.1.ebuild,v 1.15 2012/05/29 14:46:19 aballier Exp $

EAPI="4"
PYTHON_DEPEND="2"
WX_GTK_VER="2.8"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython 2.7-pypy-*"

inherit alternatives distutils eutils fdo-mime wxwidgets

MY_P="${P/wxpython-/wxPython-src-}"

DESCRIPTION="A blending of the wxWindows C++ class library with Python"
HOMEPAGE="http://www.wxpython.org/"
SRC_URI="mirror://sourceforge/wxpython/${MY_P}.tar.bz2
	doc? ( mirror://sourceforge/wxpython/wxPython-docs-${PV}.tar.bz2
		   mirror://sourceforge/wxpython/wxPython-newdocs-2.8.9.2.tar.bz2 )
	examples? ( mirror://sourceforge/wxpython/wxPython-demo-${PV}.tar.bz2 )"

LICENSE="wxWinLL-3"
SLOT="2.8"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="aqua cairo doc examples opengl"

RDEPEND="
	aqua? (	>=dev-lang/python-2.6[aqua]
		>=x11-libs/wxGTK-${PV}:${WX_GTK_VER}[opengl?,tiff,aqua] )
	!aqua? ( >=x11-libs/wxGTK-${PV}:${WX_GTK_VER}[opengl?,tiff,X] )
	dev-libs/glib:2
	dev-python/setuptools
	media-libs/libpng:0
	media-libs/tiff:0
	virtual/jpeg
	x11-libs/gtk+:2[aqua=]
	x11-libs/pango[X]
	cairo?	( >=dev-python/pycairo-1.8.4 )
	opengl?	( dev-python/pyopengl )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}/wxPython"
DOC_S="${WORKDIR}/wxPython-${PV}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")
PYTHON_CXXFLAGS=("2.* + -fno-strict-aliasing")

PYTHON_MODNAME="wx-${SLOT}-gtk2-unicode wxversion.py"

src_prepare() {
	sed -i "s:cflags.append('-O3'):pass:" config.py || die "sed failed"

	epatch "${FILESDIR}"/${PN}-2.8.9-wxversion-scripts.patch
	# drop editra - we have it as a separate package now
	epatch "${FILESDIR}"/${PN}-2.8.12-drop-editra.patch

	if use doc; then
		cd "${DOC_S}"
		epatch "${FILESDIR}"/${PN}-${SLOT}-cache-writable.patch
		[[ -e samples/embedded/embedded ]] && rm -f samples/embedded/embedded
	fi

	if use examples; then
		cd "${DOC_S}"
		epatch "${FILESDIR}"/${PN}-${SLOT}-wxversion-demo.patch
	fi

	python_copy_sources
}

src_configure() {
	need-wxwidgets unicode

	DISTUTILS_GLOBAL_OPTIONS=(
		"* WX_CONFIG=${WX_CONFIG}"
		"* WXPORT=$(use aqua && echo mac || echo gtk2)"
		"* UNICODE=1"
		"* BUILD_GLCANVAS=$(use opengl && echo 1 || echo 0)"
	)
}

distutils_src_install_post_hook() {
	# Collision protection.
	local file
	for file in "$(distutils_get_intermediate_installation_image)${EPREFIX}/usr/bin/"*; do
		mv "${file}" "${file}-${SLOT}"
	done
}

src_install() {
	local docdir file

	distutils_src_install

	# Collision protection.
	rename_files() {
		for file in "${ED}$(python_get_sitedir)/"wx{version.*,.pth}; do
			mv "${file}" "${file}-${SLOT}" || return 1
		done
	}
	python_execute_function -q rename_files

	dodoc "${S}"/docs/{CHANGES,PyManual,README,wxPackage,wxPythonManual}.txt

	insinto /usr/share/applications
	doins distrib/{Py{AlaMode,Crust,Shell},XRCed}.desktop
	insinto /usr/share/pixmaps
	newins wx/py/PyCrust_32.png PyCrust.png
	newins wx/tools/XRCed/XRCed_32.png XRCed.png

	if use doc; then
		dodoc -r "${DOC_S}"/docs
		# For some reason newer API docs aren't available so use 2.8.9.2's
		dodoc -r "${WORKDIR}"/wxPython-2.8.9.2/docs
	fi

	if use examples; then
		dodoc -r "${DOC_S}"/demo
		dodoc -r "${DOC_S}"/samples
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update

	create_symlinks() {
		alternatives_auto_makesym "$(python_get_sitedir)/wx.pth" "$(python_get_sitedir)/wx.pth-[0-9].[0-9]"
		alternatives_auto_makesym "$(python_get_sitedir)/wxversion.py" "$(python_get_sitedir)/wxversion.py-[0-9].[0-9]"
	}
	python_execute_function -q create_symlinks

	distutils_pkg_postinst

	echo
	elog "Gentoo uses the Multi-version method for SLOT'ing."
	elog "Developers, see this site for instructions on using"
	elog "2.6 or 2.8 with your apps:"
	elog "http://wiki.wxpython.org/index.cgi/MultiVersionInstalls"
	echo
	if use doc; then
		elog "To access the general wxWidgets documentation, run"
		elog "/usr/share/doc/${PF}/docs/viewdocs.py"
		elog
		elog "wxPython documentation is available by pointing a browser"
		elog "at /usr/share/doc/${PF}/docs/api/index.html"
	fi
	if use examples; then
		elog
		elog "The demo.py app which contains hundreds of demo modules"
		elog "with documentation and source code has been installed at"
		elog "/usr/share/doc/${PF}/demo/demo.py"
		elog
		elog "Many more example apps and modules can be found in"
		elog "/usr/share/doc/${PF}/samples/"
		echo
	fi
	elog "Editra is not packaged with wxpython in Gentoo."
	elog "You can find it in the tree as app-editors/editra"
	echo
}

pkg_postrm() {
	distutils_pkg_postrm
	fdo-mime_desktop_database_update

	create_symlinks() {
		alternatives_auto_makesym "$(python_get_sitedir)/wx.pth" "$(python_get_sitedir)/wx.pth-[0-9].[0-9]"
		alternatives_auto_makesym "$(python_get_sitedir)/wxversion.py" "$(python_get_sitedir)/wxversion.py-[0-9].[0-9]"
	}
	python_execute_function -q create_symlinks
}
