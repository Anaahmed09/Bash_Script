checkFoundDirctory() {
  if ! [[ -d $* ]]; then
    mkdir $*
    return 1
  fi
  return 0
}
unValid=1
while [ $unValid == 1 ]; do
  read -p "Enter DataBase: " fulldataBaseName
  if [[ $fulldataBaseName =~ ^[a-zA-z_]+[\ 0-9a-zA-Z_]*$ ]]; then
    dataBaseName="${fulldataBaseName// /_}"
    checkFoundDirctory $dataBaseName
    result=$?
    if [ $result == 1 ]; then
      echo "Success to created $dataBaseName"
    else
      echo "'error' This Data Base already exists"
    fi
    unValid=0
  else
    echo "'error' You enter unvalid database please try again"
  fi
done

