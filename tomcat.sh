#!/bin/bash

# Install Java 21
dnf install java-21-amazon-corretto -y

# Tomcat version (use available version)
VERSION="11.0.10"
TOMCAT="apache-tomcat-$VERSION"

# Download from Apache Archive (always available)
URL="https://archive.apache.org/dist/tomcat/tomcat-11/v$VERSION/bin/$TOMCAT.tar.gz"

echo "Downloading Tomcat from $URL"

wget $URL -O $TOMCAT.tar.gz

# Extract
tar -zxvf $TOMCAT.tar.gz

# Go to conf folder
cd $TOMCAT/conf

# Remove existing closing tag
sed -i '/<\/tomcat-users>/d' tomcat-users.xml

# Add roles & user
cat <<EOF >> tomcat-users.xml
<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<user username="tomcat" password="root123456" roles="manager-gui,manager-script"/>
</tomcat-users>
EOF

# Allow Manager GUI access
cd ../webapps/manager/META-INF
sed -i '/Valve/d' context.xml

# Start Tomcat
cd ../../../bin
sh startup.sh
