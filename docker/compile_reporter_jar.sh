#!/bin/bash
# Invoked as [bash compile_reporter_jar.sh ...], and that ignores the shebang
# line, so the shell options have to be set here to have any effect. Set on the
# shebang alone they are silently absent, and a reporter that failed to compile
# leaves an image the build then reports as a success, in which every kata names
# a class that is not there.
set -Eeu -o pipefail

# Compiles this repo's reporter into a jar beside the ones Maven resolved.
#
# It lands in the jars directory because that is what a kata's classpath is
# built from, so naming the reporter in a kata needs nothing added to
# cyber-dojo.sh. The sources are in this repo rather than fetched, being ours;
# what they do and why is in the .java files.

readonly JARS_DIR="${1:?usage: compile_reporter_jar.sh <jars-dir>}"
readonly WORK_DIR=/tmp/compile_reporter_jar
readonly REPORTER_JAR="${JARS_DIR}/cyber-dojo-reporter.jar"

mkdir -p "${WORK_DIR}/classes"
cd "${WORK_DIR}"

# Compiled against the jars already in place, which is where ApprovalTests'
# classes come from.
javac -cp "$(ls ${JARS_DIR}/*.jar | tr '\n' ':')" \
      -Xlint:all \
      -d "${WORK_DIR}/classes" \
      $(find /tmp/reporter -name '*.java')

jar --create --file "${REPORTER_JAR}" -C "${WORK_DIR}/classes" .

# The sandbox user reads this at run time and owns nothing here.
chmod 0644 "${REPORTER_JAR}"

cd /
rm -rf "${WORK_DIR}"

ls --format=long "${REPORTER_JAR}"
