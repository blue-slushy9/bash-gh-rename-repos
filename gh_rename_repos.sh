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

# Specify filepath of our list of repos;
repolist1="./gh_repos1.txt"

# We will look for this suffix in each line (i.e. repo name), because all of
# of my Python repo names used to end in ".py";
suffix=".py"

# Verify our repolist exists;
if [ -f "$repolist1" ]; then
    # Open the repolist and read it line by line, until all entries are exhausted;
    while IFS= read -r line; do
        # Look for our suffix inside of every line (i.e. repo name);
        if [[ $line == *"$suffix"* ]]; then
            # Trim anything before the "/", inclusive;
            trim_line="${line#*/}"
            # Output the trimmed line (i.e. repo name) to our final list;
            # >> means append versus overwrite (>);
            echo "$trim_line" >> gh_repos2.txt
        fi
    # done signifies end of while loop;
    # < redirects the input of the while loop to come from a specified file, e.g. our repolist;  
    done < "$repolist1"
# Signifies end of if statement;
fi

# We need to assign our new repolist to a variable to use it in our next loop;
repolist2="./gh_repos2.txt"

# The old repo names contain underscores, new format uses dashes;
underscore="_"

# We will replace all underscores in the old repo names with dashes;
dash="-"

# We will add this prefix to all of the repo names that used to end in ".py";
prefix="py-"

# Verify our second repolist exists;
if [ -f "$repolist2" ]; then
    # Open the repolist and read it line by line, until all entries are exhausted;
    while IFS= read -r line; do
        # The old name is exactly as it appears on each line;
	    old_name="$line"
        # To update the repo names, first we drop the ".py"; to do this, we pipe the old name
        # into the cut function with the delimiter '.' and -f 1, meaning the first field,
        # i.e. everything before the first instance of '.' is what we keep;
	    new_name=$(echo "$old_name" | cut -d '.' -f 1)
	    # Next we replace the underscores with dashes;
	    new_name=$(echo "$new_name" | tr "$underscore" "$dash")
	    # Finally we add "py-" to the beginning; 
	    new_name="$prefix$new_name"
	    # Our command string has to be defined inside of the while loop in order to define
        # the name variables with each successive line of our repolist2;
	    command="gh repo rename -R blue-slushy9/$old_name $new_name"
	    # Finally, we run our command string as a bash/gh command with eval;
	    eval "$command"
    # Redirects the input of the while loop to come from a specified file, e.g. our repolist;
    done < "$repolist2"
# Signifies end of if statement;
fi

# Clean up the two text files that get created in the process of running this script;
rm -f "$repolist1" "$repolist2"
