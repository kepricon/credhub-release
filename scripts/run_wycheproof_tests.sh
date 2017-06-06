#!/bin/bash

set -eux

/credhub-release/scripts/fetch_latest_java.rb
JDK_LOCATION=`cat /credhub-release/.jdk-location`

export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-i386

mkdir -p ${JAVA_HOME}
curl -L ${JDK_LOCATION} -o ${JAVA_HOME}/jdk.tar.gz
pushd ${JAVA_HOME}
  tar zxvf jdk.tar.gz
  wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip
  unzip jce_policy-8.zip
  mv UnlimitedJCEPolicyJDK8/*.jar jre/lib/security/
popd
export PATH=${JAVA_HOME}/bin:$PATH

java -version

curl -L https://github.com/bazelbuild/bazel/releases/download/0.5.0/bazel-0.5.0-without-jdk-installer-linux-x86_64.sh -o bazel-0.5.0-without-jdk-installer-linux-x86_64.sh
chmod +x bazel-0.5.0-without-jdk-installer-linux-x86_64.sh
./bazel-0.5.0-without-jdk-installer-linux-x86_64.sh --user
export PATH="$PATH:/root/bin"

git clone https://github.com/google/wycheproof.git
cd wycheproof

bazel test OpenJDKAllTests
