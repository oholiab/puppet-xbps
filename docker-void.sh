mkdir docker-void
xbps-install -y -r $PWD/docker-void --repository=http://repo.voidlinux.eu/current -S base-voidstrap
tar -C docker-void -c . | docker import - void
rm -rf docker-void
