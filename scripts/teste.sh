#!/bin/sh




roda(){
psql -U postgres -d pc_test1 -h localhost --o /dev/null <<EOF
\timing
select * from points;
EOF
}


A=$(roda)
echo $A |  cut -d' ' -f5
