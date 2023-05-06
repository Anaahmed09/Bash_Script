read -p "Enter the name of table: " table_file
IFS=':' read -r -a first_line <<<"$(sed -n 1p $table_file)"
IFS=':' read -r -a second_line <<<"$(sed -n 2p $table_file)"
regex_integer='^[0-9]+$'
regex_string='^[a-zA-Z]+$'
userdata=()
words=()


while IFS='' read -r line || [[ -n "$line" ]]; do
  first_word=$(echo "$line" | awk '{print $1}')
  words+=("$first_word")
done < <(tail -n +3 "$table_file" | cut -d: -f1)



function checkinteger() {
  if [[ $1 =~ $regex_integer ]]; then
    echo "1"
  else
    echo "0"
  fi
}
function checkstr() {
  if [[ $1 =~ $regex_string ]]; then
    echo "1"
  else
    echo "0"
  fi
}
for ((i = 0; i < ${#second_line[@]}; i++)); do
  read -p "please enter the --(${first_line[i]})-- and data type should be --(${second_line[i]})-- : " column



  
  if [[ ${second_line[i]} == "int" ]]; then
    checkint=$(checkinteger $column)
    if [[ $checkint == "1" ]]; then
     
      if [[ $i == $((${#second_line[@]} - 1)) ]]; then
        userdata+="$column"
      else
        userdata+="$column:"
      fi
      id=$(echo ${userdata[0]} | awk -F: ' {print $1}')
      if ! [[ " ${words[*]} " =~ "$id" ]]; then
        echo "The first word is unique."
      else
        echo "The first word must be unique. Please enter a different value."
        unset 'userdata[0]'
        i=$((i - 1))
      fi
    else
      i=$((i - 1))
    fi









  elif
    [[ ${second_line[i]} == "string" ]]
  then
    checkstring=$(checkstr $column)
    if [[ $checkstring == "1" ]]; then
     
      if [[ $i == $((${#second_line[@]} - 1)) ]]; then
        userdata+="$column"
      else
        userdata+="$column:"
      fi
      if ! [[ " ${words[*]} " =~ "$id" ]]; then
        echo "The first word is unique."
      else
        echo "The first word must be unique. Please enter a different value."
        unset 'userdata[0]'
        i=$((i - 1))
      fi
    else
      i=$((i - 1))
    fi
  fi
done

echo "${userdata[0]}" >>"$table_file"
