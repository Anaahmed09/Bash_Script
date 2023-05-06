checkFoundFile() {
  if ! [[ -f $* ]]; then
    touch $*
    return 1
  fi
  return 0
}
unValid=1
while [ $unValid == 1 ]; do
  read -p "Enter Table Name: " fulltableName
  if [[ $fulltableName =~ ^[a-zA-z_]+[\ 0-9a-zA-Z_]*$ ]]; then
    tableName="${fulltableName// /_}"
    checkFoundFile $tableName
    result=$?
    if [ $result == 1 ]; then
      echo "Success to created $tableName"
    else
      echo "'error' This Data Base already exists"
      return 0
    fi
    unValid=0

  else
    echo "'error' You enter unvalid table please try again"
    return 0
  fi
done

read -p "Enter The Number Of Colums: " num_columns
echo "Enter Names Of Columns"
columns=()
type=()
data=""
dataType=""
for ((i = 0; i < num_columns; i++)); do
  read -p "Column $((i + 1)): " column
  read -p "data type of $((i + 1)) Integer / String (int/string):" data_type
  if [[ "$data_type" == "int" || "$data_type" == "string" ]]; then
    type+=("$data_type")
    columns+=("$column")
  else
    echo "you are wrong!!!"
  fi
done
for ((i = 0; i < num_columns; i++)); do
  data+="${columns[$i]}:"
  dataType+="${type[$i]}:"
done

data="${data%?}"
dataType="${dataType%?}"

echo "$data" >>"$tableName"
echo "$dataType" >>"$tableName"
