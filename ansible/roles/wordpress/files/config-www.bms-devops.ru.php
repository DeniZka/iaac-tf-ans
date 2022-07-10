<?php

if($_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https'){

    $_SERVER['HTTPS'] = 'on';
    $_SERVER['SERVER_PORT'] = 443;
}

define('DB_NAME', 'wordpress');
define('DB_USER', 'wordpress');
define('DB_PASSWORD', 'wordpress');
define('DB_HOST', '172.16.0.101');
define('WP_CONTENT_DIR', '/var/lib/wordpress/wp-content');
?>

