## Function list
# Docker
#
## TODO
##
# ddl=grep docker /var/log/messages

alias dk='docker'
alias dr='dk run'
# run single command
alias drc='dr --rm'
alias drp='drc -v `pwd`:"/`basename $(pwd)`" -w "/`basename $(pwd)`"'

# run as shell
alias dri='drc -it'
alias drip='dri -v `pwd`:"/`basename $(pwd)`" -w "/`basename $(pwd)`"'
drb(){ dri ${@:1} /bin/sh ;}
drbp(){ drip ${@:1} /bin/sh ;}
drbn(){ dri --net ${@:1} /bin/sh ;}

# run background and attach
dra() { da $(dri -d "$@") ;}
drab() { dra ${@:1} /bin/sh ;}

# exec
alias drd='dr -d'
alias da='dk attach'
alias dst='dk stop'
alias dsta='dk stop $(dk ps -a -q)'
alias drst='dk restart'
alias dkk='dk kill'
alias de='dk exec'
alias dcd='docker-compose down'
dcu(){ docker-compose ${@:1} up ;}
dcud(){ docker-compose ${@:1} up -d ;}
dcs(){ docker-compose scale ${@:1} ;}

# building
alias dt='dk tag'
alias dhub='dk search'
alias dp='dk push'
alias dcm='dk commit'
db(){
	if [ -z $2 ]; then
		dk build -t $1 .
	else
		dk build -t ${@:1}
	fi
}

# cleanup
alias drmc='dk rm'
alias drmca='dk rm $(dk ps -a -q)'
alias drmi='dk rmi'
#todo  docker rmi -f $(docker images -q -a -f dangling=true)
dic(){ drmi $(di | grep '<none>' | awk '{print $3}') ;}

# volumes
alias dv='dk volume ls'
alias dvd='dv -f dangling=true'
alias dvc='dk volume create --name'
alias drmv='dk volume rm'
alias drmva='drmv $(dv -q)'
alias drmvd='drmv $(dvd -q)'

# monitoring
alias di='dk images'
alias dc='dk ps -a'
alias dl='dk logs'
alias dip='dk inspect'
alias ds='dk stats'
alias dstats='dk stats --all'
alias dtop='dk top'
alias dport='dk ports'
alias ddiff='dk diff'

# networking
alias dn='dk network ls'
alias drmn='dk network rm'
alias dni='dk network inspect'

# import/export
diexport(){
	echo "${$1/\\//.}"
	#docker save -o "${$1/\//.}" $1
}

#TODO: alias for image removal from registry
#curl -u<user:password> -X DELETE "<Artifactory URL>/<Docker v2 repository name>/<namespace>:<tag>"

ins-docker(){
	version='latest'
	# download and install docker into '/usr/bin'
	wget "https://get.docker.com/builds/Linux/x86_64/docker-${version}.tgz"
	tar -xvzf docker-latest.tgz
	sudo mv docker/* /usr/bin/
	# create docker group
	sudo groupadd docker
	sudo usermod -aG docker $USER
	rmdir docker-latest.tgz
	# add systemd scripts for docker deamon
	sudo wget 'https://raw.githubusercontent.com/docker/docker/master/contrib/init/systemd/docker.service' -P /etc/systemd/system
	sudo wget 'https://raw.githubusercontent.com/docker/docker/master/contrib/init/systemd/docker.socket' -P /etc/systemd/system
	sudo systemctl enable docker
	# install docker-compose
	curl -L "https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m`" > docker-compose
	sudo mv docker-compose /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	# verify
	docker --version
	docker-compose --version
}


# cp to rc if behind a proxy for higher-level tools like docker compose
# proxy_ip="<PROXY>:<PORT>"
# build_proxy_args="--build-arg http_proxy=http://$proxy_ip \
# 	--build-arg https_proxy=https://$proxy_ip \
# 	--build-arg HTTP_PROXY=http://$proxy_ip \
# 	--build-arg HTTPS_PROXY=https://$proxy_ip"
# function docker {
# 	if [[ "$1" = "build" ]]; then
# 		command docker build $build_proxy_args "${@:2}"
# 	else
# 		command docker "${@:1}"
# 	fi
# }
