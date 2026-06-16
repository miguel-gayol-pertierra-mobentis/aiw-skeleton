Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  AppInWhats - Compile dist folders" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  frontend/dist/AiW/   -> upload to Plesk" -ForegroundColor Gray
Write-Host "  backend/dist/        -> commit + push" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# --- Frontend ---
Write-Host "Step 1/2 - Compiling frontend (ng build)..." -ForegroundColor Yellow
Write-Host ""

docker build --target builder -f ./containers/Dockerfile.frontend -t aiw-frontend-builder-tmp .

if ($LASTEXITCODE -ne 0) {
    Write-Host "Frontend build failed. Aborting." -ForegroundColor Red
    exit 1
}

$containerId = docker create aiw-frontend-builder-tmp
docker cp "${containerId}:/app/dist" ./frontend/
docker rm $containerId | Out-Null
docker rmi aiw-frontend-builder-tmp | Out-Null

Write-Host ""
Write-Host "frontend/dist/AiW/ generated." -ForegroundColor Green

# --- Backend ---
Write-Host ""
Write-Host "Step 2/2 - Compiling backend (tsc)..." -ForegroundColor Yellow
Write-Host ""

docker build --target builder -f ./containers/Dockerfile.backend -t aiw-backend-builder-tmp .

if ($LASTEXITCODE -ne 0) {
    Write-Host "Backend build failed. Aborting." -ForegroundColor Red
    exit 1
}

$containerId = docker create aiw-backend-builder-tmp
docker cp "${containerId}:/app/dist" ./backend/
docker rm $containerId | Out-Null
docker rmi aiw-backend-builder-tmp | Out-Null

Write-Host ""
Write-Host "backend/dist/ generated." -ForegroundColor Green
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Done." -ForegroundColor Green
Write-Host "  1. Upload frontend/dist/AiW/* to Plesk" -ForegroundColor Green
Write-Host "  2. git add backend/dist/ && commit && push" -ForegroundColor Green
Write-Host "  3. SSH to server: git pull + docker redeploy" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
