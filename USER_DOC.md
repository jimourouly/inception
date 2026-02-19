
# User Documentation — Inception

## What this does

Three containers run together to serve a WordPress site:

- **NGINX** — handles HTTPS on port 443 (TLS 1.2/1.3)
- **WordPress + php-fpm** — processes PHP on port 9000
- **MariaDB** — the database, stores all WordPress content and users

Port 443 is the only one exposed to the outside. WordPress and MariaDB are not reachable directly from the host.

---

## Starting and stopping

**Build and start everything from scratch:**
```bash
make
```

**Start already-built containers:**
```bash
make up
```

**Stop containers without removing them:**
```bash
make stop
```

**Stop and remove containers:**
```bash
make down
```

---

## Accessing the site

Once the containers are running, open a browser and go to:

```
https://jroulet.42.fr
```

The TLS certificate is self-signed, so the browser will show a security warning. Accept it to continue.

**WordPress admin panel:**
```
https://jroulet.42.fr/wp-admin
```

Log in with the admin credentials from `secrets/credentials.txt`.

---

## Credentials

Credentials are stored in the `secrets/` directory at the project root. 
| File | What it contains |
|---|---|
| `secrets/credentials.txt` | WordPress admin username and password |
| `secrets/db_password.txt` | MariaDB user password (`wpuser`) |
| `secrets/db_root_password.txt` | MariaDB root password |

Inside running containers, secrets are mounted at `/run/secrets/` and are not visible from outside.

---

## Checking that services are running

**List containers and their status:**
```bash
docker compose -f srcs/docker-compose.yml ps
```

**Follow logs from all services:**
```bash
make logs
```

**Logs for a single service:**
```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

**Verify TLS is working:**
```bash
openssl s_client -connect jroulet.42.fr:443
```
Look for `TLSv1.2` or `TLSv1.3` in the output.

**Check the database is up:**
```bash
docker exec -it mariadb mysqladmin ping -h localhost
```
Should print `mysqld is alive`.
