# Distributed under the terms of the GNU General Public License v2

EAPI="7"
CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake gnome3-utils vcs-snapshot virtualx

DESCRIPTION="Chinese Chewing engine for IBus, provides intelligent Zhuyin(BoPoMoFo) support"
HOMEPAGE="https://github.com/ibus/ibus/wiki"
SRC_URI="https://github.com/definite/ibus-chewing/tarball/f82342483341068101d4f8116bd4e8f3b322f220 -> ibus-chewing-1.6.2-f823424.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"
IUSE="gconf nls"

RDEPEND="app-i18n/ibus
	app-i18n/libchewing
	dev-libs/glib:2
	x11-libs/gtk+:3
	x11-libs/libX11
	gconf? ( gnome-base/gconf )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/cmake-fedora
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

DOCS=( AUTHORS ChangeLog README.md RELEASE-NOTES.txt USER-GUIDE )

PATCHES=(
	"${FILESDIR}"/${PN}-gob2.patch
)

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}"/definite-ibus-chewing-* "${S}"
}

src_configure() {
	local mycmakeargs=(
		-DMANAGE_DEPENDENCY_PACKAGE_EXISTS_CMD=false
		-DPRJ_DOC_DIR="${EPREFIX}"/usr/share/doc/${PF}
	)
	use nls || mycmakeargs+=( -DMANAGE_GETTEXT_SUPPORT=0 )
	cmake_src_configure
}

pkg_preinst() {
	use gconf && gnome3_gconf_savelist
	gnome3_schemas_savelist
}

pkg_postinst() {
	use gconf && gnome3_gconf_install
	gnome3_schemas_update
}

pkg_postrm() {
	gnome3_schemas_update
}

