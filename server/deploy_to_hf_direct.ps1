# Direct Upload to Hugging Face Space
# This ensures we push to HF, not GitHub

Write-Host "🚀 Direct Upload to Hugging Face Space" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

$workDir = "D:\HF-Space-Deploy"

# Clean and create work directory
if (Test-Path $workDir) {
    Remove-Item -Recurse -Force $workDir
}
New-Item -ItemType Directory -Path $workDir | Out-Null

Write-Host "📥 Cloning Hugging Face Space..." -ForegroundColor Yellow
cd $workDir
git clone https://huggingface.co/spaces/snk007/presensense

cd presensense

Write-Host ""
Write-Host "📋 Copying files from server directory..." -ForegroundColor Yellow
Write-Host ""

# Copy all Python files and directories
Copy-Item "d:\SHOMBHU\Desktop\presensense\server\Dockerfile" -Destination . -Force
Copy-Item "d:\SHOMBHU\Desktop\presensense\server\README.md" -Destination . -Force -ErrorAction SilentlyContinue
Copy-Item "d:\SHOMBHU\Desktop\presensense\server\requirements.txt" -Destination . -Force
Copy-Item "d:\SHOMBHU\Desktop\presensense\server\main.py" -Destination . -Force
Copy-Item "d:\SHOMBHU\Desktop\presensense\server\config.py" -Destination . -Force
Copy-Item "d:\SHOMBHU\Desktop\presensense\server\db.py" -Destination . -Force
Copy-Item "d:\SHOMBHU\Desktop\presensense\server\startup.py" -Destination . -Force
Copy-Item "d:\SHOMBHU\Desktop\presensense\server\__init__.py" -Destination . -Force

# Copy directories
Copy-Item "d:\SHOMBHU\Desktop\presensense\server\models" -Destination . -Recurse -Force
Copy-Item "d:\SHOMBHU\Desktop\presensense\server\routes" -Destination . -Recurse -Force
Copy-Item "d:\SHOMBHU\Desktop\presensense\server\utils" -Destination . -Recurse -Force

# Create uploads directory
if (-not (Test-Path "uploads")) {
    New-Item -ItemType Directory -Path "uploads" | Out-Null
    New-Item -ItemType File -Path "uploads\.gitkeep" -Force | Out-Null
}

Write-Host "✅ All files copied!" -ForegroundColor Green
Write-Host ""

Write-Host "📋 Current files in Space:" -ForegroundColor Cyan
Get-ChildItem | Select-Object Name | Format-Table -HideTableHeaders

Write-Host ""
Write-Host "📤 Committing changes..." -ForegroundColor Yellow

git add .
git commit -m "Complete deployment with all server files"

Write-Host ""
Write-Host "🚀 Pushing to Hugging Face Space..." -ForegroundColor Yellow
git push

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ SUCCESS! All files uploaded to Hugging Face!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Monitor your Space rebuild:" -ForegroundColor Cyan
    Write-Host "https://huggingface.co/spaces/snk007/presensense" -ForegroundColor White
    Write-Host ""
    Write-Host "Wait 5-10 minutes for build to complete" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "❌ Push failed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "You need to authenticate with Hugging Face" -ForegroundColor Yellow
    Write-Host "1. Create token at: https://huggingface.co/settings/tokens" -ForegroundColor Cyan
    Write-Host "2. Select 'Write' permission" -ForegroundColor Cyan
    Write-Host "3. When prompted for password, use the token" -ForegroundColor Cyan
}
