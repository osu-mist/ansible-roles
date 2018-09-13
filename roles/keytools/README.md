Keytools
===

This role is to create certificates with Java keytool and OpenSSL.

This role will create 4 files:
- server.keystore - Contains the certificate and private key for use by JVM
  applications.
- server.truststore - Contains the certificate used in server.keystore.
- server.pem - X509 certificate, which is also located in server.keystore and
  server.truststore.
- server.key - Private key for certificate, also located in server.keystore.

server.pem and server.key are kept separate for applications that don't interact
with keystores.

**DO NOT** put keystore passwords like `store_password` and `key_password`
in `defaults/main.yml` or the playbook. Instead, define your passwords in `vault.yml`.
See this [readme](../../README.md#usage) for more information about using
ansible-vault.
