{
    "arch": "x86_64",
    "hostname": "appliance",
    "password": {
        "crypted": false,
        "text": "${build_password}"
    },
    "disk": "/dev/sda",
    "bootmode": "efi",
    "network": {
        "type": "dhcp"
    },
    "linux_flavor": "linux",
    "packagelist_file": "packages_minimal.json",
    "postinstall": [
        "#!/bin/sh",
        "echo \"root:${root_password}\" | chpasswd",
        "chage --inactive -1 --mindays 0 --maxdays 90 --warndays 7 --expiredate -1 root",
        "useradd -m -s /bin/bash ${build_username}",
        "echo \"${build_username}:${build_password}\" | chpasswd",
        "usermod -aG sudo ${build_username}",
        "echo \"${build_username} ALL=(ALL:ALL) NOPASSWD: ALL\" >> /etc/sudoers.d/${build_username}",
        "chage --inactive -1 --mindays 0 --maxdays 90 --warndays 7 --expiredate -1 ${build_username}",
        "systemctl restart iptables",
        "sed -i 's/.*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config",
        "sed -i 's/.*MaxAuthTries.*/MaxAuthTries 10/g' /etc/ssh/sshd_config",
        "systemctl restart sshd.service"
    ]
}
