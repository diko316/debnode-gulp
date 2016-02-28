#!/bin/sh

CURRENT_CWD=$(pwd)

echo "Staring Gulp..."

##########################################
# validate gulp directory
##########################################
if [ ! -d "${GULP_SOURCE}" ]; then
    echo "${GULP_SOURCE} is not a directory" >&2
    exit 1
fi

##########################################
# validate package.json
##########################################
PACKAGE_FILE="${GULP_SOURCE}/package.json"
if [ ! -r "${PACKAGE_FILE}" ] || [ ! -f "${PACKAGE_FILE}" ]; then
    echo "${PACKAGE_FILE} is not a file or not accessible" >&2
    exit 1
fi

cd "${GULP_SOURCE}"
npm run install
cd "${CURRENT_CWD}"
