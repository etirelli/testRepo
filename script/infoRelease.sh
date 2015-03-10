#!/bin/bash

# Create a release branch for all git repositories


# Absolute path to this script, e.g. /home/user/xxx/infoRlease.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/xxx
scriptDir=$(dirname "$SCRIPT")
echo $scriptDir

cd $scriptDir 

if [ $# != 2 ] ; then
    echo
    echo "Usage:"
    echo "  $0 communityTag productTag"
    echo "For example:"
    echo "  $0 6.2.0.Final sync-6.2.x-2015.02.27"
    echo
    exit 1
fi

echo "The communityTag is: "$1
echo "The prodcutTag is: "$2
echo -n "Is this ok? (Hit control-c if is not): "
read ok

communityTag=$1
productTag=$2
prefix=`date +%F-%H:%M`
fileToWrite=$productTag.txt
repoDir=testRepo
 
#extracts the mail of project leads
FILE_TO_READ=$scriptDir/mails.properties
   echo  "These are the mails of responsible people" >> $fileToWrite
   # Read file in lines
   while read line; do
     if [ -n "$line" ]; then
       echo "$line" >> $fileToWrite
     fi
   done < $FILE_TO_READ
   echo "" >> $fileToWrite
   echo "" >> $fileToWrite
# extracts the repositories URL
   echo "These are the repositories" >> $fileToWrite
FILE_TO_READ=$scriptDir/repositories.properties
   while read line; do
     if [ -n "$line" ]; then
       echo "$line"/tree/$TAG >> $fileToWrite
     fi
   done < $FILE_TO_READ
   echo "" >> $fileToWrite
   echo "" >> $fileToWrite
#extracts the TAG name
   echo "The name of community tag is:" $communityTag >> $fileToWrite
   echo "The name of product tag is:" $productTag >> $fileToWrite
   echo "" >> $fileToWrite
   echo "" >> $fileToWrite
#gives the Maven and Java version
   echo "The JAVA version is:" >> $fileToWrite
   java -version 2>>$fileToWrite
   echo ""  >> $fileToWrite
   echo "The Maven version is:" >> $fileToWrite
   mvn --version >> $fileToWrite
   echo "" >> $fileToWrite
   echo "" >> $fileToWrite
#infos
   echo "NOTE* before each release the .m2/repository/org/drools ,kie, jbpm, guvnor, optaplanner, dashbuilder  and uberfire repositories are removed" >> $fileToWrite
   echo "" >> $fileToWrite
   echo "" >> $fileToWrite

#copies the file to the right git repository
   TARGET_REPO=$scriptDir/../../../$repoDir
   cp $fileToWrite $TARGET_REPO
   cd $TARGET_REPO
   pwd
   ls -al
   git add .
   git commit -m "$productTag"
   git push origin master
   cd $scriptDir
   rm $fileToWrite
 