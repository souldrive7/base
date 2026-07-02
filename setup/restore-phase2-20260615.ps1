# =====================================================================
# PC復元 第2段階スクリプト（基準日: 2026-06-15 の状態へ復元）
# install-apps.ps1 実行後に、PowerShell を「管理者として実行」で:
#   Set-ExecutionPolicy -Scope Process Bypass
#   .\restore-phase2-20260615.ps1
#
# 内容: ①各種ドライバ更新（Dell）②既存アプリの最新化
#       ③6/15までに追加されたアプリ ④キーボード操作設定
# 安全方針: BIOS/ファームウェア更新は自動適用から除外（末尾の手動手順参照）
# =====================================================================

$ErrorActionPreference = "Continue"

function Install-App {
    param([string]$Id, [string]$Name)
    Write-Host "`n=== $Name ($Id) ===" -ForegroundColor Cyan
    winget list --id $Id -e | Out-Null
    if ($LASTEXITCODE -eq 0) { Write-Host "既にインストール済み。スキップ。" -ForegroundColor Yellow; return }
    winget install --id $Id -e --accept-package-agreements --accept-source-agreements
}

# ---------------------------------------------------------------
# 1. ドライバ更新（Dell 製PCの場合）
#    Dell Command Update を導入し、BIOS を除くドライバを自動適用
# ---------------------------------------------------------------
Write-Host "`n########## 1. ドライバ更新 ##########" -ForegroundColor Magenta
$manufacturer = (Get-CimInstance Win32_ComputerSystem).Manufacturer
Write-Host "検出されたメーカー: $manufacturer"
if ($manufacturer -match "Dell") {
    Install-App -Id "Dell.CommandUpdate" -Name "Dell Command | Update"
    $dcu = @(
        "$env:ProgramFiles\Dell\CommandUpdate\dcu-cli.exe",
        "${env:ProgramFiles(x86)}\Dell\CommandUpdate\dcu-cli.exe"
    ) | Where-Object { Test-Path $_ } | Select-Object -First 1
    if ($dcu) {
        Write-Host "ドライバをスキャンし、BIOS/ファームウェアを除いて適用します..." -ForegroundColor Cyan
        & $dcu /scan
        & $dcu /applyUpdates -updateType=driver,application -reboot=disable
        Write-Host "完了。BIOS 更新は手動で（本ファイル末尾の手順）実施してください。" -ForegroundColor Yellow
    } else {
        Write-Host "dcu-cli.exe が見つかりません。Dell Command Update をGUIで一度起動してから再実行してください。" -ForegroundColor Red
    }
} else {
    Write-Host "Dell 製ではないため、Windows Update のオプション更新でドライバを取得してください:" -ForegroundColor Yellow
    Write-Host "設定 → Windows Update → 詳細オプション → オプションの更新プログラム → ドライバー更新プログラム"
}
# GPU（NVIDIA 搭載機のみ）: 最新ドライバは GeForce/RTX なら以下を有効化
# Install-App -Id "Nvidia.GeForceExperience" -Name "NVIDIA App"

# ---------------------------------------------------------------
# 2. インストール済みアプリを一括で最新化（6/15時点より新しい安定版に揃える）
# ---------------------------------------------------------------
Write-Host "`n########## 2. アプリ一括アップデート ##########" -ForegroundColor Magenta
winget upgrade --all --accept-package-agreements --accept-source-agreements --include-unknown

# ---------------------------------------------------------------
# 3. 6/15 までに追加されていたアプリ（クラウド記録より）
# ---------------------------------------------------------------
Write-Host "`n########## 3. 追加アプリ ##########" -ForegroundColor Magenta
Install-App -Id "Valve.Steam"     -Name "Steam（2026/6/13 アカウント作成の記録）"
Install-App -Id "Zoom.Zoom"       -Name "Zoom"
Install-App -Id "Discord.Discord" -Name "Discord"
# iPhone/iCloud+ 契約あり。写真連携が必要なら:
# Install-App -Id "Apple.iCloud"  -Name "iCloud for Windows"

# ---------------------------------------------------------------
# 4. キーボード操作設定（安全・可逆な範囲のみ自動適用）
# ---------------------------------------------------------------
Write-Host "`n########## 4. キーボード設定 ##########" -ForegroundColor Magenta
# キーリピートを最速化（既定値: KeyboardDelay=1, KeyboardSpeed=31）
Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Value "0"
Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardSpeed" -Value "31"
Write-Host "キーリピート: 遅延=最短 / 速度=最速 に設定（再サインイン後に反映）" -ForegroundColor Green
Write-Host @"

【手動確認が必要なキーボード/IME設定】（記録が残っていないため既定値からの変更は要確認）
 1. Microsoft IME: 設定 → 時刻と言語 → 言語と地域 → 日本語 → Microsoft IME
    - 「無変換/変換」キーでIMEオフ/オン切り替えを使っていた場合はキー割り当てを変更
 2. CapsLock を Ctrl にしていた場合は PowerToys (winget: Microsoft.PowerToys) の
    Keyboard Manager で再設定
 3. マウスポインター速度・スクロール方向は 設定 → Bluetooth とデバイス → マウス
"@ -ForegroundColor Yellow

# ---------------------------------------------------------------
# 完了メッセージ
# ---------------------------------------------------------------
Write-Host @"

########## 完了 ##########
残りの手動ステップ:
 - BIOS 更新: Dell Command Update を起動し、BIOS のみ個別に適用（電源接続の上で）
 - 再起動して全変更を反映
 - setup-guide.md の Step 8（6/15差分: Steam / Zoom / AI-Stack / Kaggle）のログイン確認
"@ -ForegroundColor Cyan
