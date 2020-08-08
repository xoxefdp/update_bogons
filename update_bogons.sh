#!/bin/bash

# https://en.wikipedia.org/wiki/ANSI_escape_code
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

printHelp() {
  printf "${NC}[*] ${GREEN}USAGE \n"
  printf "${NC}[*] ${NC} \t Downloads bogons data sources \n"
  printf "${NC}[*] ${GREEN}OPTIONS \n"
  printf "${NC}[*] ${YELLOW} \t --force      [boolean]  ${NC}Ignore checksum and replace data sources, can't be blank ${NC}\n"
  printf "${NC}[*] ${YELLOW} \t --help                  ${NC}Shows this help message \n"
  printf "${NC}[*] ${GREEN}EXAMPLES \n"
  printf "${NC}[*] ${NC} \t Download datasources whether is new data or not \n"
  printf "${NC}[*] ${YELLOW} \t\t $ ./update_bogons.sh --force true \n"
  printf "${NC}[*] ${NC} \t Download datasources if theres is new data \n"
  printf "${NC}[*] ${YELLOW} \t\t $ ./update_bogons.sh --force false \n"
}

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
  --force)
  FORCE="$2"
  shift
  ;;
  -h|--help)
  printHelp
  exit 0
esac
shift
done

DATESTAMP=$(date +"%F-%H-%M-%S")

RESOURCES=('ipv4' 'ipv6')

for IPVTYPE in ${RESOURCES[@]}
do
  # 
  UNFILTERED_REMOTE_LIST="fullbogons-$IPVTYPE.txt"
  UNFILTERED_LOCAL_LIST="unfiltered-$IPVTYPE-data.txt"

  # backup used bogons for new version
  mkdir -p backup_$IPVTYPE
  touch bogons-$IPVTYPE.txt
  touch $UNFILTERED_LOCAL_LIST

  # 
  wget "https://www.team-cymru.org/Services/Bogons/$UNFILTERED_REMOTE_LIST"
  # 
  REMOTE_SHASUM=$(sha256sum $UNFILTERED_REMOTE_LIST | cut -f 1 -d ' ')
  LOCAL_SHASUM=$(sha256sum $UNFILTERED_LOCAL_LIST | cut -f 1 -d ' ')

  if [[ $LOCAL_SHASUM != $REMOTE_SHASUM || $FORCE == true ]]; then
    mv $UNFILTERED_LOCAL_LIST "backup_$IPVTYPE/"$DATESTAMP"_bogons-$IPVTYPE.txt"
    cat $UNFILTERED_REMOTE_LIST > $UNFILTERED_LOCAL_LIST
    # last date remote update
    head -n1 $UNFILTERED_REMOTE_LIST > "updated-"$IPVTYPE"-bogons-date.txt"
    # bogons list
    sed 1,1d $UNFILTERED_REMOTE_LIST > "bogons-$IPVTYPE.txt"
    
    if [[ $FORCE == true ]]; then
      printf "${NC}[*] ${YELLOW}Forced update bogons $IPVTYPE list${NC} \n"
    else
      printf "${NC}[*] ${YELLOW}Update bogons $IPVTYPE list successful${NC} \n"
    fi
  else
    printf "${NC}[*] ${YELLOW}Bogons $IPVTYPE list already with latest data!${NC} \n"
  fi
  rm $UNFILTERED_REMOTE_LIST
done