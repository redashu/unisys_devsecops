FROM oraclelinux:8.4 AS WarfileBuilder 
LABEL name=ashutoshh
RUN dnf install java-1.8.0-openjdk.x86_64  java-1.8.0-openjdk-devel.x86_64  maven git -y 
RUN mkdir /ashu-java
WORKDIR /ashu-java
 
COPY . . 
# now running maven to create .war file 
RUN mvn clean package

FROM tomcat 
LABEL email="ashutoshh@linux.com"
COPY --from=WarfileBuilder /ashu-java/target/WebApp.war /usr/local/tomcat/webapps/
