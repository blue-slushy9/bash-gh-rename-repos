#!/bin/bash

# First we create a text file of all of my existing GitHub repos;
# Since I only have 100 repos, I can set the limit at -L 110, to be safe;
# Please note that as my computer is already linked to my GitHub 
# account via GitHub CLI, I do not need to specify the user;
# We use ">" to export the output to a text file for later use,
# which will go in our working directory (the local repo of this script);
gh repo list -L 110 > ./gh_repos1.txt

# Next we go through each line in our text file and see if it contains ".py",
# as it is primarily Python repos which I will be renaming;

# Specify filepath of our list of repos;
repolist="./gh_repos1.txt"

# We will look for this substring in each line (i.e. repo name), because all of
# of my Python repo names used to end in ".py";
substring=".py"

# Verify our repolist exists;
if [ -f "$repolist" ]; then
    # Open the file and read it line by line, until source is exhausted;
    while IFS= read -r line; do
        # Look for our substring inside of every line (i.e. repo name);
        if [[ $line == *"$substring"* ]]; then
            # Trim the trailing whitespaces, etc. to leave only "blue-slushy9/<repo-name>";
            trim_line="${line%"${line##*[![:space:]]}"}"
            # DEBUG
            echo "$trim_line" >> gh_repos2.txt
        fi
    # Redirects the input of the while loop to come from a specified file, e.g. our repolist;    
    done < "$repolist"
fi