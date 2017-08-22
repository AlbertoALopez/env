#!/bin/sh
## Function list
# Docker
#
## TODO
##
# ddl=grep docker /var/log/messages

dk-jenkins(){
  # provide index multiple instances
  [ -z $1 ] && index=0 || index=$1
  name="jenk${index}"
  # data on host @ ~/jenkins/<given-name>
  # -e "JAVA_OPTS=-Djenkins.install.runSetupWizard=false"\
  drd\
    --name ${name}\
    -p "404${index}":8080 -p "4004${index}":50000\
    -v ~/jenkins/${name}:/var/jenkins_home -v ~/.ssh:/root/.ssh\
    jenk # temp -> jenkins/jenkins
  # extract initial password to clipboard
  echo "waiting for admin user creation..."
  sleep 20 # wait for password to be populated (TODO: poll instead)
  pass=`dx ${name} cat /var/jenkins_home/secrets/initialAdminPassword`
  echo ${pass} | cbcopy
}

# host folders via http
dk-nxhost(){
  path=$1
  [ -z $2 ] && port=80 || port=$2
  drcd\
    -p ${port}:80\
    -v ${path}:/usr/share/nginx/html:ro\
    rbi13/nginx-fb
}

# run a tensorflow notebook
dk-tf(){
  id=`drp -p 8888:8888 tensorflow/tensorflow`
  sleep 2
  adr=`dl ${id} 2>&1 | grep localhost`
  open ${adr}
}

# gradle
# TODO: consider using named container for gradle-daemon benefits
gradle(){ dhe gradle:alpine gradle ${@:1} ;}
# terraform
trf(){ dhe hashicorp/terraform:light ${@:1} ;}
# aws cli
aws(){ dhe xueshanf/awscli aws ${@:1} ;}
