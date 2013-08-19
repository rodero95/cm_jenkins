if [ -z "$HOME" ]
then
  echo HOME not in environment, guessing...
  export HOME=$(awk -F: -v v="$USER" '{if ($1==v) print $6}' /etc/passwd)
fi

if [ -z "$CMTREE" ]
then
  echo CMTREE not specified
  exit 1
fi

cd $CMTREE

curl -O https://gist.github.com/rodero95/5621859/raw/kernel.sh

exec ./kernel.sh
