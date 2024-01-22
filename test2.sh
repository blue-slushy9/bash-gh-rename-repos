string="pos_computer_store"

replacer="-"

original="_"

new_string=$(echo "$string" | tr "$original" "$replacer")

echo "$new_string"
