#!/bin/sh
## Function list
# System calls and information
#
## TODO
##
# list-dns(){ nmcli device show <interfacename> | grep IP4.DNS ;}
# file-count='ls -l | wc -l'
# uuid='uuidgen' OR 'cat /proc/sys/kernel/random/uuid'
# passwords-complexity:  /etc/pam.d/common-password
# password expire:  sudo chage -d 0 ${username}
# create-user(){ sudo adduser ${user} -m -g docker && sudo passwd ${user} && sudo chage -d 0 ${user} ;}
# gpu detect: lspci | grep -ci nvidia
# find : find / -type f -name <file>
# replace-in-file: sed -ie 's/old/new/g' file.txt
# socks proxy: gcloud compute ssh --zone us-west1-a tunnel -- -N -p 22 -D localhost:5000
# http tunnel: ssh -i -L 8080:localhost:8888 user@address
	#
# global proxy config (curl, wget, etc.)
#  - curlrc: proxy=<proxy_host>:<proxy_port>
#	 - wgetrc: use_proxy=yes \n http_proxy=127.0.0.1:8080
#  - yum: proxy=http://mycache.mydomain.com:3128

alias ctl='sudo systemctl'
alias restartctl='ctl daemon-reload'
alias kernel-version='uname -mrs'
alias distro-info='cat /etc/*-release'
alias distro-base='lsb_release -a'
alias poweroff='sudo shutdown -h now'
alias disk='du -hd'

ipaddr(){
	[[ -z "$1" ]] && iface='eth0' || iface=$1
	echo $(ip addr show ${iface} | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
}

alias users='cut -d: -f1 /etc/passwd'
alias groupuser='sudo usermod user -a -G' # <group> <user>
function groupshow { grep $1 /etc/group ;}

# Define a timestamp function
timestamp() { date +%s%3N ;}
timestamp64() { timestamp | base64 ;}

# ssh
alias skeys='ls -al ~/.ssh'
# generate ssh keys e.g. sgen <account@email.com>
alias sgen='ssh-keygen -t rsa -b 4096 -C'
scat() {
	[[ -z "$1" ]] && key=~/.ssh/id_rsa.pub || key=~/.ssh/$1.pub
	cat $key | cbcopy
	cat $key
}
# TODO: add command for public key distribution
# ssh-keygen -t rsa

killbyport(){
	port=$1
	[ $2 == '-u' ] && protocol='udp' || protocol='tcp'
	kill -9 $(lsof -i ${protocol}:${port} -t)
}

pperms(){
	echo '
0 == ---
1 == --x
2 == -w-
3 == -wx
4 == r--
5 == r-x
6 == rw-
7 == rwx
'
}

replaceAll(){
	find . -name $1 -print0 | xargs -0 sed -i "s/$2/$3/g"
}

pcron(){
	echo '
crontab -e

* * * * * <cmd> <ags...>
* * * * * <user (only if root)> <cmd> <ags...>
- - - - -
| | | | |
| | | | ----- Day of week (0 - 7) (Sunday=0 or 7)
| | | ------- Month (1 - 12)
| | --------- Day of month (1 - 31)
| ----------- Hour (0 - 23)
------------- Minute (0 - 59)

list
  crontab -l
  crontab -u username -l
Delete
  crontab -r <job#>
'
}

# automate new machine credentials setup
machineme(){
	host=$1
	ssh-keyscan -H $(echo ${host} | cut -d '@' -f 2) >> ~/.ssh/known_hosts
	echo -n 'temporary password:'
	read -s old && echo
	echo -n 'new password:'
	read -s new && echo

	expect pass.ex $host $old $new

	# while read node; do
	# 	node-keyscan ${node}
	# done < "${node_list}"
}

# adds ssh pub key to specified host server
trustme(){
	host=$1
	[[ -z "$2" ]] && key=~/.ssh/id_rsa.pub || key=$2
	cat ${key} | ssh ${host} 'mkdir -p .ssh && \
	cat >> .ssh/authorized_keys && \
	chmod 700 .ssh && \
	chmod 640 .ssh/authorized_keys'
}

skeyscan(){
	host=$1
	ssh-keyscan -H ${host} >> ~/.ssh/known_hosts
}

util-write-con(){
	path=$1
	touch ${path}
	while :
	do
	 cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 >> ${path}
	 sleep 0.1
	done
}

# system-detection
ismac(){ [ "$(uname)" == "Darwin" ] ;}
#islinux(){ [ "$(expr substr $(uname -s) 1 5)" == "Linux" ] ;}
getkernel(){ ismac && echo 'darwin' || echo 'linux' ;}

# overrides 'open' to make it cross platform
open(){ echo ${@:1}; ismac && command open ${@:1} || xdg-open "${@:1}" ;}

keyspeed(){  xset r rate 200 60 ;}

# package managers
alias sag='sudo apt-get'

# networking
alias ports='netstat -plnt'

# random gen
alias passgen='openssl rand -base64 32'
alias passgend='dri debian bash -c "< /dev/urandom tr -dc @_A-Z-a-z-0-9 | head -c${1:-32};" | cbcopy'

# TODO: make network .al
#TODO: create functions for different net-iface managers
## dhcpcd
#interface eth0
#  static ip_address=192.168.0.180/24
#  static routers=192.168.0.1
#  static domain_name_servers=192.168.0.1

# clipboard
ismac && alias cbcopy='pbcopy' || alias cbcopy='xclip -selection c'
ismac && alias cbpaste='pbpaste' || alias cbpaste='xclip -selection clipboard -o'
clip() { [[ -f "$1" ]] && cat $1 | cbcopy || exec "${@:1}" | cbcopy ;}

wallpaper(){
	if [ -z $1 ]; then
		gsettings get org.gnome.desktop.background picture-uri
	else
		[ "$1" == "-r" ] && image="$HOME/Pictures/$(ls ~/Pictures | shuf -n 1)" || image=$1
		image=$(realpath $image)
		gsettings set org.gnome.desktop.background picture-uri "file://${image}"
	fi
}
