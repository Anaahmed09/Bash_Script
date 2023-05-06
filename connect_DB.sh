connectionList() {
  select options in list_table drop_table create_table insert_in_table select_from_table delete_from_table update_in_table; do
    case $options in
    list_table)
      . list_table.sh
      ;;
    drop_table)
      . drop_table.sh
      ;;
    create_table)
      . create_table.sh
      ;;
    insert_in_table)
      insert_in_table.sh
      ;;
    select_from_table)
      select_from_table.sh
      ;;
    delete_from_table)
      delete_from_table.sh
      ;;
    update_in_table)
      update_in_table.sh
      ;;
    *)
      PS3=""
      exit
      ;;
    esac
  done
}
unValid=1
while [ $unValid == 1 ]; do
  read -p "Enter DataBase: " fulldataBaseName
  if [[ $fulldataBaseName =~ ^[a-zA-z_]+[\ 0-9a-zA-Z_]*$ ]]; then
    dataBaseName="${fulldataBaseName// /_}"
    if [[ -d $dataBaseName ]]; then
      cd $dataBaseName
      echo "Connection successed"
      PS3="$dataBaseName >> "
      connectionList
    else
      echo "'error' Data Base $dataBaseName not found"
    fi
    unValid=0
  else
    echo "'error' You enter unvalid database please try again"
  fi
done
