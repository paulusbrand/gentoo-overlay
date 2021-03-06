# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

SRC_URI="https://download.sonarr.tv/v3/phantom-develop/${PV}/Sonarr.phantom-develop.${PV}.linux.tar.gz"

DESCRIPTION="Sonarr is a Smart PVR for newsgroup and bittorrent users."
HOMEPAGE="https://www.sonarr.tv"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND="
	acct-group/sonarr-v3
	acct-user/sonarr-v3
	>=dev-lang/mono-4.8.0.524
	media-video/mediainfo
	dev-db/sqlite"

MY_PN=Sonarr
S="${WORKDIR}/${MY_PN}"

src_install() {
	newconfd "${FILESDIR}/${PN}.conf" ${PN}
	newinitd "${FILESDIR}/${PN}.init" ${PN}

	keepdir /var/lib/${PN}
	fowners -R ${PN}:${PN} /var/lib/${PN}

	insinto /etc/${PN}
	insopts -m0660 -o ${PN} -g ${PN}

	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	dodir  "/usr/share/${PN}"
	cp -R "${WORKDIR}/${MY_PN}/." "${D}/usr/share/sonarr-v3" || die "Install failed!"

	systemd_dounit "${FILESDIR}/sonarr-v3.service"
	systemd_newunit "${FILESDIR}/sonarr-v3.service" "${PN}@.service"
}
