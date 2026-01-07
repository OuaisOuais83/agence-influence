# Script complet : Création repo GitHub + Push + Déploiement Vercel
Write-Host "=== Configuration complète Agence Influence ===" -ForegroundColor Cyan

$repoName = "agence-influence"
$username = "OuaisOuais83"

# Étape 1: Créer le repo GitHub via API
Write-Host "`n[1/4] Création du dépôt GitHub via API..." -ForegroundColor Yellow

# Demander le token GitHub
Write-Host "Pour créer le repo automatiquement, j'ai besoin d'un Personal Access Token GitHub." -ForegroundColor Yellow
Write-Host "Créez-en un sur: https://github.com/settings/tokens (scope: repo)" -ForegroundColor Cyan
$token = Read-Host "Entrez votre token GitHub (ou appuyez sur Entrée pour créer le repo manuellement)"

if ($token) {
    $headers = @{
        "Authorization" = "token $token"
        "Accept" = "application/vnd.github.v3+json"
    }

    $body = @{
        name = $repoName
        description = "Agence Influence - Landing page pour agence de performance créateurs digitaux"
        private = $false
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Headers $headers -Body $body -ContentType "application/json"
        Write-Host "Repo cree: $($response.html_url)" -ForegroundColor Green
    } catch {
        Write-Host "Erreur: $_" -ForegroundColor Red
        Write-Host "Créez le repo manuellement sur: https://github.com/new" -ForegroundColor Yellow
        Write-Host "Nom: $repoName" -ForegroundColor Yellow
        Read-Host "Appuyez sur Entrée une fois créé"
    }
} else {
    Write-Host "Créez le repo manuellement:" -ForegroundColor Yellow
    Write-Host "1. https://github.com/new" -ForegroundColor Cyan
    Write-Host "2. Nom: $repoName" -ForegroundColor Cyan
    Write-Host "3. Public" -ForegroundColor Cyan
    Read-Host "Appuyez sur Entrée une fois créé"
}

# Étape 2: Push le code
Write-Host "`n[2/4] Push du code vers GitHub..." -ForegroundColor Yellow
git push -u origin main
if ($LASTEXITCODE -eq 0) {
    Write-Host "Code pousse avec succes!" -ForegroundColor Green
} else {
    Write-Host "Erreur lors du push" -ForegroundColor Red
    exit 1
}

# Étape 3: Installer Vercel CLI si nécessaire
Write-Host "`n[3/4] Vérification de Vercel CLI..." -ForegroundColor Yellow
if (-not (Get-Command vercel -ErrorAction SilentlyContinue)) {
    Write-Host "Installation de Vercel CLI..." -ForegroundColor Yellow
    npm install -g vercel
}

# Étape 4: Déployer sur Vercel
Write-Host "`n[4/4] Déploiement sur Vercel..." -ForegroundColor Yellow
Write-Host "Vous allez être invité à vous connecter à Vercel..." -ForegroundColor Cyan
vercel --prod --yes

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nDeploiement termine avec succes!" -ForegroundColor Green
    Write-Host "Repo GitHub: https://github.com/$username/$repoName" -ForegroundColor Cyan
    Write-Host "Verifiez votre dashboard Vercel pour l'URL" -ForegroundColor Cyan
} else {
    Write-Host "`nDéployez manuellement sur: https://vercel.com/new" -ForegroundColor Yellow
    Write-Host "Importez le repo: $username/$repoName" -ForegroundColor Cyan
}

