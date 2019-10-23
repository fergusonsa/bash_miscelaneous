#! /bin/bash

# Save the current working directory
orig_directory=`pwd`

# Get the current directory if not provided as a parameter
if [ "$1" != "" ] ; then 
    working_directory=$1
else
    working_directory=`pwd`
fi
echo -e "\nShowing git status for subdirectories of $working_directory"

# For each subdirectory that contain a .git directory
for subdir in $working_directory/*
do
    if [ -d "$subdir/.git" ] ; then
        # echo -e "\n\ngit status for \e[36m$subdir\e[0m"
        msg_str=""
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
        mod_str=''
        rest_str=''
        branch_str=''
        for i in $var; do
            if [[ $i == "On branch "* ]]; then
                branch_str="$i"
            else
                if [[ $i == "Your branch is behind "* ]]; then
                    # echo -e "\e[91m$i\e[0m"
                    msg_str="$msg_str       \e[91m$i\e[0m"
                else
                    if [[ $i == "Your branch is up to date with '"* ]]; then
                        # echo -e "\e[32m$i\e[0m"
                        msg_str="$msg_str       \e[32m$i\e[0m"
                    else
                        if [[ $i == *"modified:"* ]]; then
                            # echo -e "\e[95m$i\e[0m"
                            mod_str="$mod_str       \e[95m$i\e[0m\n"
                        else
                            if [[ $i == "modified:"* ]]; then
                                # echo -e "\e[93m$i\e[0m"
                                mod_str="$mod_str       \e[32m$i\e[0m\n"
                            else
                                if [[ $i != "nothing to commit"* && $i != *" \"git "* && $i != *"Changes not staged for commit:"* ]]; then
                                    rest_str="$rest_str       $i\n"
                                    # echo -e "$i"
                                fi
                            fi
                        fi  
                    fi
                fi
            fi
        done
        echo -en "\n\e[36m$subdir\e[0m"
        for ((i=0; i< (50 - ${#subdir}); i++)){ echo -n " "; }
        echo -en $branch_str
        for ((i=0; i< (40 - ${#branch_str}); i++)){ echo -n " "; }
        echo -e $msg_str
        if [[ $mod_str != '' ]]; then
            echo -en $mod_str
        fi
        if [[ $rest_str != '' ]]; then
            echo -en $rest_str
        fi
    fi
done

# Change back to the original working directory
cd $orig_directory
echo -e "\nDone."
