#!/bin/bash
if [ $DB_TYPE = "postgres" ];
then
    while :; do
        echo Check database availablity;
        pg_isready -h $DB_HOST -U $DB_ADMIN -d postgres -p $DB_PORT;
        if [ "$?" -eq 0 ];
        then
            echo SUCCEED;
            break;
        else
            echo Database is not available: waiting 5 seconds before retry;
            sleep 5;
        fi;
    done;
    if [ ! -z "$DB_USER" ] && [ ! -z "$DB_PASSWORD" ];
    then
        PGPASSWORD=$DB_ADMIN_PASSWORD psql -h $DB_HOST -U $DB_ADMIN -d postgres -p $DB_PORT -tXAc "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER';" | grep -q 1 || PGPASSWORD=$DB_ADMIN_PASSWORD psql -h $DB_HOST -U $DB_ADMIN -d postgres -p $DB_PORT -c "CREATE USER $DB_USER WITH LOGIN NOSUPERUSER NOCREATEDB INHERIT NOREPLICATION CONNECTION LIMIT -1 PASSWORD '$DB_PASSWORD';";
    fi;
    if [ ! -z "$DB_USER" ] && [ ! -z "$DB_NAME" ];
    then
        PGPASSWORD=$DB_ADMIN_PASSWORD psql -h $DB_HOST -U $DB_ADMIN -d postgres -p $DB_PORT -tXAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME';" | grep -q 1 || PGPASSWORD=$DB_ADMIN_PASSWORD psql -h $DB_HOST -U $DB_ADMIN -d postgres -p $DB_PORT -c "CREATE DATABASE $DB_NAME WITH OWNER = '$DB_USER' ENCODING = 'UTF8' CONNECTION LIMIT = -1;";
    fi;
    IFS=',' read -r -a array <<< $DB_EXTENSIONS;
    for i in "${array[@]}"
    do
        PGPASSWORD=$DB_ADMIN_PASSWORD psql -h $DB_HOST -U $DB_ADMIN -d $DB_NAME -p $DB_PORT -c "CREATE EXTENSION IF NOT EXISTS $i;";
    done;
    echo Database initialization completed;
fi;