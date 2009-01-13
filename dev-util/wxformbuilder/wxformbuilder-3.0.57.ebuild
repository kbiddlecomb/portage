# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit wxwidgets subversion

# using SVN repo as it contains install script and tarball doesn't
ESVN_REPO_URI="https://wxformbuilder.svn.sourceforge.net/svnroot/wxformbuilder/3.x/tags/3.0"
ESVN_PROJECT="${PN}"

WX_GTK_VER="2.6"

DESCRIPTION="The OpenSource Designer, GUI Builder, and RAD Tool For wxWidgets"
HOMEPAGE="http://www.wxformbuilder.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="unicode"

RDEPEND=">=x11-libs/wxGTK-${WX_GTK_VER}"
DEPEND="${RDEPEND}
        >=sys-devel/automake-1.7"

pkg_setup() {
	if use unicode; then
		#check for gtk2-unicode
		need-wxwidgets unicode
	else
		#check for gtk2-ansi
		need-wxwidgets ansi
	fi
}

src_compile() {
        local TMP
        TMP="${ESVN_STORE_DIR}/${ESVN_PROJECT}/${ESVN_REPO_URI##*/}"
        einfo "Syncing $TMP into $S"
        rsync -a "$TMP/" "$S" || die "rsync failed"

	# make premake first...
	make CONFIG=Release -C"${S}"/sdk/premake/src -f"${S}"/sdk/premake/build/Makefile

	# call premake
	"${S}"/sdk/premake/bin/premake --target gnu $(use_enable unicode) --disable-wx-debug --with-wx-shared

	# do it now
	make CONFIG=Release
}

src_install() {
	# Call install script provided by package
	"${S}"/install/linux/wxfb_export.sh ${D}/usr

	# Add icon to list
	einfo "Registering icon"
	newicon "${S}"/output/resources/icons/logo.png ${PN}.png

	#create desktop file
	einfo "Creating menu entry"
	make_desktop_entry wxformbuilder "WxFormBuilder" ${PN} Development
}

pkg_postinst() {
echo
ewarn "IMPORTANT:"
ewarn "This is an unofficial ebuild for wxFormBuilder."
ewarn "If you encounter any problems"
ewarn "do NOT file bugs to gentoo bugzilla."
}
