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

Vars
----

`hubot_repo` The URL of the hubot git repo. By default, ansible-hubot looks for it at /vagrant/hubot.git.

`hubot_adapter` The adapter to use. Defaults to irc, but you can use any [hubot adapter][]

`hubot_env` A dict of extra environment variables to set when running hubot. This is typically where you would put login credentials or other sensitive settings that can't be committed directly to the hubot repo.

[hubot adapter]: https://www.npmjs.com/search?q=hubot+adapter
