# 外出先からPCを遠隔操作するためのセットアップ

前提: PCはデスクトップまで起動済み。ただしリセット直後のため、遠隔操作を受け付ける
ソフトは未導入。**初回のみPCの前での操作（約5分）が必要**（これはどの遠隔操作サービスでも同じです）。

## パターンA: 今、自宅に操作を頼める人がいる場合（最短）

PCの前の人に以下を伝える（そのまま読み上げでOK。スマホから操作する前提で
Chrome リモート デスクトップを使います）:

1. PCで Edge または Chrome を開き、 https://remotedesktop.google.com/access へアクセス
2. Google アカウント（souldrive7@gmail.com）でログイン
   ※2段階認証のコードは外出中のあなたのスマホに届くので、電話等で伝える
3. 「リモート アクセスの設定」→「インストール」→ 画面の指示に従い、
   PC名と6桁以上のPINを設定（PINはあなたが決めて口頭で共有し、後で変更）
4. 完了後、あなたのスマホの「Chrome Remote Desktop」アプリ（iOS/Android）に
   同じGoogleアカウントでログイン → PC名をタップ → PIN入力で操作開始

## パターンB: 誰もいない場合（今日できること／帰宅後にやること）

### 今日、スマホだけでできること（PC不要）
- Google アカウントのセキュリティ確認（旧PCセッション削除・回復手段更新）
- Kaggle / Anthropic Console / Steam / Zoom / 大学SUCCESS・Sulms のログイン確認とパスワード整理
- Anthropic API キーの再発行（console.anthropic.com — 旧キーは復元不可）
- AI-Stack（大学GPU基盤）のポータルにログインできるか確認
- 旧ディスクの件・研究環境の接続手順を今井先生／管理者にメールで確認

### 帰宅後 最初の5分（1回だけ）
1. Chrome を開き https://remotedesktop.google.com/access → Googleログイン
2. 「リモート アクセスの設定」→ インストール → PIN設定
3. 電源設定: 設定 → システム → 電源 → 「スリープ」を[なし]（遠隔操作はスリープ中不可）
4. 以後は外出先のスマホ・別PCから常時アクセス可能。
   `setup/install-apps.ps1` → `setup/restore-phase2-20260615.ps1` も遠隔で実行できる

## 遠隔操作が使えるようになったら

管理者PowerShellで（コピー&ペースト1行ずつ）:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
irm https://raw.githubusercontent.com/souldrive7/base/claude/pc-setup-restoration-0xzyxs/setup/install-apps.ps1 -OutFile install-apps.ps1; .\install-apps.ps1
irm https://raw.githubusercontent.com/souldrive7/base/claude/pc-setup-restoration-0xzyxs/setup/restore-phase2-20260615.ps1 -OutFile restore-phase2.ps1; .\restore-phase2.ps1
```

※ セキュリティ注: PIN・パスワードは手順書やチャットに書き残さないこと。
