
*This project has been created as part of the 42 curriculum by jroulet. (jimmy roulet)*

# Inception

## Description

Inception is a system administration project where the goal is to set up a small infrastructure using Docker Compose on a virtual machine. Three services run in separate containers — NGINX, WordPress (with php-fpm), and MariaDB — connected through a private Docker network.

NGINX is the only entry point, exposed on port 443 using TLS 1.2 or 1.3. WordPress handles the site logic via php-fpm on port 9000, and MariaDB stores the database on port 3306. Data is persisted through two named volumes stored on the host at `/home/jroulet/data/`.


## Instructions

### Requirements

- Docker and Docker Compose installed on the VM
- The `secrets/` directory at the project root with three files:
  - `secrets/db_password.txt`
  - `secrets/db_root_password.txt`
  - `secrets/credentials.txt`
- `srcs/.env` configured 
- The domain `jroulet.42.fr` pointing to the VM's local IP (see  `/etc/hosts`)

### Build and start

```bash
make
```

Builds all images and starts the containers in detached mode. The site runs at `https://jroulet.42.fr`.

### Stop

```bash
make down
```

### Other useful targets

```bash
make logs     # stream logs from all containers
make ps       # list containers and their status
make clean    # stop and prune containers/images
make fclean   # clean + remove volumes and host data
make re       # full rebuild from scratch
```

## Resources

- Docker documentation: https://docs.docker.com
- Guide from 42 student https://tuto.grademe.fr/inception/
- Docker Compose reference: https://docs.docker.com/compose/compose-file/
- Youssef medium article : https://medium.com/@imyzf/inception-3979046d90a0
- Inception guide : 42-cursus.gitbook.io/guide/5-rank-05/inception-doing
- MariaDB in Docker: https://mariadb.com/kb/en/installing-and-using-mariadb-via-docker/


**AI usage:** I used ChatGPT for the markdown files in this project. I did the writing and the AI did the formatting. The AI also helped me write them in English.
