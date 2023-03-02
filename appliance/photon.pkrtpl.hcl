{
   "arch": "x86_64",
   "hostname":"appliance",
   "password":{
      "crypted":false,
      "text":"${ssh_password}"
   },
   "disk":"/dev/sda",

   "bootmode":"bios",
   "network":{
      "type":"dhcp"
   },
   "linux_flavor":"linux",
   "packagelist_file":"packages_${os_packagelist}.json",
   "postinstall":[
      "#!/bin/sh",
      "chage --inactive -1 --mindays 0 --maxdays 90 --warndays 7 --expiredate -1 ${ssh_username}",
      "iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT",
      "iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT",
      "systemctl restart iptables",
      "sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config",
      "sed -i 's/.*MaxAuthTries.*/MaxAuthTries 10/g' /etc/ssh/sshd_config",
      "systemctl restart sshd.service"
   ]
}
