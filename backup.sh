#! /bin/bash

if [[ -z "${MINIO_ACCESS_KEY}" ]]; then
  echo "You need to set the MINIO_ACCESS_KEY environment variable."
  exit 1
fi

if [[ -z "${MINIO_SECRET_KEY}" ]]; then
  echo "You need to set the MINIO_SECRET_KEY environment variable."
  exit 1
fi

if [[ -z "${MINIO_BUCKET}"  ]]; then
  echo "You need to set the MINIO_BUCKET environment variable."
  exit 1
fi

if [[ -z "${MINIO_SERVER}" ]]; then
  echo "You need to set the MINIO_SERVER environment variable."
  exit 1
fi

if [[ -z "${POSTGRES_HOST}"  ]]; then
  if [ -n "${POSTGRES_PORT_5432_TCP_ADDR}" ]; then
    POSTGRES_HOST=$POSTGRES_PORT_5432_TCP_ADDR
    POSTGRES_PORT=$POSTGRES_PORT_5432_TCP_PORT
  else
    echo "You need to set the POSTGRES_HOST environment variable."
    exit 1
  fi
fi

if [[ -z "${POSTGRES_USER}" ]]; then
  echo "You need to set the POSTGRES_USER environment variable."
  exit 1
fi

if [[ -z "${POSTGRES_PASSWORD}" ]]; then
  echo "You need to set the POSTGRES_PASSWORD environment variable or link to a container named POSTGRES."
  exit 1
fi

export MINIO_ACCESS_KEY=$MINIO_ACCESS_KEY
export MINIO_SECRET_KEY=$MINIO_SECRET_KEY
export MINIO_SERVER=$MINIO_SERVER
export MINIO_API_VERSION=$MINIO_API_VERSION

mc alias set minio "$MINIO_SERVER" "$MINIO_ACCESS_KEY" "$MINIO_SECRET_KEY" --api "$MINIO_API_VERSION" > /dev/null

export PGPASSWORD=$POSTGRES_PASSWORD
POSTGRES_HOST_OPTS="-h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER $POSTGRES_EXTRA_OPTS"

echo "Creating dump of databases from ${POSTGRES_HOST}..."

pg_dumpall -U $POSTGRES_USER -h $POSTGRES_HOST -p $POSTGRES_PORT -w | gzip > $HOME/tmp_dump.sql.gz

echo "Uploading dump to $MINIO_BUCKET on $MINIO_SERVER"
mc cp $HOME/tmp_dump.sql.gz minio/$MINIO_BUCKET/dumpall_$(date +"%Y-%m-%dT%H:%M:%SZ").sql.gz --insecure || exit 2

if [ -n "${MINIO_SERVER2}" ]; then
  echo "Uploading dump to $MINIO_BUCKET on $MINIO_SERVER2"
  mc alias set minio2 "$MINIO_SERVER2" "$MINIO_ACCESS_KEY2" "$MINIO_SECRET_KEY2" --api "$MINIO_API_VERSION2" > /dev/null
  mc cp $HOME/tmp_dump.sql.gz minio2/$MINIO_BUCKET2/dumpall_$(date +"%Y-%m-%dT%H:%M:%SZ").sql.gz --insecure || exit 2
fi

rm $HOME/tmp_dump.sql.gz 
sync

echo "SQL backup uploaded successfully" 1>&2
