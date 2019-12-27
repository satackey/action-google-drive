# action-google-drive

このアクションは指定されたディレクトリ、ファイルをGoogle Driveへアップロードします。

## 準備
Google Driveへのアップロードには、[`skicka`](https://github.com/google/skicka)を使用しています。
事前にトークンを作成し、Secretsに登録を行う必要があります。

### トークンの作成
#### 既に`skicka`を使っている場合
ユーザのホームディレクトリにある、`.skicka.tokencache.json`を、GitHubのリポジトリを開き、Settings → Secrets で、SKICKA_TOKENCACHE_JSONの名前等で、Valueに登録します。


#### それ以外
1. Dockerが使用できる環境を用意し、以下のコマンドを実行します。
    ```sh
    docker run --rm -it --entrypoint '' satackey/skicka sh -c 'skicka --no-browser-auth ls && cat /root/.skicka.tokencache.json'
    ```
1. ブラウザで表示されたURLにアクセスします。
1. アクセスを許可し、コード表示されたら、ターミナルに戻り貼り付けます。
1. 最後の行に表示されたJSONを、GitHubのリポジトリを開き、Settings → Secrets で、SKICKA_TOKENCACHE_JSONの名前等で、Valueに登録します。

## Inputs

### `skicka-tokencache-json`

**必須** `skicka`で生成された、アップロードするアカウントの認証情報。
(`~/.skicka.tokencache.json`の内容)

### `upload-from`

任意 アップロード元。 デフォルトはカレントディレクトリ。

### `upload-to`

**必須** アップロード先。 

### `remove-outdated`
任意 ローカルにはないが、Google Drive上には存在するファイルを削除するかどうか。  
`'true'`か`'false'`のどちらかの値  
**注意**: ローカルに存在しないファイルを検出するため、1度ダウンロードを行うので、大きいファイルを含む操作を行う時はオフを推奨。

## 使用例

```yaml
name: Upload
  uses: satackey/action-google-drive@v1
  with:
    skicka-tokencache-json: ${{ secrets.SKICKA_TOKENCACHE_JSON }}
    upload-from: ./
    upload-to: /path/to/upload
```
