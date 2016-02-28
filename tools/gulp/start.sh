#!/bin/sh

CURRENT_CWD=$(pwd)
##########################################
# validate gulp file
##########################################
if [ ! -d "${GULP_SOURCE}" ]; then
    echo "${GULP_SOURCE} is not a directory" >&2
    exit 1
fi

GULP_FILE=${GULP_SOURCE}/gulpfile.js
if [ ! -r "${GULP_FILE}" ] || [ ! -f "${GULP_FILE}" ]; then
    echo "${GULP_FILE} is not a file or not accessible" >&2
    exit 1
fi

cd "${GULP_SOURCE}"
gulp run
cd "${CURRENT_CWD}"
