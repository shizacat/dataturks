# Description

This is clone main [repository](https://github.com/DataTurks/DataTurks).

Features:
- Added support for work with PostgreSQL

Problems:
- Didn't work npm - the project don't build (all is old)
- Didn't find some packages

This did:
- Changed original jar file
- The db was to place on outside container

You should to crate database in manual:
- hope/docker/db_postgresql_init.db
- hope/docker/db_mysql_init.db

[DataTurks On-prem: A fully self-hosted data annotation solution.
](https://medium.com/@dataturks/dataturks-on-prem-a-fully-self-hosted-data-annotation-solution-86b455bf0634)

## Build

```bash
# Download main image and store as 'dataturks/dataturks:3.3.0'
curl -o dataturks_docker.tar.gz \
    https://s3-us-west-2.amazonaws.com/images.onprem.com.dataturks/dataturks_docker_3_3_0.tar.gz
tar -xzf dataturks_docker.tar.gz
sudo docker load --input ./dataturks_docker.tar
sudo docker run -d -p 80:80 dataturks/dataturks:3.3.0

# Build
docker build -t dataturks:3.4.0 -f hope/docker/Dockerfile.simple .
```

## Environment

- DATATURKS_CONF - The path to config file
