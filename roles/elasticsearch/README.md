# Elasticsearch Role

This role will set up Elasticsearch in a Docker container and then POST
templates to Elasticsearch. The templates are required by the
[locations-api](https://github.com/osu-mist/locations-api).

## Known Issues
There is a [known issue](https://github.com/ansible/ansible/issues/32499) that
could occur if this role is run in a macOS High Sierra environment. A workaround
for this issue is to run this command on the host machine:
```bash
$ export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
```
