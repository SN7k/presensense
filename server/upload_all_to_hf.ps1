# Upload All Files to Hugging Face Space
# This script ensures ALL necessary files are uploaded

Write-Host "🚀 Uploading ALL Files to Hugging Face Space" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

$hfUsername = "snk007"
$spaceName = "presensense"
$tempDir = Join-Path $env:TEMP "hf-space-full-upload"
$serverDir = "d:\SHOMBHU\Desktop\presensense\server"

# Clean up old temp directory
if (Test-Path $tempDir) {
    Write-Host "🧹 Cleaning up old directory..." -ForegroundColor Yellow
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
Write-Host "📋 Copying all server files..." -ForegroundColor Yellow
Write-Host ""

# List of files and directories to copy
$items = @(
    "Dockerfile",
    "README.md",
    "requirements.txt",
    "main.py",
    "config.py",
    "db.py",
    "startup.py",
    "__init__.py",
    "models",
    "routes",
    "utils"
)

foreach ($item in $items) {
    $sourcePath = Join-Path $serverDir $item
    if (Test-Path $sourcePath) {
        Copy-Item -Path $sourcePath -Destination . -Recurse -Force
        Write-Host "  ✅ Copied: $item" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  Not found: $item" -ForegroundColor Yellow
    }
}

# Create uploads directory with .gitkeep
$uploadsDir = "uploads"
if (-not (Test-Path $uploadsDir)) {
    New-Item -ItemType Directory -Path $uploadsDir | Out-Null
    New-Item -ItemType File -Path "$uploadsDir/.gitkeep" -Force | Out-Null
    Write-Host "  ✅ Created: uploads/" -ForegroundColor Green
}

Write-Host ""
Write-Host "📊 Files in Space directory:" -ForegroundColor Cyan
Get-ChildItem -Name

Write-Host ""
Write-Host "📤 Committing and pushing ALL files..." -ForegroundColor Yellow
Write-Host ""

git add .
git status
git commit -m "Upload all server files for complete deployment"
git push

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ UPLOAD COMPLETE!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your Space will rebuild automatically (5-10 minutes)" -ForegroundColor Cyan
    Write-Host "Monitor build at: https://huggingface.co/spaces/$hfUsername/$spaceName" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Check logs for any errors during build" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "❌ Push failed" -ForegroundColor Red
    Write-Host "You may need to authenticate with Hugging Face" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Create a Hugging Face token at:" -ForegroundColor Cyan
    Write-Host "https://huggingface.co/settings/tokens" -ForegroundColor White
}

Write-Host ""
cd ..
