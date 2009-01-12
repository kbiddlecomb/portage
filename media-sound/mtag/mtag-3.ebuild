# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="the fast media tag lib"
HOMEPAGE="http://mtag.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="media-libs/taglib
	>=dev-db/sqlite-3.3.12"
DEPEND="dev-util/cmake
	${RDEPEND}"

src_compile() {
	cmake "${S}" || die "compile failed!"
	emake || die "compile failed!"
}

src_install() {
	dobin mtag
	dodoc README ChangeLog AUTHORS
	if use doc; then
		dohtml html/*
	fi
}
