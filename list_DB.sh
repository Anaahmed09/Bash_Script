num=0
for dir in *; do
  if [[ -d "$dir" ]]; then
    num=$((num + 1))
    echo "$num- $dir"
  fi
done
