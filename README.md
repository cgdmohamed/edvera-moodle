# Edvera Moodle 5.1.8 on Coolify

1. Create a PRIVATE GitHub repository and upload these four files.
2. In Coolify: Project > New Resource > Private Repository (GitHub App or deploy key) > Docker Compose build pack.
3. Compose file: /docker-compose.yml. Set MOODLE_DB_PASSWORD and MARIADB_ROOT_PASSWORD to separate strong generated values in Environment Variables.
4. Configure the domain https://edvera.tech for the **moodle** service, internal port **80** only. Never expose db or cron.
5. Deploy. Wait for db health then app start. Visit https://edvera.tech/admin to finish the web installer.
6. Backup both named volumes and your private compose/env; secure dashboard, HTTPS and test restore.

Do not use `docker compose down -v` or delete persistent storage.

NOTE: On 1 vCPU and 2GB RAM, image building may fail or exhaust memory; preferably build the image via an external CI pipeline or upgrade to 2 vCPU/4 GB for reliable operation. Ensure HTTP 80/HTTPS 443 inbound to Coolify Proxy.
