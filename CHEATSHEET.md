# Pense-Bête — Evaluation Inception

---

## Credentials

| Element | Valeur |
|---|---|
| Domain | `jroulet.42.fr` |
| DB name | `wordpress` |
| DB user | `wpuser` |
| DB user password | `WordPressDbPass123!` |
| DB root password | `RootDbPass123!` |
| WP admin user | `jroulet` |
| WP admin password | `WpSecurePass123!` |
| WP admin email | `jroulet@student.42.fr` |
| WP user2 | `wpuser2` |
| WP user2 password | `WpLessSecurePass123!` |

---

## Commandes pratiques

### Reset complet (l'evaluateur le fait en premier)
```bash
docker stop $(docker ps -qa)
docker rm $(docker ps -qa)
docker rmi -f $(docker images -qa)
docker volume rm $(docker volume ls -q)
docker network rm $(docker network ls -q) 2>/dev/null
```

### Lancer le projet
```bash
make
```

### Verifier les containers
```bash
docker compose -f srcs/docker-compose.yml ps
```

### Verifier les volumes
```bash
docker volume ls
docker volume inspect srcs_mariadb_data    # doit contenir /home/jroulet/data
docker volume inspect srcs_wordpress_data  # doit contenir /home/jroulet/data
```

### Verifier le reseau
```bash
docker network ls                          # doit voir "inception"
docker network inspect srcs_inception
```

### Connexion a la base de donnees
```bash
# En tant que root
docker exec -it mariadb mysql -u root -pRootDbPass123!

# En tant que wpuser
docker exec -it mariadb mysql -u wpuser -pWordPressDbPass123! wordpress

# Verifier que la DB n'est pas vide
docker exec -it mariadb mysql -u root -pRootDbPass123! \
  -e "SHOW DATABASES; USE wordpress; SHOW TABLES;"

# Voir les users WordPress
docker exec -it mariadb mysql -u root -pRootDbPass123! \
  -e "USE wordpress; SELECT user_login, user_email FROM wp_users;"
```

### Verifier le TLS
```bash
openssl s_client -connect jroulet.42.fr:443
# chercher "TLSv1.2" ou "TLSv1.3" dans la sortie
```

### Modifier un port (question de l'evaluateur)
```bash
# Dans srcs/docker-compose.yml, changer :
#   "443:443"  →  "8443:443"
# Puis :
make down
make all
```

### Voir les logs
```bash
make logs
# ou par service :
docker logs nginx
docker logs wordpress
docker logs mariadb
```

---

## Reponses aux questions

### "Comment fonctionne Docker ?"
Docker utilise les namespaces et cgroups du kernel Linux pour isoler des processus dans des containers. Contrairement aux VMs, les containers partagent le kernel de la machine hote — ils sont plus legers et demarrent en quelques secondes. Une image Docker est un systeme de fichiers en lecture seule (les layers), et un container c'est une image qui tourne.

### "Difference entre image Docker avec et sans docker compose ?"
- **Sans compose** : on lance chaque container a la main avec `docker run`, il faut specifier le reseau, les volumes, les variables d'environnement a chaque fois.
- **Avec compose** : tout est declare dans le `docker-compose.yml`, un seul `docker compose up` lance tous les services avec leurs dependances, volumes et reseau configures automatiquement.

### "Avantage de Docker vs VM ?"
| | VM | Docker |
|---|---|---|
| OS | Complet (kernel propre) | Partage le kernel hote |
| RAM | 1-2 Go minimum | Quelques Mo |
| Demarrage | Plusieurs minutes | Quelques secondes |
| Isolation | Totale | Partielle (kernel partage) |
| Portabilite | Lourde | Excellente |

### "Pourquoi cette structure de dossiers ?"
- `srcs/` regroupe toute la config Docker (obligatoire par le sujet)
- `secrets/` separe les credentials du code et est ignore par git
- `Makefile` a la racine pour simplifier les commandes
- Un dossier par service dans `requirements/` pour que chaque Dockerfile soit independant et maintenable

### "Explique le docker-network ?"
Un reseau Docker bridge cree un switch virtuel interne. Les containers connectes a ce reseau peuvent se parler via leur **nom de service** comme hostname (ex: `wordpress` peut joindre `mariadb` directement). Depuis l'exterieur, seul le port 443 de nginx est expose — les autres containers ne sont pas accessibles depuis l'hote.

### "Comment tu te connectes a la DB ? Elle n'est pas vide ?"
```bash
docker exec -it mariadb mysql -u root -pRootDbPass123!
# puis dans mysql :
SHOW DATABASES;
USE wordpress;
SHOW TABLES;
SELECT user_login, user_email FROM wp_users;
```
La DB contient les tables WordPress et les 2 users : `jroulet` (admin) et `wpuser2` (author).

### "Pourquoi secrets Docker plutot que variables d'environnement ?"
Les variables d'environnement sont visibles avec `docker inspect` ou dans les logs. Les secrets Docker sont montes en tant que fichiers dans `/run/secrets/` a l'interieur du container uniquement, non visibles depuis l'exterieur, et jamais loggues.

### "Persistence : que se passe-t-il apres reboot ?"
Les volumes stockent les donnees dans `/home/jroulet/data/` sur la machine hote. Meme si les containers sont supprimes, les donnees restent sur le disque. Au redemarrage, `make` recree les containers qui remontent les memes volumes — les posts, users et configs WordPress sont intacts.

### "Pourquoi php-fpm separe de nginx ?"
Le sujet l'exige, mais c'est aussi une bonne pratique : nginx gere les fichiers statiques et le TLS, php-fpm execute le PHP. Separer les responsabilites permet de scaler chaque service independamment et de mieux isoler les failles de securite.

---

## Architecture

```
Internet (port 443)
       |
   [NGINX]  ← TLS 1.2/1.3, reverse proxy
       |
   [WordPress + php-fpm]  ← port 9000
       |
   [MariaDB]  ← port 3306
       |
  Volume DB        Volume WP
/home/jroulet/data/mariadb   /home/jroulet/data/wordpress
```

---

## Fichiers importants

| Fichier | Role |
|---|---|
| `srcs/docker-compose.yml` | Definition de tous les services |
| `srcs/.env` | Variables d'environnement (domain, DB name, user) |
| `secrets/credentials.txt` | Identifiants WordPress |
| `secrets/db_password.txt` | Mot de passe DB user |
| `secrets/db_root_password.txt` | Mot de passe DB root |
| `srcs/requirements/nginx/conf/nginx.conf` | Config NGINX + TLS |
| `srcs/requirements/mariadb/tools/init-db.sh` | Init de la base de donnees |
| `srcs/requirements/wordpress/tools/install-wordpress.sh` | Installation WordPress |
