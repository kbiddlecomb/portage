# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON="2.4"

inherit distutils eutils multilib

MY_P="Democracy-${PV}"
DESCRIPTION="A free and open internet TV platform."
HOMEPAGE="http://www.getdemocracy.com/"
SRC_URI="ftp://ftp.osuosl.org/pub/pculture.org/democracy/src/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86"
RDEPEND="dev-libs/boost
	dev-python/gnome-python-extras
	dev-python/gst-python
	>=dev-python/pygtk-2.0
	dev-python/pyrex
	media-libs/xine-lib
	www-client/mozilla-firefox
	x11-apps/xset
	x11-libs/libX11
	~dev-python/dbus-python-0.71"
	# dbus-python versions >0.80 changed the api so democracyplayer does
	# not work with them, therefore depending on the 0.71 version in portage
	# see https://develop.participatoryculture.org/democracy/ticket/3067

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="README"

S="${WORKDIR}/${MY_P}/platform/gtk-x11"

pkg_setup() {
	if ! built_with_use dev-lang/python berkdb; then
		eerror "You must build python with berkdb support"
		die "Please re-emerge python with berkdb USE flag ON"
	fi

	python_version
	if ! grep -q compiler.find /usr/$(get_libdir)/python${PYVER}/distutils/unixccompiler.py; then
		eerror "You need to apply a patch to make distutils use the correct RPATH."
		eerror "To do this execute the following command as root:"
		eerror "wget -q 'http://sourceforge.net/tracker/download.php?group_id=5470&atid=305470&file_id=144928&aid=1254718' -O -|patch -p1 -d /usr/$(get_libdir)/python${PYVER}"
		die "python version not patched"
	fi

	if ! built_with_use -o dev-python/gnome-python-extras seamonkey firefox; then
		eerror "You must build gnome-python-extras with seamonkey or firefox support"
		die "Please re-emerge gnome-python-extras with seamonkey or firefox USE flag ON"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/democracy-as-needed-libX11.patch
}

pkg_postinst(){
	if ! built_with_use --missing true media-libs/xine-lib aac alsa mad asf flac sdl win32codecs mp3; then
		ewarn "The Democracy team recommends you to emerge xine-lib as follows:"
		ewarn
		ewarn "# echo \"media-libs/xine-lib aac mad asf flac sdl win32codecs mp3 \" \ "
		ewarn ">> /etc/portage/package.use && emerge -N xine-lib"
		ewarn
		ewarn "This way you will have support enabled for the most popular"
		ewarn "video and audio formats. You may also want to add support"
		ewarn "for theora and vorbis"
	fi
}
