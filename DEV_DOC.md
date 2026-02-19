
# Developer Documentation — Inception

## Setting up the environment from scratch

### Prerequisites

- A Linux VM (Debian or Alpine)
- Docker installed: `apt install docker.io`
- Docker Compose v2: `apt install docker-compose-plugin` (or the standalone binary)
- `make`

### Directory structure

```
.
├── Makefile
├── secrets/
│   ├── credentials.txt
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        └── wordpress/
            ├── Dockerfile
            ├── conf/
            └── tools/
```

### Secrets

Put the `secrets/` directory and write the three files manually. 

```bash
mkdir secrets
echo "your_wp_admin_password" > secrets/credentials.txt
echo "your_db_user_password" > secrets/db_password.txt
echo "your_db_root_password" > secrets/db_root_password.txt
```

The container init scripts read these files from `/run/secrets/` at startup.

### Environment file

`srcs/.env` must define at minimum:

```
DOMAIN_NAME=jroulet.42.fr
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
```

The `.env` file in `srcs/` can be used as a reference (it contains non-sensitive variable names).

### Domain

Add the domain to `/etc/hosts` on the host machine so it resolves to the VM's IP:

```
127.0.0.1    jroulet.42.fr
```

---

## Building and launching

```bash
make
```

This calls `docker compose build` (builds all three images from their Dockerfiles) then `docker compose up -d`. 

### Makefile options

| options | output |
|---|---|
| `make` / `make all` | Build images and start containers |
| `make build` | Build images only |
| `make up` | Start containers (images must already exist) |
| `make down` | Stop and remove containers |
| `make start` | Start stopped containers |
| `make stop` | Stop running containers |
| `make restart` | Stop then start |
| `make logs` | Stream logs from all services |
| `make ps` | List containers and status |
| `make clean` | `down` + `docker system prune -af` |
| `make fclean` | `clean` + remove volumes and host data |
| `make re` | Full rebuild from scratch |

---

## Managing containers and volumes

**Inspect a container:**
```bash
docker inspect nginx
docker inspect wordpress
docker inspect mariadb
```

**Open a shell inside a container:**
```bash
docker exec -it mariadb bash
docker exec -it wordpress sh
```

**Connect to the MariaDB database:**
```bash
docker exec -it mariadb mysql -u root -p

docker exec -it mariadb mysql -u wpuser -p wordpress
```

**List volumes:**
```bash
docker volume ls
```

**Inspect a volume :**
```bash
docker volume inspect srcs_mariadb_data
docker volume inspect srcs_wordpress_data
```

**Remove a volume manually:**
```bash
docker volume rm srcs_mariadb_data
```

**Full cleanup:**
```bash
make fclean
```
This stops everything, delete images and containers, removes both volumes, and clears the host data directories.

---

## Data persistence

Both named volumes store data on the host at:

- `/home/jroulet/data/mariadb` — MariaDB database files
- `/home/jroulet/data/wordpress` — WordPress files (mounted at `/var/www/html` in the container)

These directories are created automatically by `make`. If containers are removed and re-created, they remount the same data — WordPress posts, users, and config are preserved.

The volumes are declared in `docker-compose.yml` as `local` volumes with explicit host paths:

```yaml
volumes:
  mariadb_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/jroulet/data/mariadb
```

To fully wipe everything including data on disk, run `make fclean`. After that, `make` will rebuild from scratch with a clean database.
