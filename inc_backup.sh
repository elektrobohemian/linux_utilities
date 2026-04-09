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
#	* added duration output
# 	* added support for file-based exclusion list
#	* added choice between dry run and actual backup
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
SRC="/volume1/nas_contents/archived_data/"
DEST="/volume2/nas_archive"

LATEST="latest"

start_time=$(date "+%H:%M:%S")   # 14:32:07
start_date=$(date "+%d.%m.%Y")  #  07.04.2026
start=$(date +%s) # start timestamp

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
OPTS_original="-azhP --info=progress2 --exclude-from=/home/david_adm/archive_exclusions.txt --mkpath"
OPTS="-azhP --info=progress2 --exclude-from=/home/david_adm/archive_exclusions.txt --mkpath"

if [[ ! -L "${LATEST}" ]] 
then
    echo "[WARN] Previous backup in ${LATEST} was not found. Starting complete backup."
else 
    OPTS="${OPTS} --link-dest $(realpath ${DEST}/${LATEST})/"
fi

echo "RSYNC will be launched with the following parameters:  ${OPTS} ${SRC} ${TARGET}"
#printf '%s' "Press any key to start backup..." && read

read -p "Backup (b or any key) or dry run (d)? [b/d]: " answer
if [[ "$answer" == "d" || "$answer" == "D" ]]; then
	echo "Dry run enabled."
	printf '%s' "Press any key to start dry run..." && read
	rm -rf ${TARGET}
    rsync ${OPTS} --dry-run ${SRC} ${TARGET}
else
	#RESULT_OF_RSYNC=`rsync ${OPTS} ${SRC} ${TARGET}`
	#echo "$RESULT_OF_RSYNC"
	echo "Normal backup."
	printf '%s' "Press any key to start backup..." && read
	rsync ${OPTS} ${SRC} ${TARGET}
fi




PREV_RES=$?

echo " "

if [[ ${PREV_RES} -eq "0" ]]
then
    echo -e "[INFO] Backup completed successfully."
    rm -f ${LATEST}
    ln --symbolic ${TARGET} ${LATEST}
else
    echo -e "[ERROR] An error occured during backup."
exit "${PREV_RES}"
fi

end=$(date +%s)

diff=$((end - start))

hrs=$(( diff / 3600 ))
mins=$(( (diff % 3600) / 60 ))
secs=$(( diff % 60 ))



end_time=$(date "+%H:%M:%S")   # 14:32:07
end_date=$(date "+%d.%m.%Y")  #  07.04.2026

echo " "
# duration output
echo "Started at: $start_date - $start_time "
echo "Ended at: $end_date - $end_time "
printf "Duration: %02d:%02d:%02d\n" $hrs $mins $secs