#!/bin/bash
#
# Startup script used by Jenkins launchd job.
# Mac OS X launchd process calls this script to customize
# the java process command line used to run Jenkins.
# 
# Customizable parameters are found in
# /Library/Preferences/@@OSX_IDPREFIX@@.plist
#
# You can manipulate it using the "defaults" utility.
# See "man defaults" for details.

defaults="defaults read /Library/Preferences/@@OSX_IDPREFIX@@"

war=`$defaults war` || war="/Applications/@@CAMELARTIFACTNAME@@/@@ARTIFACTNAME@@.war"

javaArgs="-Dfile.encoding=UTF-8"

minPermGen=`$defaults minPermGen` && javaArgs="$javaArgs -XX:PermSize=${minPermGen}"
permGen=`$defaults permGen` && javaArgs="$javaArgs -XX:MaxPermSize=${permGen}"

minHeapSize=`$defaults minHeapSize` && javaArgs="$javaArgs -Xms${minHeapSize}"
heapSize=`$defaults heapSize` && javaArgs="$javaArgs -Xmx${heapSize}"

tmpdir=`$defaults tmpdir` && javaArgs="$javaArgs -Djava.io.tmpdir=${tmpdir}"

home=`$defaults JENKINS_HOME` && export JENKINS_HOME="$home"

add_to_args() {
    val=`$defaults $1` && args="$args --${1}=${val}"
}

args=""
add_to_args prefix
add_to_args httpPort
add_to_args httpListenAddress
add_to_args httpsPort
add_to_args httpsListenAddress
add_to_args ajp13Port
add_to_args ajp13ListenAddress

echo "JENKINS_HOME=$JENKINS_HOME"
echo "@@PRODUCTNAME@@ command line for execution:"
echo /usr/bin/java $javaArgs -jar "$war" $args
exec /usr/bin/java $javaArgs -jar "$war" $args