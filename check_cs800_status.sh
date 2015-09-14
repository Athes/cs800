#!/bin/bash
#
# Fujitsu CS800 status checker v1.2
#
# Coded by: Topa Zoltan
# Checked by: Tokaji Attila
#
#
ssh cliviewer@$1 syscli --getstatus syscomponent --systemboard|grep Status|tr -d " "|awk -F "=" '{print $2}' > /var/tmp/nagios/cs800_$1_chk
ssh cliviewer@$1 syscli --getstatus syscomponent --networkport|grep Status|tr -d " "|awk -F "=" '{print $2}' >> /var/tmp/nagios/cs800_$1_chk
ssh cliviewer@$1 syscli --getstatus syscomponent --hba|grep Status|tr -d " "|awk -F "=" '{print $2}' >> /var/tmp/nagios/cs800_$1_chk
ssh cliviewer@$1 syscli --getstatus storagearray|grep Status|tr -d " "|awk -F "=" '{print $2}' >> /var/tmp/nagios/cs800_$1_chk
#
# generating status, 0 is normal
STATUS=`grep -v -c Normal /var/tmp/nagios/cs800_$1_chk`

# checking status
if [[ $STATUS == "0" ]];then
retcode=0
echo "System state: Normal"
else
retcode=2
echo "System state: Failed"
fi
# remove the status file
rm -fr /var/tmp/nagios/cs800_$1_chk
exit $retcode
