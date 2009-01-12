# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Open source Linux driver for the Konica Minolta magicolor 2300W and 2400W color laser printers."
HOMEPAGE="http://sourceforge.net/projects/m2300w/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="net-print/foomatic-filters
	net-print/cups"
RDEPEND="${DEPEND}"

src_install() {
	emake INSTROOT="${D}" install || die "emake install failed"
}
