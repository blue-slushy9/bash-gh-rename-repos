#!/bin/bash

# First we create a text file of all of my existing GitHub repos;
# Since I only have 100 repos, I can set the limit at -L 110, to be safe;
# Please note that as my computer is already linked to my GitHub 
# account via GitHub CLI, I do not need to specify the user;
# We use ">" to export the output to a text file for later use,
# which will go in our working directory (the local repo of this script);
gh repo list -L 110 > ./gh_repos.txt

# Next we go through each line in our text file and see if it contains ".py",
# as it is primarily Python repos which I will be renaming;

# Specify filepath of our list of repos;
repolist="./gh_repos.txt"

# Verify our repolist exists;
if [ -f "$repolist" ]; then
    # Open the file and read it line by line;
    while IFS= read -r line; do
        # 