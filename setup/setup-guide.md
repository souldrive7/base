# PC復元 セットアップ手順書（承認済み構成）

`docs/PC復元計画_2026-05基準.md` の実行版。2026-07 に以下の構成で承認済み：

| 項目 | 決定内容 |
|---|---|
| Python 環境 | **Anaconda**（従来通り） |
| GitHub 認証 | **Git Credential Manager**（HTTPS） |
| エディタ | **VS Code** |
| セキュリティ | BitLocker 有効化＋回復キー保管 / Windows Insider 不参加 / Edge プロファイル同期 / Google Drive for Desktop のフォトバックアップ設定確認 |

上から順に進め、各ステップ完了時に末尾のセットアップ記録に日付を書き込むこと。

---

## Step 1: アカウント・権限の復旧（ブラウザだけでできる）

1. **Google**（souldrive7@gmail.com）にログイン
   - [myaccount.google.com/security](https://myaccount.google.com/security) で新PCを2段階認証の端末として登録し、回復用電話・メールを最新化
   - 「セキュリティ診断」を実行し、旧PCのセッションを削除
2. **Microsoft アカウント**にログイン（Windows サインインと OneDrive 用）
3. **大学アカウント**（s6025131@st.shiga-u.ac.jp）— Web メール、Sulms、Mattermost にログインできることを確認
4. **Edge** を起動しプロファイル同期を ON → お気に入り・保存パスワードが戻ることを確認
5. 各サービスから「新しい端末からのログイン」通知が届くが、この作業によるものかを都度確認する

## Step 2: セキュリティ設定（承認済み）

1. **Windows Update** をすべて適用（再起動を繰り返し、更新が無くなるまで）
2. **BitLocker** を有効化：設定 → プライバシーとセキュリティ → デバイスの暗号化
   - 回復キーは Microsoft アカウントに保存＋**Google Drive 以外の別媒体（印刷やUSB）にも控える**
3. **Windows Insider Program には参加しない**（設定 → Windows Update → Windows Insider Program が無効のままであることを確認）
4. Microsoft Defender が有効であることを確認

## Step 3: アプリの一括インストール

PowerShell を**管理者として実行**し：

```powershell
cd <このリポジトリを置く前の任意の場所>
# このファイルと install-apps.ps1 をダウンロードしている場合はそのフォルダで
Set-ExecutionPolicy -Scope Process Bypass
.\install-apps.ps1
```

インストールされるもの: Git for Windows / VS Code / Anaconda / Google Drive for Desktop
（Discord・Claude Desktop はスクリプト内のコメントを外せば追加可能）

## Step 4: Git と GitHub（Git Credential Manager）

新しいターミナル（Git Bash または PowerShell）で：

```bash
git config --global user.name  "souldrive7"
git config --global user.email "souldrive7@gmail.com"
git config --global init.defaultBranch main
```

リポジトリの clone（初回に GCM のブラウザ認証が起動するので GitHub にログイン）：

```bash
cd %USERPROFILE%\source   # 任意の作業フォルダ
git clone https://github.com/souldrive7/base.git
```

## Step 5: Python（Anaconda）環境の再構築

Anaconda Prompt で：

```bash
conda create -n base-ml python=3.11 -y
conda activate base-ml
cd base リポジトリのフォルダ
pip install -r requirements.txt
python -c "import lightgbm, xgboost, catboost; print('OK')"
```

- VS Code に **Python** と **Jupyter** の拡張機能をインストールし、インタープリターに `base-ml` を選択
- `code-analysis/run_lgb.ipynb` が開けることを確認（実行には Step 7 のデータが必要）

## Step 6: AI ツール・その他サービスのログイン

| サービス | アカウント | メモ |
|---|---|---|
| Claude Pro | souldrive7@gmail.com | 契約継続中。[claude.ai](https://claude.ai) にログインのみ |
| ChatGPT | s6025131@st.shiga-u.ac.jp | 大学メールでログイン |
| Kaggle | ― | 5/16 リセット後のパスワードでログイン。API利用時は Account → Create New Token で `kaggle.json` を再発行し `%USERPROFILE%\.kaggle\` に配置 |
| X ほか | ― | 必要時に随時 |

## Step 7: データ・研究環境の復元

1. **Google Drive for Desktop** にログインし、同期フォルダを設定
   - 設定画面で**フォトバックアップの挙動を確認**（2026年5月に仕様変更の案内あり）
2. `input/` のデータセット（train.csv / test.csv 等）を取得元（Kaggle 等）から再ダウンロード
3. **DS学系共有サーバ** — Drive の「学生向けDS学系共有サーバ情報.pdf」の接続情報で再設定
4. **ビジネスデータ利用環境** — 4月末時点で構築途中だったため、接続先・手順を今井先生に再確認
5. ⚠️ **旧ディスクが手元にあれば、初期化前に必ず中身を確認**（Drive の「PCバックアップ_2026-06-30」フォルダは空だったため）

---

## Step 8: 6月15日基準への差分復元（クラウド記録より）

`restore-phase2-20260615.ps1` を管理者PowerShellで実行（ドライバ更新・アプリ最新化・Steam/Zoom/Discord・キーボード設定）。その後、以下を確認：

| 項目 | 記録 | 復元アクション |
|---|---|---|
| 大学 AI-Stack（GPU基盤） | 6/15 に NV_H100 / NV_Pro6000 プロジェクト稼働（通知: takayana@ism.ac.jp） | ポータルへのログインと接続手順を確認。SSH鍵を使っていた場合は再発行・再登録が必要 |
| Kaggle: NVIDIA Nemotron コンペ | 6/15 締切で参加 | 成果物・ノートブックは Kaggle クラウド側に残存。ローカルに要るものだけダウンロード |
| Anthropic 追加課金 | 6/8・6/9・6/12 に領収書（Pro月額とは別） | API キー/Claude Code を使っていた場合、キーは復元不可のため console.anthropic.com で再発行 |
| Steam | 6/13 アカウント新規作成 | Steam ログイン（メール認証） |
| Zoom | 利用形跡 | ログインのみ |
| iCloud+ 200GB | 契約中（iPhone） | 写真連携が必要なら iCloud for Windows を追加 |
| BIOS 更新 | ― | Dell Command Update から手動で個別適用（自動適用からは除外済み） |

## セットアップ記録（完了したら日付を記入）

| ステップ | 完了日 | メモ |
|---|---|---|
| Step 1 アカウント復旧 | | |
| Step 2 セキュリティ設定 | | BitLocker 回復キー保管場所: |
| Step 3 アプリ一括インストール | | |
| Step 4 Git / GitHub | | |
| Step 5 Anaconda 環境 | | conda env 名: base-ml |
| Step 6 各サービスログイン | | |
| Step 7 データ・研究環境 | | |
| 旧ディスク確認 | | |
