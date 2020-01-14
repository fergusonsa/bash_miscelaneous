#! /bin/bash

# Save the current working directory
orig_directory=`pwd`

old_workspace=/cygdrive/c/dev/hague/id_filing_workspace
new_workspace=/cygdrive/c/dev/hague/new_workspace
if [ -d "$new_workspace" ] ; then
    echo Deleting existing $new_workspace
    rm -fr $new_workspace
fi
echo Creating new workspace in $new_workspace
mkdir $new_workspace

for dir in $old_workspace/*/; do
    dir=${dir%*/}
    if [ -d "$dir/.git" ] ; then
        echo $dir
        cd $dir
        remote_url=$(git config --get remote.origin.url)
        branch=$(git rev-parse --abbrev-ref HEAD)
        if [[ "$branch" != "" &&  "$remote_url" != "" ]]; then
            cd $new_workspace
            git clone $remote_url
            dirname="$(basename "$dir")"
            cd $dirname
            git checkout $branch
        fi
    else
        echo $dir is not a git repo directory!
    fi
done

# Change back to the original working directory
cd $orig_directory
echo -e "\nDone."
