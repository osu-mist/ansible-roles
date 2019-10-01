# Docker Health Monitor

Copies a script that checks for any unhealthy docker containers.

## Example Playbook

```yaml
---
  - hosts: api_servers

    tasks:
      - import_role:
          name: docker_health_monitor
        become: yes
```
