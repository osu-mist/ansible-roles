This is a role for ansible which installs hubot.
It also installs supervisord to monitor hubot.

Requires ansible 1.6 or above.

Usage
----

Check this repo out into your roles/ directory.
Then add the `ansible-hubot` role to whatever hosts you want to run hubot.

For example:

    - hosts: all
      roles:
        - ansible-hubot
