# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

ESVN_REPO_URI="https://svn.tigase.org/reps/tigase-xmltools/trunk"

inherit subversion java-pkg-2 eutils

DESCRIPTION="XML tools designed for XMPP."
HOMEPAGE="http://www.tigase.org/en/project/xmltools"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-java/ant-1.7
	>=virtual/jdk-1.6.0"

RDEPEND=">=virtual/jre-1.6.0"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	ant clean-all
}

src_compile() {
	ant jar || die "Compile failed"
	if use doc; then
		ant docs || die "Docs failed"
	fi
}

src_install() {
	java-pkg_dojar jars/*.jar

	use doc && java-pkg_dojavadoc docs-tigase-xmltools/api
	use source && java-pkg_dosrc src/main/java/
}
