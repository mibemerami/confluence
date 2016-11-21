#!/bin/bash

######## Write things to do on start up here ########################
echo 'docker-entrypoint.sh in the Jira container has been started.';

#define variables
HELP_TEXT="To set the RAM size for the JVM, type:
--min-memory <RAM-in-MB> --max-memory <RAM-in-MB>
other arguments are currently not supported."
base_command="python /root/docker-scripts/change_JVM_in_setenv_sh.py"
opt1=""
opt2=""
to_run=""

#loop over the arguments passed and forward them
while [ $# -gt 0 ]
do
	echo "Arguments: ${#}"
        if [ $1 == "--min-memory" ]
                then
                        shift
                        opt1="--min-memory ${1}"
                elif [ $1 == "--max-memory" ]
                then
                        shift
                        opt2="--max-memory ${1}"
                else
                        echo "$HELP_TEXT"
        fi
        shift
done

to_run="${base_command} ${opt1} ${opt2}"

echo "start script to patch setenv.sh"
$to_run

########## Start actual process ######################################
echo "start confluence"
exec /opt/atlassian/confluence/bin/start-confluence.sh -fg confluenceuser

