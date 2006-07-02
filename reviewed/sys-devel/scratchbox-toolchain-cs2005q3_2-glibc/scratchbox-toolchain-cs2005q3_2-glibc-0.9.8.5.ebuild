# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MAJOR_VERSION=${PV%\.[0-9]}
RELEASE_VERSION="-6"

SBOX_GROUP="sbox"
RESTRICT="strip"

DESCRIPTION="Scratchbox is a cross-compilation toolkit designed to make embedded Linux application development easier."
HOMEPAGE="http://www.scratchbox.org/"
SRC_URI="arm? ( http://scratchbox.org/download/files/sbox-releases/${MAJOR_VERSION}/tarball/${PN/cs2005q3_2/cs2005q3.2}-arm-${PV}${RELEASE_VERSION}.tar.gz )
	i386? ( http://scratchbox.org/download/files/sbox-releases/${MAJOR_VERSION}/tarball/${PN/cs2005q3_2/cs2005q3.2}-i386-${PV}${RELEASE_VERSION}.tar.gz )"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="arm i386"

DEPEND="=sys-devel/scratchbox-${MAJOR_VERSION}*"
RDEPEND="${DEPEND}"

TARGET_DIR="/opt/scratchbox"

S=${WORKDIR}/scratchbox


pkg_setup() {
	if ! use arm  && ! use i386; then
		ewarn "You have to specify at least one of the 'arm' and 'i386' use flags"
		ewarn "No toolchain will be installed now"
	fi
}

src_install() {
	dodir ${TARGET_DIR}
	if use arm || use i386; then
		cp -pRP * "${D}/${TARGET_DIR}"
	fi
}
