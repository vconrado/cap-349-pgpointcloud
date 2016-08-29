#!/bin/bash


if [ $# -ne 3 ]; then
	echo "usage $0 database_name table_name N"
	exit
fi
DBNAME=$1
TBNAME=$2
N=$3

exec_sql(){
psql -U postgres -d $DBNAME -h localhost --o /dev/null <<EOF
\timing
select PC_Summary(PC_Union(pa)) from "$TBNAME" where id < 20000
EOF
}

for i in $(seq 1 $N); do
	RET=$(exec_sql)
	echo $RET |  cut -d' ' -f5
done
