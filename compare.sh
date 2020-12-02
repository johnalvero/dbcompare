#!/bin/bash

SKIP_DBS=(information_schema mysql)

USER=''
PASS=''
HOST=''
MYSQL_CMD="mysql -u $USER -p$PASS -h$HOST -Bse"

all_dbs="$($MYSQL_CMD 'show databases;')"

for db in $all_dbs
do

        if printf '%s\n' "${SKIP_DBS[@]}" | grep -q -P "^$db$"; then
                echo "skipping $db"
                continue
        fi

        list_tables=$($MYSQL_CMD "use $db; show tables;")
        icount=$(echo $list_tables | wc -w)

        # Output table count
        echo "$db,$icount,tblcount"

        for tb in $list_tables
        do
                jcount=$($MYSQL_CMD "select count(*) from $db.$tb;")

                # Output record count
                echo "$tb,$jcount,reccount"
        done
done
