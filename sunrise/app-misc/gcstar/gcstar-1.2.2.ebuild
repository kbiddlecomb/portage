# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="GCstar is a personal collections manager."
HOMEPAGE="http://www.gcstar.org/"
SRC_URI="http://download.gna.org/gcstar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mp3 tellico vorbis"

LANGS="ar bg ca cs de en es fr id it pl pt ro ru sr sv tr"
for x in "${LANGS}" ; do
	IUSE="${IUSE} linguas_${x}"
done

DEPEND="dev-lang/perl
		dev-perl/Archive-Tar
		dev-perl/Archive-Zip
		dev-perl/Compress-Zlib
		dev-perl/gtk2-perl
		dev-perl/HTML-Parser
		dev-perl/libwww-perl
		dev-perl/URI
		dev-perl/XML-LibXML
		dev-perl/XML-Parser
		dev-perl/XML-Simple
		dev-perl/Archive-Tar
		dev-perl/Compress-Zlib
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-libnet
		mp3? ( dev-perl/MP3-Info dev-perl/MP3-Tag )
		tellico? ( dev-perl/Archive-Zip
			virtual/perl-Digest-MD5
			virtual/perl-MIME-Base64 )
		vorbis? ( dev-perl/Ogg-Vorbis-Header-PurePerl )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	cd "${S}"/lib/gcstar/GCLang

	# English version should be always available so we will keep it
	mkdir tmp
	for i in {AR,BG,CA,CS,DE,ES,FR,ID,IT,PL,PT,RO,RU,SR,SV,TR}; do
		mv ${i} tmp/
	done

	for x in ${LANGS}; do
		# GCstar uses upper-case language names
		if use linguas_${x} ; then
			mv tmp/$(echo ${x} | tr '[:lower:]' '[:upper:]') .
		fi
	done

	rm -rf tmp

	cd "${S}"
	# otherwise man pages would get installed in /usr/man
	mv man share

	./install --prefix="${D}/usr" \
		--noclean --nomenu || die "install script failed"
	
	domenu share/applications/gcstar.desktop
	newicon share/gcstar/icons/gcstar_64x64.png gcstar.png
	
	dodoc CHANGELOG README
	
	if use linguas_fr; then 
		dodoc CHANGELOG.fr README.fr
	fi

	doman share/man/gcstar.1
}
