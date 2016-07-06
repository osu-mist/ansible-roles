This is a role for ansible which installs hubot.
It also installs supervisord to monitor hubot.

Requires ansible 1.6 or above.

Usage
----

Check this repo out into your roles/ directory.
In your ansible playbook, add the `ansible-hubot` role to whichever hosts you
want to install hubot on.

For example:

    - hosts: all
      roles:
        - ansible-hubot

      vars:
        hubot_adapter: irc
        hubot_env: ...

Vars
----

`hubot_repo` The URL of the hubot git repo. By default, ansible-hubot looks for it at /vagrant/hubot.git.

`hubot_adapter` The adapter to use. Defaults to irc, but you can use any [hubot adapter][].

`hubot_env` A dict of extra environment variables to set when running hubot.
This is typically where you would put login credentials or other sensitive settings that can't be committed directly to the hubot repo.

[hubot adapter]: https://www.npmjs.com/search?q=hubot+adapter

Adapters
----

### IRC ###

The `irc` adapter allows hubot to talk over IRC.
This is the default adapter.

You'll need to set `HUBOT_IRC_SERVER` and `HUBOT_IRC_ROOMS` at a minimum.

    vars:
        hubot_adapter: irc
        hubot_env:
            HUBOT_IRC_SERVER: irc.freenode.com
            HUBOT_IRC_ROOMS: '#hubot'

More documentation: <https://github.com/nandub/hubot-irc>

### HipChat ###

The `hipchat` adapter allows hubot to talk over HipChat.

You'll need to set `HUBOT_HIPCHAT_JID`, `HUBOT_HIPCHAT_PASSWORD` at a minimum.
You can set `HUBOT_HIPCHAT_ROOMS` to tell hubot which rooms to join,
or leave it blank to have it join all rooms.
You'll probably want to create a new HipChat account for hubot to use.

    vars:
        hubot_adapter: hubot
        hubot_env:
            HUBOT_HIPCHAT_JID: '123456_1234567@chat.hipchat.com'
            HUBOT_HIPCHAT_PASSWORD: '********'
            HUBOT_HIPCHAT_ROOMS: '123456_hubot@conf.hipchat.com'

More documentation: <https://github.com/hipchat/hubot-hipchat#adapter-configuration>
