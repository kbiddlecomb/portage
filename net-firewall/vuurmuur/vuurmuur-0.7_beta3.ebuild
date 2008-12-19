# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Made by Tiger!P

MY_PKG_NAME="Vuurmuur"
DESCRIPTION="Iptables frontend. Rule- and logdaemons and commandline utils."
HOMEPAGE="http://www.vuurmuur.org"
SRC_URI="mirror://sourceforge/vuurmuur/${MY_PKG_NAME}-${PV/_/}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND=""
RDEPEND="net-firewall/iptables
	=net-libs/libvuurmuur-${PV}"

src_unpack() {
	unpack ${A} || die "Unpacking of ${A} did not succeed"
	cd ${MY_PKG_NAME}-${PV/_/} || die "Changing to the ${MY_PKG_NAME}-${PV/_/} directory failed"
	# Because we need to unpack something from the just unpacked file, we do it
	# like a shell command
	einfo "Unpacking ${P/_/}.tar.gz"
	gzip -cd ${P/_/}.tar.gz | tar xf - || die "Unpacking of ${P/_/}.tar.gz failed"
}

src_compile() {
	cd ${WORKDIR}/${MY_PKG_NAME}-${PV/_/}/${P/_/} || die
	libtoolize -f
	aclocal
	autoheader
	automake
	autoconf
	econf --with-libvuurmuur-includes=/usr/include \
	--with-libvuurmuur-libraries=/usr/lib || die "The configure script failed"
	emake || die "Making did not succeed"
}

src_install() {
	cd ${WORKDIR}/${MY_PKG_NAME}-${PV/_/}/${P/_/} || die "Could not change dirs"
	einstall
	# TODO Still need to install the init.d script as a real script in the real
	# place and also warn the user to enable it when needed.
	doinitd ${FILESDIR}/vuurmuurd
	ewarn "Start the vuurmuur service before using it"
	diropts -m0700
	dodir /etc/vuurmuur
	dodir /etc/vuurmuur/textdir/interface
	dodir /etc/vuurmuur/textdir/services
	dodir /etc/vuurmuur/textdir/rules
	insopts -m0600
	insinto /etc/logrotate.d
	newins scripts/vuurmuur-logrotate vuurmuur
	insinto /etc/vuurmuur
	newins skel/etc/vuurmuur/config.conf.sample config.conf
	cd ..
	insinto /etc/vuurmuur/textdir
	doins -r zones
	dodir /etc/vuurmuur/textdir/zones/dmz/networks
	dodir /etc/vuurmuur/textdir/zones/ext/networks/internet/hosts
	dodir /etc/vuurmuur/textdir/zones/ext/networks/internet/groups
	dodir /etc/vuurmuur/textdir/zones/lan/networks
	dodir /etc/vuurmuur/textdir/zones/vpn/networks
}

