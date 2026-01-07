# Script pour créer le repo GitHub et push le code
$repoName = "agence-influence"
$username = "OuaisOuais83"
$description = "Agence Influence - Landing page pour agence de performance créateurs digitaux"

Write-Host "Création du dépôt GitHub: $repoName" -ForegroundColor Green

# Vérifier si GitHub CLI est installé
if (Get-Command gh -ErrorAction SilentlyContinue) {
    Write-Host "GitHub CLI détecté, création du repo..." -ForegroundColor Yellow
    gh repo create $repoName --public --description $description --source=. --remote=origin --push
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Repo créé et code poussé avec succès!" -ForegroundColor Green
        exit 0
    }
}

# Sinon, utiliser l'API GitHub
Write-Host "GitHub CLI non disponible, utilisation de l'API GitHub..." -ForegroundColor Yellow

# Demander le token GitHub
$token = Read-Host "Entrez votre token GitHub (Personal Access Token avec repo scope)"

if (-not $token) {
    Write-Host "Token requis. Créez-en un sur: https://github.com/settings/tokens" -ForegroundColor Red
    Write-Host "Ou créez le repo manuellement sur GitHub et exécutez: git push -u origin master" -ForegroundColor Yellow
    exit 1
}

# Créer le repo via l'API
$headers = @{
    "Authorization" = "token $token"
    "Accept" = "application/vnd.github.v3+json"
}

$body = @{
    name = $repoName
    description = $description
    private = $false
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Headers $headers -Body $body -ContentType "application/json"
    Write-Host "Repo créé avec succès: $($response.html_url)" -ForegroundColor Green
    
    # Push le code
    Write-Host "Push du code..." -ForegroundColor Yellow
    git push -u origin master
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Code poussé avec succès!" -ForegroundColor Green
    }
} catch {
    Write-Host "Erreur lors de la création du repo: $_" -ForegroundColor Red
    Write-Host "Créez le repo manuellement sur GitHub et exécutez: git push -u origin master" -ForegroundColor Yellow
}

