#!/bin/bash -eu

initialize () {
  export ENV_NAME=""
  export DIRECTORY_NAME=""
  export POD_NAME=""
  export MSG_LEVEL=""
  export MSG_TXT=""
  export FLUG_ERROR=false
  export FLUG_DEBUG=false
}

show_help () {
  echo "kload.sh -e ENV_NAME -d DIRECTORY_NAME -p [RESTART_POD_LABEL] [optional -D Debug Mode]"
  exit 1
}

# $1 = msg
# $2 = level [e:error, d:debug] OPTIONAL
msg () {
  if [ $# -eq 0 ]; then
    export MSG_TXT="message is empty : ${BASH_LINENO}"
    export MSG_LEVEL="ERROR"
    export FLUG_ERROR=true
  elif [ $# -ge 2 ]; then
    case $2 in
      "e" ) export MSG_LEVEL="ERROR";;
      "d" ) 
        if [ $FLUG_DEBUG ]; then
          export MSG_LEVEL="DEBUG"
        else
          return 0
        fi ;;
    esac
    export MSG_TXT=$1
  else
    export MSG_TXT=$1
    export MSG_LEVEL="INFO"
  fi
  
  echo "[${MSG_LEVEL}] ${MSG_TXT}"
  
  if [ $FLUG_ERROR ]; then
    exit 1
  fi
}


# 引数がない場合はヘルプを表示
if [ $# -le 1 ]; then
  show_help
fi

initialize

while getopts he:d:p: OPT
do
  case $OPT in
    "e" )
      export ENV_NAME=$OPTARG ;;
    "d" )
      export DIRECTORY_NAME=$OPTARG ;;
    "p" )
      export POD_NAME=$OPTARG ;;
    "D" )
      export FLUG_DEBUG=true ;;
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
  echo "kubectl delete pod --all-namespace -l app=${POD_NAME}"
fi
