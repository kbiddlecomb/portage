# Copyright 2006-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/matchbox-themes-extra/matchbox-themes-extra-0.3.ebuild,v 1.6 2009/01/12 21:03:43 solar Exp $

inherit versionator

DESCRIPTION="Extra themes for the matchbox window manager"
HOMEPAGE="http://matchbox-project.org/"
SRC_URI="http://matchbox-project.org/sources/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~arm ~hppa ~ppc ~x86"
IUSE=""

DEPEND=""

DEPEND="x11-wm/matchbox-window-manager"

src_compile() {
	econf || die "Configuration failed"

	emake || die "Compilation failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS ChangeLog INSTALL NEWS README
}
