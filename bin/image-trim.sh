#!/bin/bash

# cd /tmp/docker-app-Image-Trim/
# /tmp/docker-app-Image-Trim/s.sh

PROJECT_NAME=docker-app-Image-Trim

# ----

if [ -z "$DOCKER_HOST" ]; then
    
    if [[ "$(uname)" == "Darwin" ]]; then
      echo "Running on macOS"
    else
      echo "DOCKER_HOST is not set, setting it to 'unix:///run/user/1000/docker.sock'"
      export DOCKER_HOST="unix:///run/user/1000/docker.sock"
    fi
else
    echo "DOCKER_HOST is set to '$DOCKER_HOST'"
fi


# -------------------
# 檢查有沒有參數

var="$1"
useParams="true"
WORK_DIR=`pwd`
if [ ! -f "$var" ]; then
  # echo "$1 does not exist."
  # exit
  if command -v kdialog &> /dev/null; then
    var=$(kdialog --getopenfilename --multiple ~/ 'Files')
    
  elif command -v osascript &> /dev/null; then
    selected_file="$(osascript -l JavaScript -e 'a=Application.currentApplication();a.includeStandardAdditions=true;a.chooseFile({withPrompt:"Please select a file to process:"}).toString()')"

    # Storing the selected file path in the "var" variable
    var="$selected_file"

  fi
  var=`echo "${var}" | xargs`
  useParams="false"
fi

# ------------------
# 確認環境

if ! command -v git &> /dev/null
then
  echo "git could not be found"

  if command -v xdg-open &> /dev/null; then
    xdg-open https://git-scm.com/downloads &
  elif command -v open &> /dev/null; then
    open https://git-scm.com/downloads &
  fi

  exit
fi

# if ! command -v node &> /dev/null
# then
#   echo "node could not be found"

#   if command -v xdg-open &> /dev/null; then
#     xdg-open https://nodejs.org/en/download/ &
#   elif command -v open &> /dev/null; then
#     open https://nodejs.org/en/download/ &
#   fi

#   exit
# fi

if ! command -v docker-compose &> /dev/null
then
  echo "docker-compose could not be found"

  if command -v xdg-open &> /dev/null; then
    xdg-open https://docs.docker.com/compose/install/ &
  elif command -v open &> /dev/null; then
    open https://docs.docker.com/compose/install/ &
  fi

  exit
fi

# ---------------
# 安裝或更新專案

if [ -d "/tmp/${PROJECT_NAME}" ];
then
  cd "/tmp/${PROJECT_NAME}"

  pwd

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

# =================================================================
# 宣告函數

setDockerComposeYML() {
  file="$1"
  echo "${file}"

  filename=$(basename "$file")
  dirname=$(dirname "$file")


  template=$(<"/tmp/${PROJECT_NAME}/docker-compose-template.yml")
  echo "$template"

  template="${template/\[SOURCE\]/$dirname}"
  template="${template/\[INPUT\]/$filename}"

  echo "$template" > "/tmp/${PROJECT_NAME}/docker-compose.yml"
}

runDockerCompose() {
  if [[ "$(uname)" == "Darwin" ]]; then
    chown -R $(whoami) ~/.docker
  fi

  if ! docker-compose up --build; then
    echo "Error occurred. Trying with sudo..."
    sudo docker-compose up --build
  fi
}

# -----------------
# 執行指令



if [ "${useParams}" == "true" ]; then
  # echo "use parameters"
  for var in "$@"
  do
    cd "${WORK_DIR}"
    

    if command -v realpath &> /dev/null; then
      var=`realpath "${var}"`
    else
      var=$(cd "$(dirname "${var}")"; pwd)/"$(basename "${var}")"
    fi
    # echo "${var}"
    cd "/tmp/${PROJECT_NAME}"

    # echo "okkkk1"
    # pwd
    # docker-compose up
    # echo "okkkk2"
    
    
    #node "/tmp/${PROJECT_NAME}/index.js" "${var}"
    # SetDockerComposeYML(file)
    setDockerComposeYML "${var}"

    runDockerCompose

  done
else
  if [ ! -f "${var}" ]; then
    echo "$var does not exist."
    #exit
  else
    echo 'node "/tmp/${PROJECT_NAME}/index.js" "${var}"'
    # node "/tmp/${PROJECT_NAME}/index.js" "${var}"

    setDockerComposeYML "${var}"

    runDockerCompose
  fi
fi
