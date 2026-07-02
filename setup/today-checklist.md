# 本日の復旧チェックリスト（スマホだけで完了・所要 約30分）

外出先からスマホのブラウザだけで進められる作業。上から順に。

## 1. Google アカウントの安全確認（5分・最優先）

1. スマホで https://myaccount.google.com/security-checkup を開く
2. 「お使いのデバイス」→ 旧PC（初期化前のWindows）が残っていたら「ログアウト」
3. 「最近のセキュリティ関連のアクティビティ」に心当たりのないものがないか確認
4. 再設定用の電話番号・メールアドレスが現在のものか確認

## 2. Anthropic API キーの再発行（5分）

6/8・6/9・6/12 に Pro 月額とは別の課金記録あり（API / Claude Code 利用の可能性大）。
旧PCのキーは復元できないため：

1. https://console.anthropic.com にログイン（souldrive7@gmail.com）
2. Settings → API Keys を開き、旧PCで使っていたキーが残っていれば **Disable/Delete**（漏洩予防）
3. 新しいキーを発行 → **その場でパスワードマネージャに保存**（画面を閉じると再表示不可）
4. Billing → 使用履歴に心当たりのない利用がないか確認

## 3. AI-Stack（大学GPU基盤）の確認（5分）

- 6/15 時点で NV_H100（project1781516385212）/ NV_Pro6000 プロジェクトが稼働
- 通知メールは返信不可のため、**今井先生宛の確認メール下書きを Gmail に作成済み**
  → スマホの Gmail アプリ →「下書き」→ 件名「【M2後藤】PC初期化に伴う研究環境の再設定について」を開き、内容を確認して送信
- 大学ポータル（SUCCESS / Sulms）にスマホからログインできるかも併せて確認

## 4. 各サービスのログイン確認（10分）

パスワードが分かるか（＝帰宅後PCですぐログインできるか）をスマホで確認：

- [ ] Kaggle — 5/16 にパスワードリセット済み。分からなければ再度リセットしてよい
- [ ] Steam — 6/13 作成。メール認証（Steamガード）が souldrive7@gmail.com に届く
- [ ] Zoom
- [ ] 大学 SUCCESS / Sulms / Mattermost
- [ ] X・bitFlyer・SBI VC 等の金融系は「1.」のGoogle確認後、必要時のみ

## 5. （家に人がいる場合のみ）遠隔操作の初回設定を依頼

`setup/remote-access.md` のパターンAを電話で読み上げ →
完了後はスマホの Chrome Remote Desktop アプリから PC を操作可能。
以後の PC 作業（スクリプト実行）は遠隔で進められます。

## 帰宅後の最初の1コマンド（参考）

管理者 PowerShell で：

```powershell
Set-ExecutionPolicy -Scope Process Bypass
irm https://raw.githubusercontent.com/souldrive7/base/claude/pc-setup-restoration-0xzyxs/setup/install-apps.ps1 -OutFile install-apps.ps1; .\install-apps.ps1
```
