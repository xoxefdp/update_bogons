#!/bin/bash

DATESTAMP=$(date +"%F-%H-%M-%S-%N")

# 
# printf "EXECUTING --> curl --silent 'http://www.team-cymru.org/Services/Bogons/fullbogons-ipv4.txt' -o unfiltered_ipv4_data.txt \n"
curl --silent 'https://www.team-cymru.org/Services/Bogons/fullbogons-ipv4.txt' -o unfiltered_ipv4_data.txt

# backup origin reference date for bogons
# printf "EXECUTING --> mv modified_origin_date.txt backup/$DATESTAMP-modified_origin_date.txt \n"
# mv modified_origin_date.txt backup/$DATESTAMP-modified_origin_date.txt
# if [ -s updated_date.txt ]
# then
#   mkdir -p backup
#   mv updated_date.txt backup/$DATESTAMP-updated_date.txt
# else
#   touch updated_date.txt
# fi

# backup used bogons for new version
# printf "EXECUTING --> mv bogons_ipv4.txt backup/$DATESTAMP-bogons_ipv4.txt \n"
# mv bogons_ipv4.txt backup/$DATESTAMP-bogons_ipv4.txt
if [ -s bogons_ipv4.txt ]
then
  mkdir -p backup_ipv4
  mv bogons_ipv4.txt backup_ipv4/$DATESTAMP-bogons_ipv4.txt
else
  touch bogons_ipv4.txt
fi

# 
# printf "EXECUTING --> cat unfiltered_ipv4_data.txt | > updated_ipv4_bogons_date.txt \n"
head -n1 unfiltered_ipv4_data.txt > updated_ipv4_bogons_date.txt

# 
# printf "EXECUTING --> cat unfiltered_ipv4_data.txt | > bogons_ipv4.txt \n"
sed 1,1d unfiltered_ipv4_data.txt > bogons_ipv4.txt

# 
# printf "EXECUTING --> rm unfiltered_ipv4_data.txt \n"
rm unfiltered_ipv4_data.txt

# printf 'DONE UDATING BOGONS \n'