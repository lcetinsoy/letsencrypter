server {/

    location ~ /\.well-known/acme-challenge { allow all; }

    root /var/www/myapp.com
    server_name myapp.com

    index app.php;

    location / {

	     try_files $uri /app.php$is_args$args;
    }

    error_log /var/www/myapp.com/project_error.log;
    access_log /var/www/myapp.com/logs/project_access.log;

}
