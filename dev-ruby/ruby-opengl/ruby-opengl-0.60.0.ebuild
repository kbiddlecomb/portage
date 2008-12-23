# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-opengl/ruby-opengl-0.60.0.ebuild,v 1.9 2008/12/21 10:55:02 maekke Exp $

inherit gems

DESCRIPTION="OpenGL / GLUT bindings for ruby"
HOMEPAGE="http://ruby-opengl.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc sparc x86"

IUSE=""
DEPEND=">=dev-ruby/mkrf-0.2.0
	>=dev-ruby/rake-0.7.3
	virtual/opengl
	virtual/glut"
