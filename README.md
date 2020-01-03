# action-google-drive

このアクションは指定されたディレクトリ、ファイルをGoogle Driveへアップロードします。

## 準備

Google Driveへのアップロードには、[`skicka`](https://github.com/google/skicka)を使用しています。
事前にトークンを作成し、Secretsに登録を行う必要があります。

### トークンの作成

#### 既に `skicka` を使っている方

GitHub リポジトリ -> Settings -> Secrets にて、Name に `SKICKA_TOKENCACHE_JSON` を、Value に `~/.skicka.tokencache.json` の内容を入力して登録します。


#### `skicka` を使ったことがない方

1. Docker が使用できる環境を用意し、以下のコマンドを実行します。
    ```sh
    docker run --rm -it --entrypoint "" satackey/skicka sh -c "skicka -no-browser-auth ls && cat /root/.skicka.tokencache.json"
    ```
1. ブラウザで表示されたURLにアクセスします。
1. アクセスを許可し、コード表示されたら、ターミナルに戻り貼り付けます。
1. GitHub リポジトリ -> Settings -> Secrets にて、Name に `SKICKA_TOKENCACHE_JSON` を、Value に最後に表示された以下の様なテキストを入力して登録します。

    ```json
    {"ClientId":"xxx-xxxxx.apps.googleusercontent.com","access_token":"xxxx.xx-xxxxxxxxx","token_type":"Bearer","refresh_token":"x//xxxxxxx-xxxxxxx","expiry":"2020-01-03T06:11:01.3298117Z"}
    ````

##### `skicka` を使ったことがない方・手順1のログイン時の問題の回避

2020年1月2日現在、初めてskickaにログインするアカウントでは、
`このアプリでは「Google でログイン」機能が一時的に無効` と表示される問題が発生することがあります。
Google Drive API の Client ID と Client Secret をセットアップし、skicka に設定することで回避できます。
[こちらの記事](https://qiita.com/satackey/items/34c7fc5bf77bd2f5c633)にしたがって、Client ID と Client Secret をセットアップしてください。

`xxxx-your-google-client-id-xx.googleusercontent.com` と `xxx_yourGoogleClientSecret_xxxx` を置き換え、次のコマンドを入力してコンテナを起動します。

```shell
$ docker run -e GOOGLE_CLIENT_ID=xxxx-your-google-client-id-xx.googleusercontent.com -e GOOGLE_CLIENT_SECRET=xxx_yourGoogleClientSecret_xxxx --rm -it --entrypoint "ash" satackey/skicka
```

コンテナが起動したら次のコマンドを実行します。

```
# sed -i -e "s/;clientid=YOUR_GOOGLE_APP_CLIENT_ID/clientid=$GOOGLE_CLIENT_ID/" ~/.skicka.config && sed -i -e "s/;clientsecret=YOUR_GOOGLE_APP_SECRET/clientsecret=$GOOGLE_CLIENT_SECRET/" ~/.skicka.config && skicka -no-browser-auth ls && cat /root/.skicka.tokencache.json
```

手順2に戻って進めてください。

## Inputs

### `skicka-tokencache-json`

_**必須**_ `skicka`で生成された、アップロードするアカウントの認証情報。
(`~/.skicka.tokencache.json`の内容)

### `upload-from`

_任意_ アップロード元。 デフォルトはカレントディレクトリ。

### `upload-to`

_**必須**_ アップロード先。 

### `google-client-id`

_任意_ skicka を使用する際の Google APIs の OAuth2.0 Client ID。

### `google-client-secret`

_任意_ skicka を使用する際の Google APIs の OAuth2.0 Client Secret。

### `remove-outdated`
任意 ローカルにはないが、Google Drive上には存在するファイルを削除するかどうか。  
`'true'`か`'false'`のどちらかの値  
**注意**: ローカルに存在しないファイルを検出するため、1度ダウンロードを行うので、大きいファイルを含む操作を行う時はオフを推奨。

## 使用例

```yaml
- name: Upload to Google Drive
  uses: satackey/action-google-drive@v1
  with:
    skicka-tokencache-json: ${{ secrets.SKICKA_TOKENCACHE_JSON }}
    upload-from: ./
    upload-to: /path/to/upload
```
