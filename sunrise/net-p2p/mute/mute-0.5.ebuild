# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs wxwidgets flag-o-matic

MY_P="MUTE_fileSharing-${PV}_UnixSource"

DESCRIPTION="peer-to-peer network that provides easy search-and-download
functionality while also protecting your privacy"
HOMEPAGE="http://mute-net.sourceforge.net/"
SRC_URI="mirror://sourceforge/mute-net/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="wxwindows"

DEPEND="wxwindows? ( >=x11-libs/wxGTK-2.6 )"
RDEPEND=$DEPEND

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}/${P}-configure.patch"
	epatch "${FILESDIR}/${P}-makefile.patch"

	cd "${S}/MUTE/otherApps/fileSharing/userInterface/languages/"
	mv Espa?ol.txt Espanol.txt
	rm TranslationHelper.txt
}

pkg_setup() {
	if [ $(gcc-major-version) -ge 4 ]; then
		einfo "${P} doesn't compile with gcc version >= 4"
		die "${P} needs gcc version < 4"
	fi
}

src_compile() {
	export WX_GTK_VER=2.6
	need-wxwidgets gtk2 || die

	# not an autotools configure
	cd "${S}/MUTE"
	./configure >/dev/null

	# break the crypto at startup
	filter-flags -fomit-frame-pointer

	emake GXX=$(tc-getCXX) || die "emake failed"

	if use wxwindows; then
		cd "${S}/MUTE/otherApps/fileSharing/userInterface/wxWindows"
		emake GXX="$(tc-getCXX)" WX_CONFIG="${WX_CONFIG}" || die "emake failed"
	fi
}

src_install() {
	exeinto /usr/share/mute
	doexe MUTE/otherApps/fileSharing/userInterface/textBased/textFileSharingMUTE
	dobin "${FILESDIR}/MUTE"
	if use wxwindows; then
		doexe MUTE/otherApps/fileSharing/userInterface/wxWindows/fileSharingMUTE
		dohard /usr/bin/MUTE /usr/bin/wxMUTE
	fi

	insinto /etc/mute/languages
	doins MUTE/otherApps/fileSharing/userInterface/languages/*.txt
	insinto /etc/mute/settings
	doins MUTE/otherApps/fileSharing/userInterface/settings/*.ini

	dodoc MUTE/otherApps/fileSharing/doc/*.txt
	dodoc MUTE/otherApps/fileSharing/userInterface/settings/README.txt
	dodoc MUTE/otherApps/fileSharing/doc/fileSharingProtocol.txt
	dodoc minorGems/protocol/p2p/*
}
