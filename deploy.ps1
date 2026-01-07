# Script complet de déploiement : GitHub + Vercel
Write-Host "=== Déploiement Agence Influence ===" -ForegroundColor Cyan

$repoName = "agence-influence"
$username = "OuaisOuais83"

# Étape 1: Créer le repo GitHub
Write-Host "`n[1/3] Création du dépôt GitHub..." -ForegroundColor Yellow

# Vérifier si le repo existe déjà
$repoExists = $false
try {
    $response = Invoke-WebRequest -Uri "https://api.github.com/repos/$username/$repoName" -Method Get -ErrorAction SilentlyContinue
    if ($response.StatusCode -eq 200) {
        $repoExists = $true
        Write-Host "Repo existe déjà!" -ForegroundColor Green
    }
} catch {
    $repoExists = $false
}

if (-not $repoExists) {
    Write-Host "Création du repo via GitHub..." -ForegroundColor Yellow
    
    # Essayer avec GitHub CLI
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        Write-Host "Utilisation de GitHub CLI..." -ForegroundColor Yellow
        gh repo create $repoName --public --description "Agence Influence - Landing page pour agence de performance créateurs digitaux" --source=. --remote=origin --push
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Repo créé et code poussé!" -ForegroundColor Green
        } else {
            Write-Host "Erreur avec GitHub CLI. Créez le repo manuellement sur: https://github.com/new" -ForegroundColor Red
            Write-Host "Nom du repo: $repoName" -ForegroundColor Yellow
            Write-Host "Puis exécutez: git push -u origin main" -ForegroundColor Yellow
            exit 1
        }
    } else {
        Write-Host "GitHub CLI non installé. Créez le repo manuellement:" -ForegroundColor Yellow
        Write-Host "1. Allez sur: https://github.com/new" -ForegroundColor Cyan
        Write-Host "2. Nom du repo: $repoName" -ForegroundColor Cyan
        Write-Host "3. Cochez 'Public'" -ForegroundColor Cyan
        Write-Host "4. Ne cochez PAS 'Initialize with README'" -ForegroundColor Cyan
        Write-Host "5. Cliquez sur 'Create repository'" -ForegroundColor Cyan
        Write-Host "`nAppuyez sur Entrée une fois le repo créé..." -ForegroundColor Yellow
        Read-Host
        
        # Push le code
        Write-Host "Push du code..." -ForegroundColor Yellow
        git push -u origin main
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Erreur lors du push. Vérifiez votre configuration Git." -ForegroundColor Red
            exit 1
        }
    }
} else {
    Write-Host "Push du code vers le repo existant..." -ForegroundColor Yellow
    git push -u origin main
}

# Étape 2: Déployer sur Vercel
Write-Host "`n[2/3] Déploiement sur Vercel..." -ForegroundColor Yellow

# Vérifier si Vercel CLI est installé
if (Get-Command vercel -ErrorAction SilentlyContinue) {
    Write-Host "Vercel CLI détecté!" -ForegroundColor Green
    Write-Host "Déploiement en cours..." -ForegroundColor Yellow
    
    # Déployer
    vercel --prod --yes
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Déployé sur Vercel avec succès!" -ForegroundColor Green
    } else {
        Write-Host "Erreur lors du déploiement Vercel. Déployez manuellement:" -ForegroundColor Red
        Write-Host "1. Allez sur: https://vercel.com/new" -ForegroundColor Cyan
        Write-Host "2. Importez le repo: $username/$repoName" -ForegroundColor Cyan
        Write-Host "3. Vercel détectera automatiquement Vite" -ForegroundColor Cyan
    }
} else {
    Write-Host "Vercel CLI non installé. Installation..." -ForegroundColor Yellow
    npm install -g vercel
    
    if (Get-Command vercel -ErrorAction SilentlyContinue) {
        Write-Host "Vercel CLI installé! Déploiement..." -ForegroundColor Green
        vercel --prod --yes
    } else {
        Write-Host "Impossible d'installer Vercel CLI. Déployez manuellement:" -ForegroundColor Red
        Write-Host "1. Allez sur: https://vercel.com/new" -ForegroundColor Cyan
        Write-Host "2. Importez le repo: $username/$repoName" -ForegroundColor Cyan
        Write-Host "3. Vercel détectera automatiquement Vite" -ForegroundColor Cyan
    }
}

Write-Host "`n[3/3] Terminé!" -ForegroundColor Green
Write-Host "Repo GitHub: https://github.com/$username/$repoName" -ForegroundColor Cyan
Write-Host "Vérifiez votre dashboard Vercel pour l'URL de déploiement" -ForegroundColor Cyan

