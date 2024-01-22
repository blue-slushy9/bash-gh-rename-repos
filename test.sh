string="animals.py"

#cut_string=$(cut -d '.' $string)

cut_string=$(echo "$string" | cut -d '.' -f 1)

echo "$cut_string"
