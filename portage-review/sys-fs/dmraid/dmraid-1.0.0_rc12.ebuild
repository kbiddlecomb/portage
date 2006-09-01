# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-info flag-o-matic

MY_PV=${PV/_/.}-pre1
MY_P=${PN}-${MY_PV}

DESCRIPTION="Device-mapper RAID tool and library"
HOMEPAGE="http://people.redhat.com/~heinzm/sw/dmraid/"
SRC_URI="http://people.redhat.com/~heinzm/sw/dmraid/src/${MY_P}.tar-bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="static selinux"

DEPEND="sys-fs/device-mapper
	selinux? ( sys-libs/libselinux
		   sys-libs/libsepol )
	genkernel? ( sys-kernel/genkernel )"
S=${WORKDIR}/${PN}/${MY_PV}

pkg_setup() {
	if kernel_is lt 2 6; then
		ewarn "You are using a kernel < 2.6"
		ewarn "DMraid uses recently introduced Device-Mapper features."
		ewarn "These might be unavailable in the kernel you are running now."
	fi
	if use static && use selinux; then
		eerror "ERROR - cannot compile static with libselinux / libsepol"
		die "USE flag conflicts."
	fi
}

src_unpack() {
	tar -jxf ${DISTDIR}/${A}
	cd ${S}
	epatch ${FILESDIR}/dmraid-manpage-destdir.patch
}

src_compile() {
	#inlining doesnt seem to work for dmraid
	filter-flags -fno-inline

	econf   $(use_enable static static_link) \
		$(use_enable selinux libselinux) \
		$(use_enable selinux libsepol) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR=${D} install || die "emake install failed"

	# Put the distfile into /usr/share/genkernel/pkg for genkernel
	# in case the user wants to uuse this instead of genkernel's internal version
	dodir /usr/share/genkernel/pkg
	cp ${DISTDIR}/${A} ${D}/usr/share/genkernel/pkg/${MY_A}

	dodoc CHANGELOG README TODO KNOWN_BUGS doc/*
}

pkg_postinst() {
	einfo "For booting Gentoo from Device-Mapper RAID you can use Genkernel."
	einfo " "
	einfo "Genkernel will generate the kernel and the initrd with a statically "
	einfo "linked dmraid binary (its own version - not this version):"
	einfo "emerge -av sys-kernel/genkernel"
	einfo "genkernel --dmraid --udev all"
	einfo " "
	einfo "If you would rather use this version of DMRAID with Genkernel, update"
	einfo "the following in /etc/genkernel.conf:"
	einfo "DMRAID_VER=\"${MY_PV/_/.}\""
	einfo "DMRAID_SRCTAR=\"\$\{GK_SHARE\}\/pkg\/${MY_A}\""
	ewarn " "
	ewarn "DMRAID should be safe to use, but no warranties can be given"
	ewarn " "
}
