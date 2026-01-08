# Logo Farmer League

Placez votre logo Farmer League dans ce dossier avec le nom `logo.png`

## Fichiers requis

### logo.png (obligatoire)
- Format PNG (avec fond transparent de préférence)
- Dimensions recommandées : 200x80px (ratio 2.5:1)
- Le logo sera automatiquement redimensionné tout en préservant ses proportions

### logo@2x.png (optionnel, recommandé)
- Version haute résolution pour les écrans Retina
- Dimensions : 400x160px (2x la taille de logo.png)
- Améliore la qualité d'affichage sur les écrans haute densité
- Si ce fichier n'existe pas, le navigateur utilisera automatiquement `logo.png`

## Utilisation

Les fichiers seront accessibles via :
- `/logo.png` - Version standard
- `/logo@2x.png` - Version Retina (si disponible)

Le code utilise automatiquement `srcset` pour charger la version appropriée selon la densité de pixels de l'écran.

## Fallback

Si le PNG ne charge pas, le système basculera automatiquement vers `logo.svg` comme solution de secours.

