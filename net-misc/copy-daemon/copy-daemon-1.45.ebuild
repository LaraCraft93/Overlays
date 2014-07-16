# Copyright 2014 Lara Maia <lara@craft.net.br>
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit systemd
IUSE="systemd"

DESCRIPTION="Copy.com daemon"
HOMEPAGE="https://www.copy.com/home/"
LICENSE="custom"

KEYWORDS="~amd64 ~ia64 ~x86 ~arm"
SLOT="0"

SRC_URI="https://copy.com/install/linux/Copy.tgz"

RDEPEND="sys-fs/fuse
         systemd? ( sys-apps/systemd )"

if use amd64 || use ia64; then
    S="$WORKDIR/${PN%%-*}"/x86_64
elif use x86; then
    S="$WORKDIR/${PN%%-*}"/x86
else
    S="$WORKDIR/${PN%%-*}"/armv6h
fi

src_install() {
    if use systemd; then
        systemd_dounit "$FILESDIR"/copy-daemon.service
    fi

    insinto /opt/copy
    doins ca-bundle.crt libBrt.so libAgentSync.so libCloudSync.so

    exeinto /opt/copy
    doenvd "$FILESDIR"/20copy-daemon
    
    newexe CopyCmd copycmd
    newexe CopyConsole copyconsole
}

pkg_postinst() {
	ewarn "The user must be validated for the first time."
	ewarn "To do that, execute this command as root:"
	ewarn " "
	ewarn "/opt/copy/copyconsole -u=<Copy email> -r=/home/<user>/Copy -p=<Copy pass>"
	ewarn " "
	ewarn "When copyconsole replies with 'press enter to exit', you can close copyconsole."
	ewarn "After that, you are ready to user systemd services for start copyconsole:"
	ewarn " "
	ewarn "systemctl enable copy-daemon < enable on boot"
	ewarn "systemctl start copy-daemon < start service"
	ewarn " "
	ewarn "You must restart your session for include copy tools into your PATH"
}

pkg_postrm() {
	ewarn "Remove /root/.copy folder for complete uninstall"
}