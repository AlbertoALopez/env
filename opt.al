#!/bin/bash

# ignore in containers
iscontainer && return 0

# environment variables
export opt_root='/opt'
#export SCALA_HOME="${opt_root}/scala/cur"
#export GRADLE_HOME="${opt_root}/gradle/cur"
#export NODE_HOME="${opt_root}/node/cur/bin"
#export PATH=$PATH:$NODE_HOME

# java
export JAVA_HOME="${opt_root}/java/cur"
alias java="$JAVA_HOME/bin/java"

# launchers
#alias atom="${opt_root}/atom/cur/atom"
#alias sublime="${opt_root}/sublime/cur/sublime_text"
#alias teli="${opt_root}/teli/cur/bin/idea.sh &"
#alias charm="${opt_root}/pycharm/cur/bin/pycharm.sh &"
#alias eclipse="${opt_root}/eclipse/cur/eclipse &"
#alias scala="$SCALA_HOME/bin/scala"
#alias gradle="$GRADLE_HOME/bin/gradle"
#alias sbt="${opt_root}/sbt/cur/bin/sbt"
#alias gradle="drn frekele/gradle pwd"
#alias mvn="${opt_root}/mvn/cur/bin/mvn"
#alias squirrel="java -jar ${opt_root}/squirrel/cur/squirrel-sql.jar"

env_bootstrap_cmd(){ echo 'curl https://raw.githubusercontent.com/rbi13/env/master/install.sh | sh && source ~/.bashrc' | cbcopy ;}

#functions
# make a public directory for a new app in opt_root
mkdiropt(){
	installdir="${opt_root}/$1"
	sudo mkdir -p ${installdir}
	sudo chmod a+rw ${installdir}
	cd ${installdir}
}

# switch version of an opp i opt_root
verset(){
	ln -nfs $1 cur
}

# links
# pandoc
# https://github.com/jgm/pandoc/releases/download/1.17.2/pandoc-1.17.2-1-amd64.deb
