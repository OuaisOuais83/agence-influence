# Script FINAL : Tout automatique
# Ce script crée le repo GitHub, push le code et déploie sur Vercel

$repoName = "agence-influence"
$username = "OuaisOuais83"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  DEPLOIEMENT FARMER LEAGUE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# ÉTAPE 1: Créer le repo GitHub
Write-Host "`n[ETAPE 1/3] Creation du depot GitHub..." -ForegroundColor Yellow

# Vérifier si le repo existe déjà
try {
    $check = Invoke-WebRequest -Uri "https://api.github.com/repos/$username/$repoName" -Method Get -ErrorAction Stop
    Write-Host "Le repo existe deja!" -ForegroundColor Green
} catch {
    Write-Host "Le repo n'existe pas. Creation..." -ForegroundColor Yellow
    
    # Demander le token
    Write-Host "`nPour creer le repo automatiquement, j'ai besoin d'un token GitHub." -ForegroundColor Yellow
    Write-Host "1. Allez sur: https://github.com/settings/tokens" -ForegroundColor Cyan
    Write-Host "2. Cliquez sur 'Generate new token (classic)'" -ForegroundColor Cyan
    Write-Host "3. Cochez 'repo' dans les scopes" -ForegroundColor Cyan
    Write-Host "4. Copiez le token genere" -ForegroundColor Cyan
    Write-Host "`nOU créez le repo manuellement sur https://github.com/new" -ForegroundColor Yellow
    Write-Host "Nom du repo: $repoName" -ForegroundColor Cyan
    Write-Host "`nEntrez votre token GitHub (ou appuyez sur Entree pour creer manuellement):" -ForegroundColor Yellow
    $token = Read-Host
    
    if ($token) {
        $headers = @{
            "Authorization" = "token $token"
            "Accept" = "application/vnd.github.v3+json"
        }
        $body = @{
            name = $repoName
            description = "Farmer League - Landing page pour agence de performance"
            private = $false
        } | ConvertTo-Json
        
        try {
            $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Headers $headers -Body $body -ContentType "application/json"
            Write-Host "SUCCES! Repo cree: $($response.html_url)" -ForegroundColor Green
        } catch {
            Write-Host "ERREUR lors de la creation du repo: $_" -ForegroundColor Red
            Write-Host "Creez le repo manuellement sur https://github.com/new" -ForegroundColor Yellow
            Read-Host "Appuyez sur Entree une fois le repo cree"
        }
    } else {
        Write-Host "Creez le repo manuellement sur https://github.com/new" -ForegroundColor Yellow
        Write-Host "Nom: $repoName | Public" -ForegroundColor Cyan
        Read-Host "Appuyez sur Entree une fois cree"
    }
}

# ÉTAPE 2: Push le code
Write-Host "`n[ETAPE 2/3] Push du code vers GitHub..." -ForegroundColor Yellow
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "SUCCES! Code pousse sur GitHub!" -ForegroundColor Green
    Write-Host "Repo: https://github.com/$username/$repoName" -ForegroundColor Cyan
} else {
    Write-Host "ERREUR lors du push. Verifiez votre configuration Git." -ForegroundColor Red
    exit 1
}

# ÉTAPE 3: Déployer sur Vercel
Write-Host "`n[ETAPE 3/3] Deploiement sur Vercel..." -ForegroundColor Yellow

# Installer Vercel CLI si nécessaire
if (-not (Get-Command vercel -ErrorAction SilentlyContinue)) {
    Write-Host "Installation de Vercel CLI..." -ForegroundColor Yellow
    npm install -g vercel
}

# Déployer
Write-Host "Deploiement en cours..." -ForegroundColor Yellow
Write-Host "Vous serez invite a vous connecter a Vercel si necessaire." -ForegroundColor Cyan
vercel --prod --yes

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host "  DEPLOIEMENT TERMINE AVEC SUCCES!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "GitHub: https://github.com/$username/$repoName" -ForegroundColor Cyan
    Write-Host "Vercel: Verifiez votre dashboard pour l'URL" -ForegroundColor Cyan
} else {
    Write-Host "`nDeployez manuellement sur https://vercel.com/new" -ForegroundColor Yellow
    Write-Host "Importez le repo: $username/$repoName" -ForegroundColor Cyan
}

