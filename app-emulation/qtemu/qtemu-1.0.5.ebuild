# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit eutils cmake-utils qt4

DESCRIPTION="A graphical user interface for QEMU written in Qt4."
HOMEPAGE="http://qtemu.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1 CCPL-Attribution-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=x11-libs/qt-4.1:4"
RDEPEND="${DEPEND}
	app-emulation/qemu"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PV}-help_and_translation_paths.patch"
}

src_install() {
	DOCS="ChangeLog README"
	cmake-utils_src_install

	doicon "${S}/images/${PN}.ico"
	make_desktop_entry "qtemu" "QtEmu" "${PN}.ico" "Qt;Utility;Emulator"
}
