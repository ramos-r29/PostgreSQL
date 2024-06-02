#!/bin/bash

pg_conn="psql -h localhost -p 5432 -U postgres"

pg_query_dbs="SELECT datname FROM pg_database WHERE datname NOT IN ('template0', 'template1' , 'postgres')"

db_list=$(${pg_conn} -c "${pg_query_dbs}" | tail -n +3 | head -n -2)

for db in ${db_list}
do
        pg_query_tp="SELECT tb.schemaname||'.'||tb.tablename FROM pg_tables AS tb LEFT JOIN pgstattuple(tb.schemaname||'.'||tb.tablename) AS tp ON TRUE WHERE tp.dead_tuple_len > 0"
        ${pg_conn} ${db} -c "CREATE EXTENSION IF NOT EXISTS pgstattuple"
        pg_tables_list=$(${pg_conn} ${db} -c "${pg_query_tp}" | tail -n +3 | head -n -2)
        for tb in ${pg_tables_list}
        do
                ${pg_conn} ${db} -c "VACUUM FULL ${tb}"
                ${pg_conn} ${db} -c "REINDEX TABLE ${tb}"
                ${pg_conn} ${db} -c "ANALYZE ${tb}"
        done
done
