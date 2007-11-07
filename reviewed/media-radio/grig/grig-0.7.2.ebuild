# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A tool for controlling amateur radios"
HOMEPAGE="http://groundstation.sourceforge.net/grig/"
SRC_URI="mirror://sourceforge/groundstation/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc"
EAPI="1"
IUSE="coverage +hardware"

DEPEND=">=dev-libs/glib-2.6
	>=x11-libs/gtk+-2.6
	>=media-libs/hamlib-1.2.5"
RDEPEND="${DEPEND}"

src_compile() {
	local myconf
	use hardware || myconf="${myconf} --disable-hardware"
	econf $(use_enable coverage ) ${myconf}
	emake || die "emake failed!"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	make_desktop_entry ${PN} "GRig" "/usr/share/pixmaps/grig/grig-logo.png" "Application;HamRadio"
}
