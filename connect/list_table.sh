num=0
for tables in *; do
  if [[ -f $tables ]]; then
    num=$((num + 1))
    echo "$num- $tables"
  fi
done
