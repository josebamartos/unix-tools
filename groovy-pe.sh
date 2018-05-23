#!/usr/bin/env bash

java_version='10.0.1'
java_url='https://download.java.net/java/GA/jdk10/10.0.1/fb4372174a714e6b8c52526dc134031e/10/openjdk-10.0.1_linux-x64_bin.tar.gz'
java_pkg=$(basename "${java_url}")

groovy_version='2.4.15'
groovy_url="https://apache.org/dist/groovy/${groovy_version}/distribution/apache-groovy-sdk-${groovy_version}.zip"
groovy_pkg=$(basename "${groovy_url}")

# Begin
echo ""
echo "Creating new Groovy portable environment"

# Old environment variable removal
if [ -f ./env ]; then rm ./env; fi


# Environment structure creation
while [[ -z "${env_dir}" ]]
do
  read -p "Directory name for the new Groovy portable: " env_dir
done

if [ ! -d ./${env_dir} ]; then mkdir -p ./${env_dir}/{src,runtime}; fi


# OpenJDK installation
echo -e "Downloading OpenJDK Java ${java_version}"
curl ${java_url} -o ./${env_dir}/${java_pkg}
echo ""

echo -e "Installing OpenJDK Java ${java_version}"
tar zxf ${env_dir}/${java_pkg} -C ./${env_dir}/runtime
rm ./${env_dir}/${java_pkg}

echo 'export JAVA_HOME=$PWD/runtime/jdk-'"${java_version}" >> ./${env_dir}/env
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ./${env_dir}/env
echo ""


# Groovy installation
echo "Downloading groovy ${groovy_version}"
curl ${groovy_url} -o ./${env_dir}/${groovy_pkg}
echo ""

echo "Installing Groovy ${groovy_version}"
unzip -q ${env_dir}/${groovy_pkg} -d ./${env_dir}/runtime
rm ./${env_dir}/${groovy_pkg}

echo 'export GROOVY_HOME=$PWD/runtime/groovy-'"${groovy_version}" >> ./${env_dir}/env
echo 'export PATH=$GROOVY_HOME/bin:$PATH' >> ./${env_dir}/env
echo ""


# Creating sample script
echo "Creating sample Groovy script at src/sysProps.goovy"
cat << 'EOF' > ./${env_dir}/src/sysProps.groovy
#!/usr/bin/env groovy

System.properties.each { k,v->
    println "$k = $v"
}
EOF
