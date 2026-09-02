#!/bin/bash
# Invoked as [bash record_aot_caches.sh ...], and that ignores the shebang line,
# so the shell options have to be set here to have any effect. Set on the shebang
# alone they are silently absent, and a workload that failed to compile or a test
# that failed to pass leaves an image the build then reports as a success.
set -Eeu -o pipefail

# Records the two AOT caches a kata's test run replays.
#
# A kata runs in a container thrown away afterwards, so every [test] press pays
# a full JVM startup twice: once for javac and once for the JUnit console. That
# is not a component of the wait, it is most of it. An AOT cache holds the
# classes each of those JVMs loads, in the form the JVM wants them, and reading
# one back costs a fraction of loading them again.
#
# There are two caches because there are two JVMs, and a cache is validated
# against the classpath of the JVM that reads it. javac's is the compiler;
# the console's is the console jar. One cache could not satisfy both.
#
# A learner's own classes never enter either cache, which is what makes them
# keep working as the learner edits: the kata's classes reach JUnit through its
# --class-path argument and its own classloader, so they are never what the
# cache is validated against.

readonly JARS_DIR="${1:?usage: record_aot_caches.sh <jars-dir>}"
readonly WORK_DIR=/tmp/record_aot_caches
readonly CACHE_DIR=/aot
readonly JAVAC_CACHE="${CACHE_DIR}/javac.aot"
readonly CONSOLE_CACHE="${CACHE_DIR}/junit-console.aot"
readonly CONSOLE_JAR=$(ls ${JARS_DIR}/junit-platform-console-standalone-*.jar)

mkdir -p "${WORK_DIR}" "${CACHE_DIR}"
# The .approved.txt comes too: without it the verify below fails, the JVM does
# not exit of its own accord, and no cache is written.
cp /tmp/throwaway_kata/* "${WORK_DIR}"
cd "${WORK_DIR}"

readonly CLASSES=".:$(ls ${JARS_DIR}/*.jar | tr '\n' ':')"

# Recorded from the same command line cyber-dojo.sh runs, so that the classes
# held are the ones a kata actually loads.
javac -J-XX:AOTCacheOutput="${JAVAC_CACHE}" \
      -cp "${CLASSES}" \
      *.java

java -XX:AOTCacheOutput="${CONSOLE_CACHE}" \
     -jar "${CONSOLE_JAR}" \
     execute \
     --disable-banner \
     --disable-ansi-colors \
     --details=tree \
     --details-theme=ascii \
     --class-path "${CLASSES}" \
     --scan-class-path

# The sandbox user reads both at run time and owns neither.
chmod 0644 "${JAVAC_CACHE}" "${CONSOLE_CACHE}"

cd /
rm -rf "${WORK_DIR}"

ls --format=long "${JAVAC_CACHE}" "${CONSOLE_CACHE}"
