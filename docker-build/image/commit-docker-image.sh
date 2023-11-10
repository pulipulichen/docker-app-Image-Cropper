#!/bin/bash

IMAGE_NAME=pudding/docker-app:docker-app-Image-Trim-20231111-0113

docker tag docker-app-image-trim-app ${IMAGE_NAME}
docker push "${IMAGE_NAME}"