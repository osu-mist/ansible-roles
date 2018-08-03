Keytools
===

This role is to create certificates with Java keytool or OpenSSL.

## Usage

1. By enabling `by_keytool: true` to create certificates by using Java keytool, or using `by_openssl: true` by using OpenSSL.
2. **DO NOT** put certificated password like `store_password` and `key_password` in `defaults/main.yml`, instead, define your passwords at the playbook level.
