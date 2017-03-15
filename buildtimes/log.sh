#!/usr/bin/env bash

# PART_TO_MEASURE
# the first parameter passed is used for the naming of the file,
# it should match the part you want to keep track of. For example:
#     - If you are measuring the entire build time, then pass "build":
#         ${SRCROOT}/buildtimes/log.sh build
#     - If you are measuring just the compile time, then pass "compile"
#         ${SRCROOT}/buildtimes/log.sh compile
#
# Disclaimer: it should match whatever parameter you're passing to log-start.sh
#
PART_TO_MEASURE=$1

MAX_LINES=1000
LOGS_DIR="./buildtimes/logs/$TARGET_NAME"
START_FILE_PATH="$LOGS_DIR/buildtimes-$PART_TO_MEASURE-start.log"
BUILDTIMES_FILE_PATH="$LOGS_DIR/buildtimes-$PART_TO_MEASURE.log"

# Get timestamp times
startimestamp=$(<$START_FILE_PATH)
endtimestamp=$(date +%s)
deltatimestamp=$((endtimestamp-startimestamp))

# Format
time=$(date -r "$startimestamp" +'%Y-%m-%d')
startime=$(date -r "$startimestamp" +%H:%M:%S)
endtime=$(date -r "$endtimestamp" +%H:%M:%S)
deltatime=$(date -r "$deltatimestamp" +%M:%S)

# Print to the .log file
buildtimes="
- [Start] $startime ($startimestamp)
- [End] $endtime ($endtimestamp)
- [Delta] $deltatime ($deltatimestamp)
"
echo "** $time ** $buildtimes
$(cat $BUILDTIMES_FILE_PATH)" > "$BUILDTIMES_FILE_PATH"

# Check it doesn't pass max capacity, otherwise trims it to $MAX_LINES lines
actualnumberoflines=$(wc -l <"$BUILDTIMES_FILE_PATH")
if (( actualnumberoflines > MAX_LINES )); then
  temp=$(head -n $MAX_LINES $BUILDTIMES_FILE_PATH)
  echo "$temp" > "$BUILDTIMES_FILE_PATH"
fi

# Output to Xcode
echo "[buildtimes] Current $PART_TO_MEASURE time (stored in $LOGS_DIR): $buildtimes"

# Delete start file
rm $START_FILE_PATH
