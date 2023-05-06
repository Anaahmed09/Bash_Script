condition() {
  column=$1
  table=$2
  read -p "$column = " valueOfCondition
  export column
  export valueOfCondition
  numLines=$(awk -F : '
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
        print NR"d"
      }
    }
  }' $table)
  joinByChar() {
    local IFS="$1"
    shift
    numLineSedDelete="$*"
  }
  joinByChar ";" $numLines
  sed -i "$numLineSedDelete" $table
  echo "Deleted Successfully"
}
read -p "Enter the name of table:" table
if [[ -f $table ]]; then
  select method in Delete_All_Data Delete_By_Column; do
    case $method in
    Delete_All_Data)
      sed -i '3,$d' $table
      echo "Deleted Successfully"
      break
      ;;
    Delete_By_Column)
      lineOne=$(sed -n '1p' $table)
      echo "Where:"
      select column in ${lineOne//:/ }; do
        if [ -z $column ]; then
          echo "exit"
          break
        else
          condition $column $table
          break
        fi
      done
      ;;
    *)
      exit
      ;;
    esac
  done
else
  echo "'error' Table $table not found"
fi
