# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="split tcp requests of different type to different servers"
HOMEPAGE="http://ypd.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	dobin src/ypd
	dodir /etc/init.d/
	newinitd "${FILESDIR}/ypd.rc" ypd
	newconfd "${FILESDIR}/ypd.conf" ypd
	dodoc README ChangeLog AUTHORS
}
