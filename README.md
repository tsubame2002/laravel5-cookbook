# laravel5-cookbook


## setup
apache2 php apache2::mod_php5 composer  apache2::mod_rewrite

## configure
deploy::apache-vhost

## deploy
deploy::project-deploy



## CUSTOM JSON

```javascript
{
  "apache": {
    "package": "httpd24",
    "service_name": "httpd",
    "version": "2.4",
    "lock_dir": "/var/run/httpd",
    "default_site_enabled": false,
    "listen_addresses": ["*"],
    "listen_ports": ["80"]
  },
  "php": {
    "packages": [
      "php56",
      "php56-devel",
      "php56-mcrypt",
      "php56-mbstring",
      "php56-gd",
      "php56-bcmath",
      "php56-tidy",
      "php56-pdo",
      "php56-mysqlnd",
      "php56-pecl-memcached",
      "php56-pecl-apcu",
      "php56-opcache"
    ],
    "directives": {
      "error_log": "/var/log/httpd/php_errors.log"
    }
  },
"dotenv":{
      "APP_ENV": "development",
      "APP_DEBUG": true,
      "APP_KEY": ""
},
"user": "apache",
"group": "apache",
"vhost_dir": "sites-enabled"
}
```
