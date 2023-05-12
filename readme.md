

# Backup Postgresql to Minio S3 

# postgres Supported Versions
* 15
* 14
* 13

### features
* use `pg_dumpall` dump all data
* support 2nd minio server

#### `cp .env.example .env`
```
# setup SCHEDULE if you want to schedule
SCHEDULE=@daily

MINIO_ACCESS_KEY=12345678
MINIO_SECRET_KEY=12345678
MINIO_BUCKET=minio
MINIO_SERVER=http://127.0.0.1:9000
MINIO_API_VERSION=S3v4

POSTGRES_USER=postgres
POSTGRES_PASSWORD=example
POSTGRES_HOST=127.0.0.1
POSTGRES_PORT=5432

# if you hav 2nd minio server please add following code
MINIO_ACCESS_KEY2=12345678
MINIO_SECRET_KEY2=12345678
MINIO_BUCKET2=minio
MINIO_SERVER2=http://127.0.0.1:9000
MINIO_API_VERSION2=S3v4
```


### how to use
```
git clone https://github.com/chnbohwr/backup-postgresql-to-minio
cd backup-postgresql-to-minio
docker-compose up -d
```


## Required Envionment Variables

- `MINIO_ACCESS_KEY` - Your Minio access key.
- `MINIO_SECRET_KEY` - Your Minio access key.
- `MINIO_BUCKET` - Your Minio bucket.
- `MINIO_HOST` - Your Minio Host
- `POSTGRES_PASSWORD` - Password for the PostgreSQL user, if you are using a database on the same machine this isn't usually needed.
- `POSTGRES_HOST` - Hostname of the PostgreSQL database to backup, alternatively this container can be linked to the container with the name `postgres`.
- `POSTGRES_USER` - PostgreSQL user, with priviledges to dump the database.

### Optional Enviroment Variables

- `POSTGRES_PORT` - Port of the PostgreSQL database, uses the default 5432.
- `MINIO_API_VERSION` - you can change with S3v4 or S3v2.
- `SCHEDULE` - Cron schedule to run periodic backups.


# some script from 
-  fork from: https://github.com/smilelikeshit/backup-postgresql-to-minio
-  URL : https://github.com/wonderu/docker-backup-postgres-s3
-  URL : https://github.com/schickling/dockerfiles/tree/master/postgres-backup-s3 
-  More information about the scheduling can be found [here](http://godoc.org/github.com/robfig/cron#hdr-Predefined_schedules).
