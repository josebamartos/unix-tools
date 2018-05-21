#!/usr/bin/env bash
#
# Manages basic Java projects

# Project variables
package="net.otzarri.helloworld"
lib="lib"
out="out"
src=$(echo "src/${package}" | sed -e "s,\.,/,g")

# Library
build_classpath() {
    jars=( $(find lib/ -name '*.jar') )
    if [ "$jars" ]; then classpath=$(IFS=$':'; echo "${jars[*]}"); fi
    if [ "${classpath}" ]; then classpath="-cp ${2}${classpath}"; fi
    echo ${classpath}
}

echo_info() {
    classpath=$(echo $(build_classpath) | sed "s,-cp ,,g")

    echo "  - Classpath: ${classpath}"
    echo "  - Source dir: ${src}"
    echo "  - Package: ${package}"
    echo "  - Main class: Application"
}

# Script functions
initialize() {
    if [ -n "$(ls -A . | grep -v $(echo ${0} | sed 's,\./,,g'))" ]; then echo "Can't initialize, not empty dir."; exit 1; fi

    echo "Creating new Java project\n$(echo_info)"
    mkdir -p {${lib},${out},${src}}
    echo -e "package ${package};\n\n" > ${src}/Application.java
    cat << "EOF" > ${src}/Application.java
package net.otzarri.helloworld;

public class Application {
    public static void main(String[] args) throws Exception {
        System.out.println("Hello World!");
    }
}
EOF
    echo ""
}

build() {
    classpath=$(build_classpath)
    cmd="javac -d ${out} -sourcepath ${src} ${classpath} ${src}/Application.java"

    echo -e "Compiling Java project\n$(echo_info)\n  - Command: ${cmd}"
    ${cmd}
    echo ""
}

start()  {
    classpath=$(echo $(build_classpath) | sed 's,-cp ,-cp out:,g')
    cmd="java ${classpath} ${package}.Application"

    echo -e "Starting Java project\n$(echo_info)\n  - Command: ${cmd}\n"
    ${cmd}
    echo ""
}

stop() {
    jids=( $(jps -l | grep net.otzarri.helloworld.Application | cut -d' ' -f1) )
    
    if [ ${#jids[@]} -gt 0 ]; then
        cmd="kill -9 ${jids[*]}"
        echo -e "Stopping Java project\n$(echo_info)\n  - Command: ${cmd}"
	echo ${cmd}
	${cmd}
    else 
        echo "Application was not running\n$(echo_info)"
	exit 1
    fi

    echo ""
}

status() {
    jids=( $(jps -l | grep net.otzarri.helloworld.Application | cut -d' ' -f1) )

    if [ ${#jids[@]} -gt 0 ]; then
        echo "Application running"
	echo "IDs: ${jids[*]}"
    else
        echo "Application stopped"
    fi

    echo ""
}

case "$1" in
    initialize)
        initialize
        ;;
    build)
        build
        ;;
    start)
        start
        ;;
    stop)
	stop
	;;
    status)
        status
	;;
    *)
        echo "Usage: $0 {initialize|build|start|stop|status}"
esac
