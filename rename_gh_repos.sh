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

# We will look for this substring in each line (i.e. repo name), because all of
# of my Python repo names used to end in ".py";
substring=".py"

# Verify our repolist exists;
if [ -f "$repolist1" ]; then
    # Open the file and read it line by line, until source is exhausted;
    while IFS= read -r line; do
        # Look for our substring inside of every line (i.e. repo name);
        if [[ $line == *"$substring"* ]]; then
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

# We need to assign out new repolist to a variable to use it in our next loop;
repolist2="./gh_repos2.txt"

# Next we loop through each line (i.e. repo name) in our second list, and we insert the repo name
# into our GitHub CLI command that will rename it into the standard format I have developed;
command="gh repo rename -R blue-slushy9/$old_name $new_name"

# Verify our second repolist exists;
if [ -f "$repolist2" ]; then
    # Open the file and read it line by line, until source is exhausted;
    while IFS= read -r line; do
        old_name="$line"
        # First we drop the ".py";
        new_name="${old_name%*(.py)}"
        # DEBUG
        echo "$new_name"
    done < "$repolist2"
fi
