#!/bin/bash -eu

initialize () {
  ENV_NAME=""
  DIRECTORY_NAME=""
  POD_NAME=""
  MSG_LEVEL=""
  MSG_TXT=""
  DRY_RUN=""
  FLUG_ALL_DRY_RUN=false
  FLUG_ERROR=false
}

show_help () {
  echo "kload.sh -e ENV_NAME -d DIRECTORY_NAME [-p RESTART_POD_LABEL] [-c --dry-run]"
  exit 1
}

# $1 = msg
# $2 = level [e:error, w:warning] OPTIONAL
msg () {
  if [ $# -eq 0 ]; then
    MSG_TXT="message is empty : ${BASH_LINENO}"
    MSG_LEVEL="ERROR"
    FLUG_ERROR=true
  elif [ $# -ge 2 ]; then
    case $2 in
      "e" ) MSG_LEVEL="ERROR";;
      "w" ) MSG_LEVEL="WARNING";;
    esac
    MSG_TXT=$1
  else
    MSG_TXT=$1
    MSG_LEVEL="INFO"
  fi
  
  echo "[${MSG_LEVEL}] ${MSG_TXT}"
  
  if [ $FLUG_ERROR ]; then
    exit 1
  fi
}

initialize

# 引数がない場合はヘルプを表示
if [ $# -le 1 ]; then
  show_help
fi

while getopts cChe:d:p: OPT
do
  case $OPT in
    "e" )
      ENV_NAME=$OPTARG ;;
    "d" )
      DIRECTORY_NAME=$OPTARG ;;
    "p" )
      POD_NAME=$OPTARG ;;
    "c" )
      DRY_RUN="--dry-run" ;;
    "C" )
      DRY_RUN="--dry-run"
      FLUG_ALL_DRY_RUN=true ;;
    "h" | * | "" )
      show_help ;;
   esac
done

if [ "$FLUG_ALL_DRY_RUN" = false ] && ( [ -z $ENV_NAME ] || [ -z $DIRECTORY_NAME ] ); then
  msg "Not Found 'ENV_NAME' or 'DIRECTORY_NAME'" "e";
  exit 1
fi

if [ -n "$DRY_RUN" ] && [ -n "$POD_NAME" ]; then
  msg "-p option can not be used when -c option is enabled" "e"
  exit 1
fi

# $1 : environments
# $2 : directory
apply_template () {
    helm template ${2} --values ${2}/values/${1}-${2}.yaml > ${1}-${2}.yaml
    kubectl apply -f ${1}-${2}.yaml ${DRY_RUN}
    rm -rf ${1}-${2}.yaml
}

if [ "$FLUG_ALL_DRY_RUN" = true ]; then
  for DIR in `find . -maxdepth 1 -mindepth 1 -type d| gawk -F/ '{print $NF}'`; do
    apply_template $ENV_NAME $DIR
  done
  exit 1
  
elif [ -n "$ENV_NAME" ] && [ -n "$DIRECTORY_NAME" ] ; then
  apply_template $ENV_NAME $DIRECTORY_NAME
fi


if [ -n "$POD_NAME" ]; then
  kubectl delete pod -l app=${POD_NAME}
fi
