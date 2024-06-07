sistema web para:

* control de matriculas de un colegio
* control de alumnos
* control de padres
* control de caja

requerimientos:
* nginx
* php 8.2 fpm

tips: 
* el archivos de config de nginx se debe que de la siguiente forma
server{
    listen 80;
    server_name tu-dominio.com;

    root /var/www/tu-sitio;
    index index.php index.html index.htm;

    client_max_body_size 10M;  # Tamaño máximo del archivo a subir

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
* verifica la configuracion y recarga de nginx
sudo nginx -t
sudo systemctl reload nginx

* editar el archivo php.ini (sudo nano /etc/php/8.2/fpm/php.ini)
...
file_uploads = On
upload_max_filesize = 10M #tamaño maximo de carga
post_max_size = 10M #tamaño maximo por POST

* para habilitar la carga de archivos hay que darle permisos a la carpeta archivos de la siguiente manera:
sudo chown -R www-data:www-data /var/www/html/predios/data/archivos/
sudo chmod -R 755 /var/www/html/predios/data/archivos/