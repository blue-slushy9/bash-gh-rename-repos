#!/bin/bash

# First we create a text file of all of my existing GitHub repos;
# Since I only have 100 repos, I can set the limit at -L 110, to be safe;
# Please note that as my computer is already linked to my GitHub 
# account via GitHub CLI, I do not need to specify the user;
# We use ">" to export the output to a text file for later use,
# which will go in our working directory (the local repo of this script);
# The awk command ensures only the first column of the table is output,
# we do not need the repo metadata, only the names;
gh repo list -L 110 | awk '{print $1}' > ./gh_repos1.txt

# Next we go through each line in our text file and see if it contains ".py",
# as it is primarily Python repos which I will be renaming;

# Specify filepath of our list of repos;
repolist1="./gh_repos1.txt"

# We will look for this suffix in each line (i.e. repo name), because all of
# of my Python repo names used to end in ".py";
suffix=".py"

# Verify our repolist exists;
if [ -f "$repolist1" ]; then
    # Open the file and read it line by line, until source is exhausted;
    while IFS= read -r line; do
        # Look for our suffix inside of every line (i.e. repo name);
        if [[ $line == *"$suffix"* ]]; then
            # Trim anything before the "/", inclusive;
            trim_line="${line#*/}"
            # Then trim everything after the ".py";
            #echo "${line%%*(.py)}"
            #trim_line="${line%*(.py)}"
            
            # Output the trimmed line (i.e. repo name) to our final list;
            echo "$trim_line" >> gh_repos2.txt
        fi
    # Redirects the input of the while loop to come from a specified file, e.g. our repolist;    
    done < "$repolist1"
fi

# We need to assign our new repolist to a variable to use it in our next loop;
repolist2="./gh_repos2.txt"

# The old repo names contain underscores, new format uses dashes;
underscore="_"

# We will replace all underscores in the old repo names with dashes;
dash="-"

# We will add this prefix to all of the repo names that used to end in ".py";
prefix="py-"

# Next we loop through each line (i.e. repo name) in our second list, and we insert the repo name
# into our GitHub CLI command that will rename it into the standard format I have developed;
#command="gh repo rename -R blue-slushy9/$old_name $new_name"

# Verify our second repolist exists;
if [ -f "$repolist2" ]; then
    # Open the repolist and read it line by line, until source is exhausted;
    while IFS= read -r line; do
        # The old name is exactly as it appears on each line;
	old_name="$line"
        # To update the repo names, first we drop the ".py";
        #new_name="${old_name%*(.py)}"
	new_name=$(echo "$old_name" | cut -d '.' -f 1)
	# DEBUG
        #echo "$new_name"
	# Next we replace the underscores with dashes;
	new_name=$(echo "$new_name" | tr "$underscore" "$dash")
	# DEBUG
	#echo "$new_name"
	# Finally we add "py-" to the beginning; 
	new_name="$prefix$new_name"
	# DEBUG
	#echo "$new_name"
	# NOT best practice, but couldn't get it to work outside of the function;
	command="gh repo rename -R blue-slushy9/$old_name $new_name"
	# DEBUG
	#echo "$command"
	# Finally, we run the command;
	eval "$command"
    done < "$repolist2"
fi
