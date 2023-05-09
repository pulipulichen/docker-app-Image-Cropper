#!/bin/bash

# cd /tmp/docker-app-Image-Trim/
# /tmp/docker-app-Image-Trim/s.sh

PROJECT_NAME=docker-app-Image-Trim

# -------------------
# 檢查有沒有參數

var="$1"
useParams="true"
WORK_DIR=`pwd`
if [ ! -f "$var" ]; then
  # echo "$1 does not exist."
  # exit
  var=$(kdialog --getopenfilename --multiple ~/ 'Images')
  var=`echo "${var}" | xargs`
  useParams="false"
fi

# ------------------
# 確認環境

if ! command -v git &> /dev/null
then
  echo "git could not be found"
  xdg-open https://git-scm.com/downloads &
  exit
fi

if ! command -v node &> /dev/null
then
  echo "node could not be found"
  xdg-open https://nodejs.org/en/download/ &
  exit
fi

if ! command -v docker-compose &> /dev/null
then
  echo "docker-compose could not be found"
  xdg-open https://docs.docker.com/compose/install/ &
  exit
fi

# ---------------
# 安裝或更新專案

if [ -d "/tmp/${PROJECT_NAME}" ];
then
  cd "/tmp/${PROJECT_NAME}"
  git reset --hard
  git pull --force
else
	# echo "$DIR directory does not exist."
  cd /tmp
  git clone "https://github.com/pulipulichen/${PROJECT_NAME}.git"
  cd "/tmp/${PROJECT_NAME}"
fi

# -----------------
# 確認看看要不要做docker-compose build

mkdir -p "/tmp/${PROJECT_NAME}.cache"

cmp --silent "/tmp/${PROJECT_NAME}/Dockerfile" "/tmp/${PROJECT_NAME}.cache/Dockerfile" && cmp --silent "/tmp/${PROJECT_NAME}/package.json" "/tmp/${PROJECT_NAME}.cache/package.json" || docker-compose build

cp "/tmp/${PROJECT_NAME}/Dockerfile" "/tmp/${PROJECT_NAME}.cache/"
cp "/tmp/${PROJECT_NAME}/package.json" "/tmp/${PROJECT_NAME}.cache/"

# -----------------
# 執行指令

if [ "${useParams}" == "true" ]; then
  # echo "use parameters"
  for var in "$@"
  do
    cd "${WORK_DIR}"
    var=`realpath "${var}"`
    # echo "${var}"
    cd "/tmp/${PROJECT_NAME}"

    # echo "okkkk1"
    # pwd
    # docker-compose up
    # echo "okkkk2"
    node "/tmp/${PROJECT_NAME}/index.js" "${var}"
  done
else
  if [ ! -f "${var}" ]; then
    echo "$var does not exist."
    #exit
  else
    echo 'node "/tmp/${PROJECT_NAME}/index.js" "${var}"'
    node "/tmp/${PROJECT_NAME}/index.js" "${var}"
  fi
fi



echo "Press any key to continue"
while [ true ] ; do
read -t 3 -n 1
if [ $? = 0 ] ; then
exit ;
else
echo "waiting for the keypress"
fi
done

