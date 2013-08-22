if [ -z "$HOME" ]
then
  echo HOME not in environment, guessing...
  export HOME=$(awk -F: -v v="$USER" '{if ($1==v) print $6}' /etc/passwd)
fi

if [$UBUNTU]; then
	cd $WORKSPACE
	mkdir -p ../ubuntu
	cd ../ubuntu
	export WORKSPACE=$PWD

	if [ ! -d phablet_tools ]
	then
		git clone git://github.com/rodero95/phablet_tools.git
	fi
	
	cd phablet_tools
	## Get rid of possible local changes
	git reset --hard
	git pull -s resolve
	cd ..
else
	cd $WORKSPACE
	mkdir -p ../android
	cd ../android
	export WORKSPACE=$PWD
fi
	
if [ ! -d cm_jenkins ]
then
  git clone git://github.com/rodero95/cm_jenkins.git
fi

cd cm_jenkins
## Get rid of possible local changes
git reset --hard
git pull -s resolve

if [$UBUNTU]; then
	exec ./ubuntu.sh
else
	exec ./build.sh
fi