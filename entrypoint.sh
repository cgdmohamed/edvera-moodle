#!/bin/sh
set -eu
: "${MOODLE_DB_PASSWORD:?MOODLE_DB_PASSWORD required}"
: "${MOODLE_URL:?MOODLE_URL required}"
if [ ! -f /var/www/html/config.php ]; then
  cat > /var/www/html/config.php <<'PHP'
<?php
unset($CFG);
global $CFG;
$CFG = new stdClass();
$CFG->dbtype = 'mariadb';
$CFG->dblibrary = 'native';
$CFG->dbhost = 'db';
$CFG->dbname = 'moodle';
$CFG->dbuser = 'moodle';
$CFG->dbpass = getenv('MOODLE_DB_PASSWORD');
$CFG->prefix = 'mdl_';
$CFG->dboptions = array('dbpersist' => false, 'dbport' => 3306, 'dbsocket' => '', 'dbcollation' => 'utf8mb4_unicode_ci');
$CFG->wwwroot = getenv('MOODLE_URL');
$CFG->dataroot = '/var/moodledata';
$CFG->admin = 'admin';
$CFG->directorypermissions = 02770;
$CFG->sslproxy = true;
require_once(__DIR__ . '/lib/setup.php');
PHP
  chown www-data:www-data /var/www/html/config.php
  chmod 640 /var/www/html/config.php
fi
mkdir -p /var/moodledata
chown www-data:www-data /var/moodledata
exec "$@"
