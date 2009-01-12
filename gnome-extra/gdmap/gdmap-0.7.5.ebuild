# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="GTK+ disk space visualizer"
HOMEPAGE="http://gdmap.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
SLOT="0"

RDEPEND=">=x11-libs/gtk+-2.6.0
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	gnome2_src_install
	dodoc ChangeLog README NEWS AUTHORS
}
