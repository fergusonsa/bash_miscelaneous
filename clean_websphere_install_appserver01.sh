websphere_install_dir=/cygdrive/c/devtools/websphere/IBM/WebSphere/AppServer/profiles/AppSrv01
directories=(temp wstemp)

# For each subdirectory that contain a .git directory
for subdir in ${directories[@]}; do
    working_directory=$websphere_install_dir/$subdir
    if [ -d "$working_directory" ] ; then
        echo -e "\n\nCleaning out contents of $working_directory.."
        rm -r $working_directory/*
    else
        echo -e "\n\nCannot find directory $working_directory to clean."
    fi
done

echo -e "\nDone."
