FROM pudding/docker-app:node-18-7z-20230521
RUN apt-get update
RUN apt-get install -y \
     imagemagick
RUN apt-get install -y \
     poppler-utils

# FROM node:18.12.1-buster

# RUN apt-get update

# RUN apt-get install -y \
#     imagemagick

# # COPY package.json /
# # RUN npm install

# CMD ["bash"]

# RUN echo "20231112-0002"