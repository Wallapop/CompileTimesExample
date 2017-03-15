#!/usr/bin/env bash

# PART_TO_MEASURE
# the first parameter passed is used for the naming of the file,
# it should match the part you want to keep track of. For example:
#     - If you are measuring the entire build time, then pass "build":
#         ${SRCROOT}/buildtimes/log-start.sh build
#     - If you are measuring just the compile time, then pass "compile"
#         ${SRCROOT}/buildtimes/log-start.sh compile
#
# Disclaimer: it should match whatever parameter you're passing to log.sh
#
PART_TO_MEASURE=$1

LOGS_DIR="./buildtimes/logs/$TARGET_NAME"
START_FILE_PATH="$LOGS_DIR/buildtimes-$PART_TO_MEASURE-start.log"

mkdir -p $LOGS_DIR
echo "$(date +%s)" > "$START_FILE_PATH"
