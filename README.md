# UDP IP address blocking(Nginx on Docker)

### Purpose

`日本以外からのアクセス`を極力遮断する。

### Require

- Bash
- Docker
- DockerCompose

### 使い方

`setting.sh`の`<>`で囲われた部分を修正する。

| environment       | description                                                 |
| ----------------- | ----------------------------------------------------------- |
| IP                | LISTEN しているサーバーの IP アドレス                       |
| PORT              | LISTEN しているサーバーのポート番号                         |
| NGINX_LISTEN_PORT | NGINX が LISTEN するポート番号                              |
| NGINX_VERSION     | DockerHub から pull するときの tag でバージョンを指定する。 |

負荷分散が必要であれば`setting.sh`の以下の部分のコメントを外す。

```bash
#ip
export SERVER1="<IP>"
# export SERVER2="<IP>"
# export SERVER3="<IP>"
```

```
stream {
    include deny.conf; # BLOCK LIST(IP)

    upstream udp_servers {
        server ${SERVER1}:${PORT};
        # server ${SERVER2}:${PORT};
        # server ${SERVER3}:${PORT};
    }
```

ファイル生成

```bash
$ chmod +x setting.sh
$ sh setting.sh
$ docker-compose up -d
```

### Appendix

TCP ではなく UDP を使用する場合は下記の箇所を修正する。

- nginx.conf

```diff
- listen ${NGINX_LISTEN_PORT} udp;
+ listen ${NGINX_LISTEN_PORT};
```

- docker-compose.yml

```diff
- - "{PORT}:{NGINX_LISTE_PORT}/udp"
+ - "{PORT}:{NGINX_LISTE_PORT}"
```

アクセス制限を行う場合は`deny.conf`を編集する。
