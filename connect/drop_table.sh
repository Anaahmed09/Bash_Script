read -p "Enter The Name Of Table : " db_name
if [[ -f $db_name ]]; then
  rm -r $db_name
  echo "Table has been removed."
else
  echo "Not found"
fi
