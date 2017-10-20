Run commands on a mysql container from a separate mysql container:
```
docker run --network=host --rm -it mysql sh -c 'exec mysql -uroot -h"127.0.0.1" -p'
```
