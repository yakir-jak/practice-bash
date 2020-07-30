#Created BY: Yakir BST
#Date: 21/07/20
#Purpose: install and configure apache2 with ssl certificate
#

################ VARS ###############
Ubuntu=ubuntu
Domain=''
Os=''
SubDomain=''
PS3="What You Need To do? :"

########## FUNCS #############
f_check_os(){                   #CHECK OPERATION SYSTEM
        Os=$(cat /etc/os-release|awk -F'=' {'print $2'}|awk 'FNR == 3 {print}')
        f_print_os
}

f_print_os(){   #PRINT OS VARAIBLE
                echo $Os
        }

f_install_apache(){     #UPDATE AND INSTALL APACHE2
        apt-get update -y
        apt-get install apache2 -y
}

f_install_nginx(){              # UPDATE AND INSTALL NGINX
        apt-get update -y
        apt-get install nginx -y
}

f_ssl_apache(){         #CREATE SSL CERTIFICATE & CONFIGURE SSL-PARAMS.CONF

        #CHECK DOMAIN FLAG
        if [[ $domain == '' ]];then
                read -p "Insert A Domain Name: " Domain
        else echo "$domain is the domain name"
        fi
#create ssl variable
        Ssl=$(openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/$Domain-selfsigned.key -out /etc/ssl/certs/$Domain-selfsigned.crt -subj "/C=''/ST=''/L=''/O=''/OU=''/CN='$Domain'/emailAddress=''")
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/$Domain-selfsigned.key -out /etc/ssl/certs/$Domain-selfsigned.crt -subj "/C=''/ST=''/L=''/O=''/OU=''/CN='$Domain'/emailAddress=''"
        openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048    #CREATE DHPARAM.CONF
        echo "insert text here" > /etc/apache2/conf-available/ssl-params.conf

        echo 'SSLCipherSuite EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH
SSLProtocol All -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
SSLHonorCipherOrder On
# Disable preloading HSTS for now.  You can use the commented out header line that includes
# the "preload" directive if you understand the implications.
# Header always set Strict-Transport-Security "max-age=63072000; includeSubDomains; preload"
Header always set X-Frame-Options DENY
Header always set X-Content-Type-Options nosniff
# Requires Apache >= 2.4
SSLCompression off
SSLUseStapling on
SSLStaplingCache "shmcb:logs/stapling-cache(150000)"
# Requires Apache >= 2.4.11
SSLSessionTickets Off' > /etc/apache2/conf-available/ssl-params.conf
}

f_ssl_nginx(){          # CREATE SSL CERTIFICATE FOR NGINX

        # CHECK DOMAIN FLAG
        if [[ $Domain == '' ]];then
                read -p "Insert A Domain Name: " Domain
        else echo "$Domain is the domain name"
        fi

        # CREATE SSL CERT
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/$Domain-selfsigned.key -out /etc/ssl/certs/$Domain-selfsigned.crt -subj "/C=''/ST=''/L=''/O=''/OU=''/CN='$Domain'/emailAddress=''"
        Ssl=$(openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/$Domain-selfsigned.key -out /etc/ssl/certs/$Domain-selfsigned.crt -subj "/C=''/ST=''/L=''/O=''/OU=''/CN='$Domain'/emailAddress=''")
        openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

        echo -e "ssl_certificate /etc/ssl/certs/$Domain-selfsigned.crt;
        ssl_certificate_key /etc/ssl/private/$Domain-selfsigned.key;" > /etc/nginx/snippets/self-signed.conf    # ADD FILES TO /NGINX/SNUPPETS (WILL INCLUDE IN CONF FILE)

        echo "insert text here" > /etc/nginx/snippets/ssl-params.conf
        echo 'ssl_protocols TLSv1.2;
ssl_prefer_server_ciphers on;
ssl_dhparam /etc/ssl/certs/dhparam.pem;
ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384;
ssl_ecdh_curve secp384r1; # Requires nginx >= 1.1.0
ssl_session_timeout  10m;
ssl_session_cache shared:SSL:10m;
ssl_session_tickets off; # Requires nginx >= 1.5.9
ssl_stapling on; # Requires nginx >= 1.3.7
ssl_stapling_verify on; # Requires nginx => 1.3.7
resolver 8.8.8.8 8.8.4.4 valid=300s;
resolver_timeout 5s;
# Disable strict transport security for now. You can uncomment the following
# line if you understand the implications.
# add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload";
add_header X-Frame-Options DENY;
add_header X-Content-Type-Options nosniff;
add_header X-XSS-Protection "1; mode=block";' > /etc/nginx/snippets/ssl-params.conf
}

f_create(){     #CREATE DOMAIN DIRECTORY
        # CHECK DOMAIN FLAG
        if [[ $Domain == '' ]];then
                read -p "Insert A Domain Name: " Domain
        else echo "$Domain is the domain name"
        fi
        # CREATR DOMAIN-dir , ADD "it works" TO index.html FILE . WE'LL SEE THIS TEXT IF EVERYTHING WORKS
        mkdir /var/www/$Domain
        echo "it works!" > /var/www/$Domain/index.html
        chmod -R 755 /var/www/  # GIVE PERMISSIONS


}

f_config_apache(){      #CONFIGURE APACHE2 CONF FILE IN SITE-AVAILABLE (HTTP & HTTPS)
        cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$Domain.conf


        echo "<VirtualHost *:80>
        ServerName $Domain
        ServerAlias www.$Domain
        DocumentRoot /var/www/$Domain
</VirtualHost>

<IfModule mod_ssl.c>
        <VirtualHost *:443>
#MAIN DETAILS
                Protocols h2 http:/1.1
                ServerName $Domain
                ServerAlias www.$Domain
                DocumentRoot /var/www/$Domain
#ERROR LOG FILES
                ErrorLog ${APACHE_LOG_DIR}/error.log
                CustomLog ${APACHE_LOG_DIR}/access.log combined
# SSL CERTIFICATE
                SSLEngine on
                SSLCertificateFile      /etc/ssl/certs/$Domain-selfsigned.crt
                SSLCertificateKeyFile /etc/ssl/private/$Domain-selfsigned.key

        </VirtualHost>
</IfModule>" > /etc/apache2/sites-available/$Domain.conf

        rm /etc/apache2/sites-enabled/000-default.conf  # REMOVE DEFAULT FILE FROM SITES-ENABALED
        a2ensite $Domain.conf   # CREATE SOTF LINK
        a2enmod ssl             # ACTIVATE SSL MODE
        a2enmod headers         # aCTIVATE HEADERS MODE
        a2enconf ssl-params.conf        # "PUSH" SSLPARAMS.CONF
        source /etc/apache2/envvars     # ACTIVATE ENVIROMANT VARIABL#       ln -s /etc/apac

        systemctl restart apache2
}

f_config_nginx(){       # CONFIGURE NGINX

        cp /etc/nginx/sites-available/default /etc/nginx/sites-available/$Domain

        echo "server {
    listen 80;
    listen [::]:80;

    root /var/www/$Domain;
    server_name $Domain www.$Domain;

}

server {
    listen 443 ssl http2 default_server;
    listen [::]:443 ssl http2 default_server;
    include snippets/self-signed.conf;
    include snippets/ssl-params.conf;

    server_name $Domain www.$Domain;

    root /var/www/$Domain;
    index index.html index.htm index.nginx-debian.html;

    location /{
                try_files \$uri \$uri/ \$uri/index.html /index.html =404;
        }


}" > /etc/nginx/sites-available/$Domain

        rm /etc/nginx/sites-enabled/default     # REMOVE DEFAULT CONG FROM SITES-ENABLED
        ln -s /etc/nginx/sites-available/$Domain /etc/nginx/sites-enabled/$Domain       # CREATE SOFT LINK OF CONFIG FILE
        systemctl restart nginx
}


f_check_server(){       #CHECK APACHE2 STATUS
        systemctl status apache2 && sleep 1
        apache2 -t && sleep 1.5
        journalctl -xe
}

f_remove_apache(){      #PURGE APACHE2 & DOMAIN DIRECTORY
        #CHECK DOMAIN FLAG
        if [[ $Domain == '' ]];then
                read -p "Insert A Domain Name: " Domain
        else echo "$Domain is the domain name"
        fi

        apt-get purge apache2 -y
        rm -rf /etc/apache2/    # REMOVE APACHE DIR RECRUSIVE
        rm -rf /var/www/*.com /var/www/*xyz     # DELETE ALL DIR ENDED WITH .COM AND .XYZ
        rm -rf /etc/ssl/private/$Domain* && rm -rf /etc/ssl/certs/$Domain*      # REMOVE SSL KEY AND CERT
        rm -rf /etc/ssl/private/test* && rm -rf /etc/ssl/certs/test*            # REMOVE SSL KEY AND CERT
}

f_remove_nginx(){       # REMOVE NGINX AND DEPENDESIS
        #CHECK DOMAIN FLAG
        if [[ $Domain == '' ]];then
                read -p "Insert A Domain Name: " Domain
        else echo "$Domain is the domain name"
        fi

        apt-get purge nginx nginx-common -y
        rm -rf /etc/nginx        # REMOVE NGIX DIR RECRUSIVE
        rm -rf /var/www/*.com /var/www/*xyz      # DELETE ALL DIR ENDED WITH .COM AND .XYZ
        rm -rf /etc/ssl/private/$Domain* && rm -rf /etc/ssl/certs/$Domain*      # REMOVE SSL KEY AND CERT
        rm -rf /etc/ssl/private/test* && rm -rf /etc/ssl/certs/test*    # REMOVE SSL KEY AND CERT
}

f_stage_nginx(){                # CREATING STAGE ENVIROMENT

        #SEPERATE DOMAIN NAME: EXAMPLE  COM // EXAMPLE2 XYZ
        Domain_I=$(echo "$Domain"|awk -F'.' {'print $1'})
        Domain_II=$(echo "$Domain"|awk -F'.' {'print $2'})
        # CHECK SUB DOMAIN FLAG
        if [[ $SubDomain == '' ]];then
                read -p "Insert A Domain Name: " SubDomain
        else echo "$SubDomain is the subdomain name"
        fi

        mkdir /var/www/$Domain/$SubDomain       # CREATE SUN DOMAIN DIR

        cp /etc/nginx/sites-available/default /etc/nginx/sites-available/auto_$SubDomain.$Domain
        # CREATING LOGS FILE, WHITELIST, CONFIGURE NGINX
        echo "## Custom Errors
error_page 403 /403.html;
location = /403.html {
# root /var/www/html/custom;
        root /etc/nginx/pages;
        internal;
        }" > /etc/nginx/custom_errors.conf

        echo "#Access Log :" > /var/log/nginx/stage.access.log
        echo "Error Log :" > /var/log/nginx/stage.error.log
        echo -e "#White List\n#Deny Rest Of World" > /etc/nginx/IP.whitelist.conf

        echo "# Automatically create subdomains based on directory existence.
server {
        listen 80;
        listen 443 ssl;

        include snippets/self-signed.conf;
        include snippets/ssl-params.conf;

        server_name   ~^(.*)-$Domain_I\.$Domain_II$;

        access_log  /var/log/nginx/stage.access.log;
        error_log  /var/log/nginx/stage.error.log;


        location /ngsw-worker.js {
                add_header Cache-Control "max-age=0";
        }

        # If a directory doesn't exist...
        if (!-d /var/www/$Domain/\$1) {
                # If a client requests a subdomain but the server does not have a folder to serve, redirect back to the main site.
                rewrite . http://$Domain/ redirect;
        }

        # Sets the correct root
        root /var/www/$Domain/\$1;

        set \$brand \$1;
        location ~* \.(js|jpg|png|css|svg|txt)$ {
            root /var/www/$Domain/\$brand;
            try_files \$uri =404;
        }


        location / {
#               include /etc/nginx/restricted.conf;
                include /etc/nginx/IP.whitelist.conf;
                index index.html;
                try_files \$uri \$uri/ \$uri/index.html /index.html =404;
        }

        include /etc/nginx/custom_errors.conf ;

}" > /etc/nginx/sites-available/auto_$SubDomain.$Domain

        rm /etc/nginx/sites-enabled/default     # REMOVE DEFAULT FROM SITES-ENABLED
        ln -s /etc/nginx/sites-available/auto_$SubDomain.$Domain /etc/nginx/sites-enabled/auto_$SubDomain.$Domain       # CREATE SOFR LINK FOR SUB DOMAIN
        systemctl restart nginx

}

f_qa_nginx(){   # CREATE QA ENVIROMENT

        Domain_I=$(echo "$Domain"|awk -F'.' {'print $1'})
        Domain_II=$(echo "$Domain"|awk -F'.' {'print $2'})

        if [[ $SubDomain == '' ]];then
                read -p "Insert A Domain Name: " SubDomain
        else echo "$SubDomain is the subdomain name"
        fi


        mkdir /var/www/$Domain/$SubDomain

        cp /etc/nginx/sites-available/default /etc/nginx/sites-available/auto_$SubDomain.$Domain
        # CREATE ERROR LOG FILE FOR QA
        echo "## Custom Errors
error_page 403 /403.html;
location = /403.html {
# root /var/www/html/custom;
        root /etc/nginx/pages;
        internal;
        }" > /etc/nginx/custom_errors.conf

        echo "#Access Log :" > /var/log/nginx/qa.access.log
        echo "Error Log :" > /var/log/nginx/qa.error.log
        echo -e "#White List\n#Deny Rest Of World" > /etc/nginx/IP.whitelist.conf

        echo "# Automatically create subdomains based on directory existence.
server {
        listen 80;
        listen 443 ssl;

        include snippets/self-signed.conf;
        include snippets/ssl-params.conf;

        server_name   ~^(.*)-$Domain_I\.$Domain_II$;

        access_log  /var/log/nginx/qa.access.log;
        error_log  /var/log/nginx/qa.error.log;


        location /ngsw-worker.js {
                add_header Cache-Control "max-age=0";
        }

        # If a directory doesn't exist...
        if (!-d /var/www/$Domain/\$1) {
                # If a client requests a subdomain but the server does not have a folder to serve, redirect back to the main site.
                rewrite . http://$Domain/ redirect;
        }

        # Sets the correct root
        root /var/www/$Domain/\$1;

        set \$brand \$1;
        location ~* \.(js|jpg|png|css|svg|txt)$ {
            root /var/www/$Domain/\$brand;
            try_files \$uri =404;
        }


        location / {
#               include /etc/nginx/restricted.conf;
                include /etc/nginx/IP.whitelist.conf;
                index index.html;
                try_files \$uri \$uri/ \$uri/index.html /index.html =404;
        }

        include /etc/nginx/custom_errors.conf ;

}" > /etc/nginx/sites-available/auto_$SubDomain.$Domain

        ln -s /etc/nginx/sites-available/auto_$SubDomain.$Domain /etc/nginx/sites-enabled/auto_$SubDomain.$Domain
        systemctl restart nginx

}


f_cron(){       #CREATE CRON JOB - RENEW SSL CERT EVERY MONTH (00:00 , FIRST OF EVERY MONTH)
#       Ssl=$(openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/$Domain-selfsigned.key -out /etc/ssl/certs/$Domain-selfsigned.crt -subj "/C=''/ST=''/L=''/O=''/OU=''/CN='$Domain'/emailAddress=''")
        echo "  0  0  1  *  * $USER  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/$Domain-selfsigned.key -out /etc/ssl/certs/$Domain-selfsigned.crt -subj "/C=''/ST=''/L=''/O=''/OU=''/CN='$Domain'/emailAddress=''"" >> /etc/crontab
}


while getopts d:s: flag
do
    case "${flag}" in
        d) Domain=${OPTARG};;
        s) SubDomain=${OPTARG};;
    esac
done

$domain=$Domain
$SubDomain=$sub_domain


# CHECK POSITIONAL PARAMETERS
if [ $1 == apache ];then
        f_install_apache
        f_ssl_apache
        f_create
        f_config_apache
        f_cron
        exit
elif [[ " $@ " =~ " nginx " ]] && [[ " $@ " =~ " stage " ]];then
        f_install_nginx
        f_ssl_nginx
        f_create
        f_stage_nginx
        f_qa_nginx
        f_cron
        exit
elif    [[ " $1 " =~ " nginx " ]];then
        f_install_nginx
        f_ssl_nginx
        f_create
        f_config_nginx
        f_cron
        exit
else    echo "Web Server With SSL -  Install & config. (Apache2/Nginx)"
fi

###MAIN#### # USING SELECT LOOP TO CREATE INTERACTIVE MANUE BY EXECUTE FUNCS

select i in "Check OS" "Install Apache" "Install Nginx" "Install Stage ENV" "Remove Apache" "Remove Nginx" "Exit"
do
        case $i in
                "Check OS") f_check_os ;;
                "Install Apache") f_install_apache && f_ssl_apache && f_create && f_config_apache && f_cron;;
                "Install Nginx") f_install_nginx && f_ssl_nginx && f_create && f_config_nginx && f_cron ;;
                "Install Stage ENV") f_install_nginx && f_ssl_nginx && f_create && f_stage_nginx && f_qa_nginx && f_cron ;;
                "Remove Apache") f_remove_apache ;;
                "Remove Nginx") f_remove_nginx ;;
                "Exit") exit ;;
        esac
done
