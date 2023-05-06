checkNewValue() {
  newValue=$1
  lineTwoNumOfFied=$2
  if [ $lineTwoNumOfFied == "string" ]; then
    if [[ $newValue =~ ^[a-zA-z_]+[\ 0-9a-zA-Z_]*$ ]]; then
      return 1
    else
      return 0
    fi
  else
    if [[ $newValue =~ ^[0-9]+$ ]]; then
      return 1
    else
      return 0
    fi
  fi
}

update_in_table() {
  column=$1
  table=$2
  export column
  export uniq
  export numOfField
  export numOfUpdateField
  export newValue
  index=1
  for columnUser in ${lineOne//:/ }; do
    if [ $columnUser == $column ]; then
      numOfUpdateField=$index
    fi
    index=$((index + 1))
  done
  numOfUpdateField=$(($numOfUpdateField + 1))
  lineTwoNumOfFied=$(sed -n '2p' $table | cut "-f$numOfUpdateField" -d :)
  read -p "$column = " newValue
  if [ -z $newValue ]; then
    echo "'error' empty value"
    return;
  fi
  checkNewValue $newValue $lineTwoNumOfFied
  result=$?
  if [ $result == 0 ]; then
    echo "Your data $newValue not valid"
    exit
  fi
  echo "Where:"
  read -p "${lineOneFieldOne} = " uniq
  numOfField=$(awk -F : '
  BEGIN{ numOfField=1 }
  {
    if (NR >= 3){
      if ($1 == ENVIRON["uniq"]){
        print $0
        for (i=1; i<=NF; i++) {
          if ($i == $ENVIRON["numOfUpdateField"])
          {
            $i=ENVIRON["newValue"]
          }
          printf("%s%s", $i, (i < NF) ? ":" : (i == NF) ? ORS : OFS)
        }
        print NR
      }
    }
  }' $table)
  joinByChar() {
    oldValue=$1
    newValue=$2
    uniq=$3
  }
  if [ -z "$numOfField" ]; then
    echo "'error' id not found"
    return;
  fi
  joinByChar $numOfField
  sed -i "$uniq s/$oldValue/$newValue/g" $table
  echo "updated successfully"
}
read -p "Enter the name of table: " table
if [[ -f $table ]]; then
  lineOne=$(sed -n '1p' $table)
  lineOneFieldOne=$(sed -n '1p' $table | cut -f1 -d :)
  lineOne=${lineOne//"$lineOneFieldOne:"/ }
  checkEmptyData=$(sed -n '3p' $table)
  if [ -z $checkEmptyData ]; then
    echo "'error' not found any data in this table"
    exit
  fi
  echo "Set:"
  select column in ${lineOne//:/ }; do
    if [ -z $column ]; then
      echo "'error' not found"
      break
    else
      update_in_table $column $table
      break
    fi
  done
else
  echo "'error' Table $table not found"
fi
