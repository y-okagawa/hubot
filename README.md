# hubot お試し

## vagrant起動

githubからリポジトリをクローンし、vagrantを起動します。

```sh
$ cd hubot/vagrant
$ vagrant up
$ vagrant provision
$ vagrant ssh
```

## hubot起動

vagrant内でhubotを起動します。

```sh
$ cd /srv/src/hubot
$ bin/hubot
hubot> hubot ping
hubot> PONG # 返答があれば起動成功
```

## GitHub Wiki Webhook
