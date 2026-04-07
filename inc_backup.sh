#!/bin/bash

# script based on https://raw.githubusercontent.com/Baeldung/posts-resources/refs/heads/main/linux-articles/incremental_backups_via_rsync/backup.sh
# described by https://www.baeldung.com/linux/rsync-incremental-backups
#
# modified by David Zellhöfer (2026)
#
# additions:
#	* backups are discriminated by date, hour and minute in order to allow multiple backups per day
#	* added a pause after diagnostic output
#	* removed rsync's --delete flag in order to create a real archive
#	* improved output
#	* moved output for find from &>/dev/zero to &>/dev/null
#	* added progress human-readable output for rsync run
# 
# original license:
#
# MIT License
#
#Copyright (c) 2023 Baeldung
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
#

TODAY=`date +%Y-%m-%d_%H-%M`
#SRC="$1"
#DEST="$2"
SRC="/volume1/nas_contents/"
DEST="/volume2/nas_archive"

LATEST="latest"

if [[ -z "$SRC" ]]
then
    echo "[ERROR] The source directory parameter is absent."
    exit 1
fi

if [[ -z "$DEST" ]]
then
    echo "[ERROR] The destination parameter is absent."
    exit 1
fi

TARGET="${DEST}/${TODAY}"
echo -e "[INFO] Initiating backup from ${SRC} to ${DEST} for ${TODAY}."

if [[ ! -d "${TARGET}" ]]
then
    mkdir "${TARGET}"
    echo -e "[DEBUG] Backup target : ${TARGET}"
elif [[ ! -z `find "${TARGET}" -type d -empty &>/dev/null` ]]
then
    echo "[ERROR] Backup target exists and contains some files. Aborting backup."
    exit 1
else
    echo "[DEBUG] Backup target already exists."
fi

cd "$DEST"

#OPTS="-azvP --mkpath --delete"
OPTS="-azhP --info=progress2 --mkpath"

if [[ ! -L "${LATEST}" ]] 
then
    echo "[WARN] Previous backup in ${LATEST} was not found. Starting complete backup."
else 
    OPTS="${OPTS} --link-dest ${DEST}/${LATEST}"
fi

printf '%s' "Press any key to start backup..." && read


#RESULT_OF_RSYNC=`rsync ${OPTS} ${SRC} ${TARGET}`
#echo "$RESULT_OF_RSYNC"
rsync ${OPTS} ${SRC} ${TARGET}

PREV_RES=$?

if [[ ${PREV_RES} -eq "0" ]]
then
    echo -e "[DEBUG] Backup completed successfully."
    `rm -f ${LATEST}`
    `ln --symbolic ${TARGET} ${LATEST}`
else
    echo -e "[ERROR] An error occured during backup."
exit "${PREV_RES}"
fi
