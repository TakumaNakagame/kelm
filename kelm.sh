#!/bin/bash -eu

initialize () {
  ENV_NAME=""
  DIRECTORY_NAME=""
  POD_NAME=""
  MSG_LEVEL=""
  MSG_TXT=""
  FLUG_ERROR=false
}

show_help () {
  echo "kload.sh -e ENV_NAME -d DIRECTORY_NAME -p [RESTART_POD_LABEL]"
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

while getopts he:d:p: OPT
do
  case $OPT in
    "e" )
      ENV_NAME=$OPTARG ;;
    "d" )
      DIRECTORY_NAME=$OPTARG ;;
    "p" )
      POD_NAME=$OPTARG ;;
    "D" )
      FLUG_DEBUG=true ;;
    "h" | * | "" )
      show_help ;;
   esac
done

if [ -z $ENV_NAME ] || [ -z $DIRECTORY_NAME ]; then
  msg "Not Found 'ENV_NAME' or 'DIRECTORY_NAME'" "e";
  exit 1
fi

if [ -n "$ENV_NAME" ] && [ -n "$DIRECTORY_NAME" ] ; then
  helm template ${DIRECTORY_NAME} --values ${DIRECTORY_NAME}/values/${ENV_NAME}-${DIRECTORY_NAME}.yaml > ${ENV_NAME}-${DIRECTORY_NAME}.yaml
  kubectl apply -f ${ENV_NAME}-${DIRECTORY_NAME}.yaml
  rm -rf ${ENV_NAME}-${DIRECTORY_NAME}.yaml
fi

if [ -n "$POD_NAME" ]; then
  kubectl delete pod -l app=${POD_NAME}
fi
