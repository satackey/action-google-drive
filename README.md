# action-google-drive

このアクションは指定されたディレクトリ、ファイルをGoogle Driveへアップロードします。

## 準備

Google Driveへのアップロードには、[`skicka`](https://github.com/google/skicka)を使用しています。
事前にトークンを作成し、Secretsに登録を行う必要があります。

### トークンの作成

#### 既に`skicka`を使っている場合

GitHub リポジトリ -> Settings -> Secrets にて、Name に `SKICKA_TOKENCACHE_JSON` を、Value に `~/.skicka.tokencache.json` の内容を入力して登録します。


#### それ以外
1. Dockerが使用できる環境を用意し、以下のコマンドを実行します。
    ```sh
    docker run --rm -it --entrypoint "" satackey/skicka sh -c "skicka --no-browser-auth ls && cat /root/.skicka.tokencache.json"
    ```
1. ブラウザで表示されたURLにアクセスします。
1. アクセスを許可し、コード表示されたら、ターミナルに戻り貼り付けます。
1. GitHub リポジトリ -> Settings -> Secrets にて、Name に `SKICKA_TOKENCACHE_JSON` を、Value に最後に表示された以下の様なテキストを入力して登録します。

    ```json
    {"ClientId":"xxx-xxxxx.apps.googleusercontent.com","access_token":"xxxx.xx-xxxxxxxxx","token_type":"Bearer","refresh_token":"x//xxxxxxx-xxxxxxx","expiry":"2020-01-03T06:11:01.3298117Z"}
    ````

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
