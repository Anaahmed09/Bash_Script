read -p "Enter The Name Of DataBase : " db_name
if [[ -d $db_name ]]; then
  rm -r $db_name
  echo "DataBase $db_name has been removed."
else
  echo "Not found"
fi

# read -p "Enter The Name Of DataBase : " db_name
# if [[ -d "./DataBase/$db_name" ]]; then
# rm -r "./DataBase/$db_name"
# echo "DataBase has been removed ."
# else
# echo "Not Found"
# fi
