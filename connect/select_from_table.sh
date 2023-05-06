select_all() {
  read -p "Enter the name of table: " table
  if [[ -f $table ]]; then
    sed -n '3,$p' $table
  else
    echo "'error' Table $table not found"
  fi
}
condition() {
  column=$1
  table=$2
  read -p "$column = " valueOfCondition
  export column
  export valueOfCondition
  awk -F : '
  BEGIN{ numOfField=1 }
  {
    if (NR == 1){
      for(i=1; i<=NF; i++){
        if ($i == ENVIRON["column"]){
          numOfField = i
        }
      }
    }
    if (NR >= 3){
      if ($numOfField == ENVIRON["valueOfCondition"]){
        print $0
      }
    }
  }' $table
}
conditionTwo() {
  export column
  export numOfField
  export valueOfCondition
  table=$2
  local -n arrColumns=$3
  declare -a arrNumbersOfProjection
  for i in ${arrColumns[@]}; do
    column=$i
    numOfField=$(awk -F : '
    BEGIN{ ENVIRON["numOfField"]=1 }
    {
    if (NR == 1){
      for(i=1; i<=NF; i++){
        if ($i == ENVIRON["column"]){
          ENVIRON["numOfField"] = i
        }
      }
      print ENVIRON["numOfField"]
    }
    } 
    ' $table)
    arrNumbersOfProjection+=($numOfField)
  done
  joinByChar() {
    local IFS="$1"
    shift
    fieldsToCommandCut="-f$*"
  }
  joinByChar , ${arrNumbersOfProjection[@]}
  column=$1
  read -p "$column = " valueOfCondition
  awk -F : '
  BEGIN{ numOfField=1 }
  {
    if (NR == 1){
      for(i=1; i<=NF; i++){
        if ($i == ENVIRON["column"]){
          numOfField = i
        }
      }
    }
    if (NR >= 3){
      if ($numOfField == ENVIRON["valueOfCondition"]){
        print $0
      }
    }
  }' $table | cut "$fieldsToCommandCut" -d :
}

select_rows_selection() {
  read -p "Enter the name of table: " table
  if [[ -f $table ]]; then
    lineOne=$(sed -n '1p' $table)
    echo "Where:"
    select column in ${lineOne//:/ }; do
      if [ -z $column ]; then
        break
      else
        condition $column $table
        break
      fi
    done
  else
    echo "'error' Table $table not found"
  fi
}

checkColumns() {
  table=$1
  local -n arrColumns=$2
  lineOne=$(sed -n '1p' $table)
  check=0
  for columnUser in ${arrColumns[@]}; do
    for column in ${lineOne//:/ }; do
      if [ $columnUser == $column ]; then
        check=1
      fi
    done
    if [ $check == 0 ]; then
      echo "'error' this column $columnUser not found"
      return 1;
    fi
  done
}

select_rows_projection() {
  read -p "Enter the name of table: " table
  if [[ -f $table ]]; then
    lineOne=$(sed -n '1p' $table)
    echo "Choose any columns => " ${lineOne//:/ }
    read -p "Enter the names of columns: " projections
    checkColumns $table projections
    result=$?
    if [ $result == 1 ]; then
      return;
    fi
    echo "Where:"
    select column in ${lineOne//:/ }; do
      if [ -z $column ]; then
        break
      else
        conditionTwo $column $table projections
        break
      fi
    done
  else
    echo "'error' Table $table not found"
  fi
}
select method in Select_All Select_Rows_selection Select_Rows_projection; do
  case $method in
  Select_All)
    select_all
    ;;
  Select_Rows_selection)
    select_rows_selection
    ;;
  Select_Rows_projection)
    select_rows_projection
    ;;
  *)
    exit
    ;;
  esac
done
