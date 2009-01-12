# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit zproduct

MY_PN="PloneS5"
MY_P="${MY_PN}.${PV}"

DESCRIPTION="An implementation of S5's presentation system in Plone"
HOMEPAGE="http://plone.org/products/s5"
SRC_URI="http://plone.org/products/s5/releases/${PV}/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=net-zope/plone-2.1"
DEPEND="${RDEPEND}
	app-arch/unzip"

ZPROD_LIST="${MY_PN}"
