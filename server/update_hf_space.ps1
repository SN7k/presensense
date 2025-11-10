# Quick Update Script for Hugging Face Space
# This script helps you update your Space with local changes

Write-Host "🚀 Updating Hugging Face Space" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

$hfUsername = "snk007"
$spaceName = "presensense"
$tempDir = Join-Path $env:TEMP "hf-space-update"

# Clean up old temp directory
if (Test-Path $tempDir) {
    Remove-Item -Recurse -Force $tempDir
}

Write-Host "📥 Cloning Space repository..." -ForegroundColor Yellow
git clone https://huggingface.co/spaces/$hfUsername/$spaceName $tempDir

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to clone Space" -ForegroundColor Red
    exit 1
}

cd $tempDir

Write-Host ""
Write-Host "📋 Copying updated main.py..." -ForegroundColor Yellow

# Copy updated main.py from server directory
$sourcePath = "d:\SHOMBHU\Desktop\presensense\server\main.py"
if (Test-Path $sourcePath) {
    Copy-Item -Path $sourcePath -Destination "main.py" -Force
    Write-Host "✅ main.py updated" -ForegroundColor Green
} else {
    Write-Host "❌ Source file not found: $sourcePath" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "📤 Committing and pushing changes..." -ForegroundColor Yellow

git add main.py
git commit -m "Fix: Improve error handling in camera capture upload"
git push

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Update complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your Space will rebuild automatically (2-3 minutes)" -ForegroundColor Cyan
    Write-Host "Monitor at: https://huggingface.co/spaces/$hfUsername/$spaceName" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "❌ Push failed" -ForegroundColor Red
    Write-Host "You may need to authenticate with Hugging Face" -ForegroundColor Yellow
}
