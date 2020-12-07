# PHPMyAdmin

This role installs a phpmyadmin docker container

## Optional SSL/HTTPS configuration

To run phpmyadmin with SSL configuration simply add the following variables to the playbook.
```
  myadmin_url: URL/server_name
  cert_path: "/path/to/cert.crt"
  key_path: "/path/to/key.key"
```
Note that doing this will forward all http requests to https
