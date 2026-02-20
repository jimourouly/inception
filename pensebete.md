
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

docker exec -it mariadb mysql -u root -pRootDbPass123!

openssl s_client -connect jroulet.42.fr:443
