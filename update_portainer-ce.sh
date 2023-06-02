docker stop portainer-ce && docker rm portainer-ce
docker pull portainer/portainer-ce:latest
docker run -d -p 9000:9000 -p 8000:8000 --name portainer-ce --restart always -v /var/run/docker.sock:/var/run/docker.sock -v /app/portainer/data:/data portainer/portainer-ce:latest
