# After the script, the vhost should be like that

server {

    root /var/www/myapp.com
    server_name myapp.com

    index app.php;

    location / {

	     try_files $uri /app.php$is_args$args;
    }

    error_log /var/www/myapp.com/project_error.log;
    access_log /var/www/myapp.com/logs/project_access.log;

    location / {

       try_files $uri /app_dev.php$is_args$args;
    }

}

server {

   listen 443 ssl;
   listen [::]:443 ssl default_server;
   server_name myapp.com
   ssl on;
   ssl_certificate /etc/letsencrypt/live/myapp.com/fullchain.pem;
   ssl_certificate_key /etc/letsencrypt/live/myapp.com/privkey.pem;

   root $documentRoot;
   # Add index.php to the list if you are using PHP
   index app.php;

}
