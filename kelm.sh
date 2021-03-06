#!/bin/bash

initialize () {
  ENV_NAME=""
  DIRECTORY_NAME=""
  POD_NAME=""
  MSG_LEVEL=""
  MSG_TXT=""
  DRY_RUN=""
  ACTION="apply"
  FLUG_ALL=false
  FLUG_ERROR=false
  FLUG_FILE_DELETE=true
  RELEASE_NAME=""
}

show_help () {
  cat << EOS

    BASICS
      kelm -e ENV_NAME -d DIRECTORY_NAME
    
    OPTION
      -n  RELEASE_NAME      : apply helm chart release name.
      -e  ENV_NAME          : select values files. ex) dev-prometheus.yaml > 'dev'
      -d  DIRECTORY_NAME    : apply directory path.
      -p  RESTART_POD_LABEL : restart pod. require pod 'app' label value.
      -D                    : delete manifests.
      -c                    : enable kubectl '--dry-run' option.
      -A                    : apply current directores all (not require -d directory).
      -f                    : Do not delete the output manifest file.

    EXAMPLE
      # apply dev prometheus manifests.
        > kelm -e dev -d prometheus

      # apply dev prometheus manifests, and restart app=prometheus pod.
        > kelm -e dev -d prometheus -p prometheus

      # dry run stg prometheus manifests
        > kelm -c -e stg -d prometheus

      # apply dev current directory manifests.
        > kelm -Ae dev

      # dry run prd current directory manifests.
        > kelm -Ace prd


EOS

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

while getopts n:De:d:p:fAch OPT
do
  case $OPT in
    "n" )
      RELEASE_NAME=$OPTARG ;;
    "e" )
      ENV_NAME=$OPTARG ;;
    "d" )
      DIRECTORY_NAME=$OPTARG ;;
    "D" )
      ACTION="delete" ;;
    "p" )
      POD_NAME=$OPTARG ;;
    "f" )
      FLUG_FILE_DELETE=false ;;
    "A" )
      FLUG_ALL=true ;;
    "c" )
      DRY_RUN="--dry-run" ;;
    "h" | * | "" )
      show_help ;;
   esac
done

if [ -n "$DRY_RUN" ] && [ -n "$POD_NAME" ]; then
  msg "-p option can not be used when -c option is enabled" "e"
  exit 1
fi


# $1 : environments
# $2 : directory
apply_template () {

    if [ $# -eq 2 ]; then
      ENV=${1}
      DIRECTORY=${2}
    elif [ $# -eq 1 ]; then
      DIRECTORY=${1}
    else
      msg "The argument is incorrect." "e"
      exit 1
    fi

    if [ -z "$RELEASE_NAME" ]; then
      RELEASE_NAME=${DIRECTORY}
    fi

    if [ -z "$ENV_NAME" ]; then
      ENV_FILE="${DIRECTORY}/values.yaml"
    else
      ENV_FILE="${DIRECTORY}/values/${ENV}-${DIRECTORY}.yaml"
    fi

    helm template ${DIRECTORY} --values ${ENV_FILE} --name ${RELEASE_NAME} > ${ENV}-${DIRECTORY}.yaml
    echo -e "\033[0;32m### --- ${ENV}-${DIRECTORY} ---\033[0;39m"
    kubectl ${ACTION} -f ${ENV}-${DIRECTORY}.yaml ${DRY_RUN}
    echo ""

    if [ "$FLUG_FILE_DELETE" = true ]; then
      rm -rf ${ENV}-${DIRECTORY}.yaml
    fi
}

echo -e "\033[0;32m##  --- Template Generate and Applying... ---\033[0;39m\n"

if [ "$FLUG_ALL" = true ]; then
  for DIR in `find . -maxdepth 1 -mindepth 1 -type d| gawk -F/ '{print $NF}'`; do
    apply_template $ENV_NAME $DIR
    RELEASE_NAME=""
    DIRECTORY=""
  done
  exit 1

else
  apply_template $ENV_NAME $DIRECTORY_NAME
fi

if [ -n "$POD_NAME" ]; then
  echo -e "\033[0;32m##  --- Pod Restarting... ---\033[0;39m\n"
  kubectl delete pod -l app=${POD_NAME}
fi

cowsay "Job Finish!"
