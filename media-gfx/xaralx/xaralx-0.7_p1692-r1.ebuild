# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
WX_GTK_VER="2.6"
inherit wxwidgets autotools gnome2

MY_P=XaraLXSrc-${PV/_p/r}

DESCRIPTION="General purpose vector graphics program"
HOMEPAGE="http://www.xaraxtreme.org/"
SRC_URI="http://downloads.xara.com/opensource/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+
	>=x11-libs/wxGTK-2.6.3:2.6
	virtual/libintl
	>=media-libs/libpng-1.2.8
	>=media-libs/jpeg-6b
	app-arch/zip
	dev-lang/perl
	>=dev-libs/libxml2-2.6.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=sys-devel/gettext-0.14.3"

S=${WORKDIR}/${MY_P/Src/}

pkg_setup() {
	need-wxwidgets unicode
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e "s/CXFTreeDlg:://" Kernel/cxftree.h
	sed -i -e "s:XaraLX:xaralx:g" Makefile.am

	AT_M4DIR=". ${S}/m4" eautoreconf
}

src_compile() {
	econf \
		--with-wx-config=${WX_CONFIG} \
		--with-wx-base-config=${WX_CONFIG} \
		--enable-xarlib \
		--enable-filters

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	insinto /usr/share/${PN}
	doins -r Designs Templates

	doicon ${PN}.png
	domenu ${PN}.desktop

	insinto /usr/share/icons/hicolor/48x48/mimetypes
	newins xaralx.png gnome-mime-application-vnd.xara.png
	insinto /usr/share/mime/packages
	doins Mime/xaralx.xml
	insinto /usr/share/application-registry
	doins Mime/mime-storage/gnome/xaralx.applications
	insinto /usr/share/mime-info
	doins Mime/mime-storage/gnome/xaralx.{keys,mime}

	doman doc/xaralx.1
	dodoc AUTHORS ChangeLog NEWS README \
		doc/{gifutil.txt,mtrand.txt,XSVG.txt}
	newdoc doc/en/LICENSE LICENSE-docs
	dodir /usr/share/doc/${PF}/html
	tar xzf doc/en/xaralxHelp.tar.gz -C "${D}"/usr/share/doc/${PF}/html
}
