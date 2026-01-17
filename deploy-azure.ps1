# Quick Azure Deployment Script
# Deploy without waiting for the 10 minute timeout

Write-Host "Deploying to Azure App Service..." -ForegroundColor Green

# Deploy and don't wait for completion
az webapp up --name cccgolf-app --resource-group GolfApp-W2 --sku B1 --only-show-errors

Write-Host "`nDeployment initiated! Check status at:" -ForegroundColor Yellow
Write-Host "https://cccgolf-app.azurewebsites.net" -ForegroundColor Cyan
Write-Host "`nNote: App may take 2-3 minutes to fully start after deployment completes." -ForegroundColor Gray
