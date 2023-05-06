#! /usr/bin/bash
export LC_COLLATE=C # Case Sensitive
shopt -s extglob    # Active Regex
checkFoundDirctory() {
  if ! [[ -d $* ]]; then
    mkdir $*
    return 1
  fi
  return 0
}
checkFoundDirctory DataBase
mainList() {
  cd DataBase
  select mainQuery in create_DB list_DB drop_DB connect_DB; do
    case $mainQuery in
    create_DB)
      . create_DB.sh
      ;;
    list_DB)
      . list_DB.sh
      ;;
    drop_DB)
      . drop_DB.sh
      ;;
    connect_DB)
      connect_DB.sh
      ;;
    *)
      exit
      ;;
    esac
  done
}
mainList
