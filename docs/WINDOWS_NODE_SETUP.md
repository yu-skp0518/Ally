# Windows で Node.js をセットアップする（Ally 開発用）

Rails のアセット（CSS/JS）処理（autoprefixer・terser）は ExecJS 経由で **Node.js (V8)** が必要です。  
Node が入っていない／PATH にないと `Node.js (V8) runtime is not available` が出ます。

## 1. Node.js のインストール

1. **https://nodejs.org/** を開く
2. **LTS** 版の「Windows Installer (.msi)」をダウンロード
3. ダウンロードした `.msi` を実行
4. 画面の指示に従い **Next** で進める
5. **「Automatically install the necessary tools for native modules」** のチェックは **外す**（ここで止まることがあるため）
6. インストール完了まで進め、**Finish**

## 2. PATH の反映

インストール後、**その時開いているターミナルにはまだ Node が反映されません。**

- **PowerShell や Cursor のターミナルを一度すべて閉じる**
- 必要なら **Cursor 自体を再起動**
- あらためてターミナルを開き直す

## 3. 動作確認

新しいターミナルで:

```powershell
node -v
```

`v20.x.x` や `v22.x.x` のようにバージョンが表示されれば OK です。

## 4. まだ `node` が見つからない場合

Node は通常ここにあります:

- `C:\Program Files\nodejs\node.exe`

このフォルダが PATH に無いときは、手動で追加します。

1. **Windows の検索**で「環境変数」→ **「システムの環境変数を編集」**
2. **「環境変数」** を開く
3. **ユーザー環境変数**の **Path** を選び **「編集」**
4. **「新規」** で次のパスを追加（実際に nodejs があるパスに合わせる）:
   - `C:\Program Files\nodejs`
5. **OK** で閉じ、**すべてのターミナルと Cursor を閉じてから開き直す**
6. 再度 `node -v` を実行

## 5. Rails の起動

Node が使える状態で:

```powershell
cd C:\workspace\Ally
bundle exec rails s
```

ブラウザで http://localhost:3000 にアクセスして表示を確認してください。
