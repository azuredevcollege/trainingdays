FROM mcr.microsoft.com/java/jdk:8-zulu-alpine
COPY . /usr/src/myapp/
WORKDIR /usr/src/myapp
RUN javac app1.java
CMD [ "java" , "app1" ]