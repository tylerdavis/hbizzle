# Init
mkdir -p /var/volume/hbizzle_data
chown postgres /var/volume/hbizzle_data
su postgres -c "pg_dropcluster --stop 9.2 main"
su postgres -c "pg_createcluster -d /var/volume/hbizzle_data 9.2 main"

# From Container
su postgres -c "createuser -P -d -r -s tmd"
su postgres -c "createdb -O tmd hbizzle"

# From Host
CONTAINER=$(docker run -d -p 5432 \
  -t tylerdavis/postgresql \
  /bin/su postgres -c '/usr/lib/postgresql/9.2/bin/postgres \
    -D /var/lib/postgresql/9.2/main \
    -c config_file=/etc/postgresql/9.2/main/postgresql.conf')

CONTAINER_IP=$(docker inspect $CONTAINER | grep IPAddress | awk '{ print $2 }' | tr -d ',"')
psql -h $CONTAINER_IP -p 5432 -d docker -U docker -W