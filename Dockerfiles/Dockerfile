FROM ubuntu:18.04
SHELL ["/bin/bash", "-c"] 
RUN apt-get update -y && apt-get install software-properties-common -y  && apt-get upgrade -y && apt-get install curl -y
RUN mkdir -p /var/log/herokupath
RUN export PATH="/usr/local/bin:$PATH"
RUN source ~/.bashrc
RUN curl https://cli-assets.heroku.com/install.sh | sh
COPY .netrc ~/.netrc
WORKDIR /var/log/herokupath
CMD HEROKU_API_KEY='<update api key>' heroku logs -a flack-app-ac --tail | tee heroku.log
