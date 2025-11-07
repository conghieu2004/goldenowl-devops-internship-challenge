# Script để deploy infrastructure với SSL step by step

Write-Host "🚀 Deploying Infrastructure with SSL/Route53..." -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Yellow

# Step 1: Initialize và validate
Write-Host "`n📋 Step 1: Initialize Terraform..." -ForegroundColor Cyan
terraform init -upgrade

Write-Host "`n🔍 Step 2: Validate configuration..." -ForegroundColor Cyan  
terraform validate

Write-Host "`n📊 Step 3: Plan infrastructure..." -ForegroundColor Cyan
terraform plan -out=tfplan

Write-Host "`n🏗️  Step 4: Apply infrastructure..." -ForegroundColor Cyan
terraform apply tfplan

Write-Host "`n🎯 Step 5: Check outputs..." -ForegroundColor Cyan
terraform output

Write-Host "`n✅ Deployment Complete!" -ForegroundColor Green
Write-Host "`n📝 Next steps:" -ForegroundColor Yellow
Write-Host "1. Update nameservers in your domain registrar:" -ForegroundColor White
terraform output nameservers
Write-Host "`n2. Wait 15-30 minutes for DNS propagation" -ForegroundColor White
Write-Host "`n3. Test your application:" -ForegroundColor White
$DOMAIN = terraform output -raw domain_name 2>$null
if ($DOMAIN) {
    Write-Host "   HTTP:  http://$DOMAIN" -ForegroundColor Cyan
    Write-Host "   HTTPS: https://$DOMAIN" -ForegroundColor Green
} else {
    $ALB_DNS = terraform output -raw alb_dns_name
    Write-Host "   ALB:   http://$ALB_DNS" -ForegroundColor Cyan
}

Write-Host "`n🔍 Verification commands:" -ForegroundColor Yellow
Write-Host "# Check certificate status:"
Write-Host "aws acm list-certificates --region us-east-1" -ForegroundColor Gray
Write-Host "`n# Test DNS resolution:"
if ($DOMAIN) {
    Write-Host "nslookup $DOMAIN" -ForegroundColor Gray
    Write-Host "dig $DOMAIN" -ForegroundColor Gray
}
Write-Host "`n# Test SSL:"
if ($DOMAIN) {
    Write-Host "curl -I https://$DOMAIN" -ForegroundColor Gray
}