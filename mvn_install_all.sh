#! /bin/bash

# Save the current working directory
orig_directory=`pwd`

if [ -d "/cygdrive/p/reports" ] ; then
    reports_directory="/cygdrive/p/reports"
else
    reports_directory="/home/fergusos/reports"
fi

working_directory="/cygdrive/c/dev/finance/eclipse_workspace"

for subdir in $working_directory/*
do
    echo -e "\nsubdir '$subdir'\n"
    subdir_name=$(basename "${subdir}")
    if [ -f "$subdir/pom.xml" ] ; then
        echo "Attempting to run maven install for $subdir_name"
        # Change working directory to the subdirectory
        cd "$subdir"
        report_file="$reports_directory/maven_install_$subdir_name-$(date -d "today" +"%Y%m%d%H%M").txt"
        
        mvn clean install -U > $report_file 2>&1
        echo "Output of 'mvn clean install -U' for $subdir_name in $report_file"
        
        if grep -q "BUILD SUCCESS" "$report_file"; then
            echo -e "\nmvn clean install -U for $subdir_name successful!\n"
            grep -F " SUCCESS [ " "$report_file"
            grep -F "[INFO] Installing " "$report_file"
        
        else
           
            echo -e "\n\n*********************************\nmvn clean install -U for $subdir_name failed!\n"
            grep -F "[INFO] Installing " "$report_file"
            grep -F " SUCCESS [" "$report_file"
            grep -F " FAILURE [" "$report_file"
            grep -F " SKIPPED" "$report_file"
        fi
        echo -e "\n"
    fi
done

# Change back to the original working directory
cd $orig_directory
echo "Done."
