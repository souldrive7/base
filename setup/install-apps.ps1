# =====================================================================
# PC復元 一括インストールスクリプト（2026-07 承認済み構成）
# 実行方法: PowerShell を「管理者として実行」し、以下を実行
#   Set-ExecutionPolicy -Scope Process Bypass
#   .\install-apps.ps1
# 前提: Windows 11 標準の winget（アプリ インストーラー）が利用可能なこと
# =====================================================================

$ErrorActionPreference = "Continue"

# 初回起動時、msstore ソースの利用規約同意プロンプトが `winget list` 内部で
# 無言のまま待ち受けることがあるため、ここで先に同意を済ませておく
Write-Host "winget のソース利用規約に同意します（初回のみ表示）..." -ForegroundColor DarkGray
winget list --accept-source-agreements | Out-Null

function Install-App {
    param([string]$Id, [string]$Name)
    Write-Host "`n=== $Name ($Id) ===" -ForegroundColor Cyan
    winget list --id $Id -e --accept-source-agreements | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "既にインストール済み。スキップします。" -ForegroundColor Yellow
        return
    }
    winget install --id $Id -e --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$Name のインストール完了" -ForegroundColor Green
    } else {
        Write-Host "$Name のインストールに失敗（コード: $LASTEXITCODE）。手動で確認してください。" -ForegroundColor Red
    }
}

# ---- コア（承認済み構成） ----
Install-App -Id "Git.Git"                      -Name "Git for Windows（Git Credential Manager 同梱）"
Install-App -Id "Microsoft.VisualStudioCode"   -Name "Visual Studio Code"
Install-App -Id "Anaconda.Anaconda3"           -Name "Anaconda"
Install-App -Id "Google.GoogleDrive"           -Name "Google Drive for Desktop"

# ---- オプション（必要になったらコメントを外して再実行） ----
# Install-App -Id "Discord.Discord"            -Name "Discord"
# Install-App -Id "Anthropic.Claude"           -Name "Claude Desktop"

Write-Host "`n=== 完了 ===" -ForegroundColor Cyan
Write-Host "続きは setup/setup-guide.md の手順に沿って、Git 設定・conda 環境構築・各サービスへのログインを行ってください。"
