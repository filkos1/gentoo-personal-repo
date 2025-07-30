EAPI=8

inherit cmake

DESCRIPTION="Quickshell is a toolkit for building status bars, widgets, lockscreens, and other desktop components using QtQuick."

HOMEPAGE="https://quickshell.org/"

SRC_URI="https://git.outfoxxed.me/quickshell/quickshell/archive/v${PV}.tar.gz"
S="${WORKDIR}/quickshell"

LICENSE="GPLv3"

SLOT="0"

KEYWORDS="~amd64"

IUSE="+jemalloc +wayland +screencast +X +pipewire +dbus +pam +hyprland +i3 +i3-ipc +statusnotifier +splitdebug +mpris +svg +notifications"

RDEPEND="
>=dev-qt/qtbase-6.0.0:6
>=dev-qt/qtdeclarative-6.0.0:6
wayland? ( dev-libs/wayland >=dev-qt/qtwayland-6.0.0:6 >=dev-qt/qtbase-6.6.0:6 )
svg? ( >=dev-qt/qtsvg-6.0.0:6 )
jemalloc? ( dev-libs/jemalloc )
screencast? ( x11-libs/libdrm  media-libs/mesa )
X? ( x11-libs/libxcb )
pipewire? ( media-video/pipewire )
dbus? ( >=dev-qt/qtbase-6.0.0:6[dbus] )
mpris? ( >=dev-qt/qtbase-6.0.0:6[dbus] )
pam? ( sys-libs/pam )
"

BDEPEND="
dev-build/ninja
dev-build/cmake
virtual/pkgconfig
dev-qt/qtshadertools:6
dev-util/spirv-tools
dev-cpp/cli11
>=dev-qt/qtbase-6.0.0:6
>=dev-qt/qtdeclarative-6.0.0:6
wayland? ( >=dev-qt/qtwayland-6.0.0:6 >=dev-qt/qtbase-6.6.0:6 dev-util/wayland-scanner dev-libs/wayland-protocols )
"

src_configure() {
	mycmakeargs=(
		-DDISTRIBUTOR="Gentoo(personal ebuild repo)"
		-DINSTALL_QML_PREFIX="lib64/qt6/qml"
		-DCRASH_REPORTER=OFF
		-DUSE_JEMALLOC=$(usex jemalloc ON OFF)
		-DSOCKETS=ON
		-DWAYLAND=$(usex wayland ON OFF)
		-DWAYLAND_WLR_LAYERSHELL=$(usex wayland ON OFF)
		-DWAYLAND_SESSION_LOCK=$(usex wayland ON OFF)
		-DWAYLAND_TOPLEVEL_MANAGEMENT=$(usex wayland ON OFF)
		-DSCREENCOPY=$(usex screencast ON OFF)
		-DX11=$(usex X ON OFF)
		-DSERVICE_PIPEWIRE=$(usex pipewire ON OFF)
		-DSERVICE_STATUS_NOTIFIER=$(usex statusnotifier ON OFF)
		-DSERVICE_MPRIS=$(usex mpris ON OFF)
		-DSERVICE_PAM=$(usex pam ON OFF)
		-DSERVICE_NOTIFICATIONS=$(usex notifications ON OFF)
		-DHYPRLAND=$(usex hyprland ON OFF)
		-DHYPRLAND_GLOBAL_SHORTCUTS=$(usex hyprland ON OFF)
		-DHYPRLAND_FOCUS_GRAB=$(usex hyprland ON OFF)
		-DI3=$(usex i3 ON OFF)
		-DI3_IPC=$(usex i3-ipc ON OFF)
		-DDISTRIBUTOR_DEBUGINFO_AVAILABLE=$(usex splitdebug YES NO)
		-DCMAKE_BUILD_TYPE=RelWithDebInfo
	)
	cmake_src_configure
}
