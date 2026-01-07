# Script automatique : GitHub + Vercel
$repoName = "agence-influence"
$username = "OuaisOuais83"

Write-Host "=== Deploiement Agence Influence ===" -ForegroundColor Cyan

# 1. Creer le repo GitHub
Write-Host "`n[1/3] Creation du depot GitHub..." -ForegroundColor Yellow
Write-Host "Pour creer le repo automatiquement, entrez votre token GitHub" -ForegroundColor Yellow
Write-Host "Ou appuyez sur Entree pour creer manuellement sur https://github.com/new" -ForegroundColor Cyan
$token = Read-Host "Token GitHub (optionnel)"

if ($token) {
    $headers = @{
        "Authorization" = "token $token"
        "Accept" = "application/vnd.github.v3+json"
    }
    $body = @{
        name = $repoName
        description = "Agence Influence - Landing page"
        private = $false
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Headers $headers -Body $body -ContentType "application/json"
        Write-Host "Repo cree: $($response.html_url)" -ForegroundColor Green
    } catch {
        Write-Host "Erreur. Creez le repo manuellement sur https://github.com/new" -ForegroundColor Red
        Read-Host "Appuyez sur Entree une fois cree"
    }
} else {
    Write-Host "Creez le repo sur https://github.com/new (nom: $repoName)" -ForegroundColor Yellow
    Read-Host "Appuyez sur Entree une fois cree"
}

# 2. Push
Write-Host "`n[2/3] Push du code..." -ForegroundColor Yellow
git push -u origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host "Erreur push. Verifiez votre config Git." -ForegroundColor Red
    exit 1
}
Write-Host "Code pousse avec succes!" -ForegroundColor Green

# 3. Deploy Vercel
Write-Host "`n[3/3] Deploiement Vercel..." -ForegroundColor Yellow
if (-not (Get-Command vercel -ErrorAction SilentlyContinue)) {
    Write-Host "Installation Vercel CLI..." -ForegroundColor Yellow
    npm install -g vercel
}
vercel --prod --yes

Write-Host "`nTermine! Repo: https://github.com/$username/$repoName" -ForegroundColor Green

