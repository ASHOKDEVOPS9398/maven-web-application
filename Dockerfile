FROM nginx:latest
RUN mkdir mywebapp
COPY . .
WORKDIR /mywebapp
ENV team=dev
MAINTAINER Ashok <sappoguashok462@gmail.com>
LABEL env=dev
EXPOSE 8090
CMD ["nginx","-g","daemon-off"]
