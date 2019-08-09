#! /bin/bash

# Save the current working directory
orig_directory=`pwd`

# Get the current directory if not provided as a parameter
if [ "$1" != "" ] ; then 
    working_directory=$1
else
    working_directory=`pwd`
fi
echo -e "\n\n\nShowing git status for subdirectories of $working_directory\n"

# For each subdirectory that contain a .git directory
for subdir in $working_directory/*
do
    if [ -d "$subdir/.git" ] ; then
        echo -e "\n\ngit status for \e[36m$subdir\e[0m"
        # Change working directory to the subdirectory
        cd "$subdir"
        IFS=$'\n'
        var=$(git remote update 2>&1)
        for i in $var; do
            if [[ $i != "Fetching origin"* ]]; then
                echo -e "$i"
            fi
        done
        var=$(git status -uno 2>&1)
        IFS=$'\n'
        for i in $var; do
            if [[ $i == "Your branch is behind "* ]]; then
                echo -e "\e[91m$i\e[0m"
            else
                if [[ $i == *"modified:"* ]]; then
                    echo -e "\e[95m$i\e[0m"
                else
                    if [[ $i == "modified:"* ]]; then
                        echo -e "\e[93m$i\e[0m"
                    else
                        if [[ $i != "nothing to commit"* ]]; then
                            echo -e "$i"
                        fi  
                    fi
                fi
            fi
        done
    fi
done

# Change back to the original working directory
cd $orig_directory
echo -e "\nDone."
