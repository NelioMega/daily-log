# Installation

## Déjà fait ✅

- Dépôt créé et poussé : https://github.com/NelioMega/daily-log (public, branche `main`)
- E-mail d'auteur `nelioprodhomme@gmail.com` vérifié comme rattaché au compte `NelioMega`
- Workflow planifié tous les jours à 09h23 UTC, opérationnel sans aucun jeton

Le graphe se remplit déjà. Ce qui suit est **optionnel**.

## Optionnel : le PAT (pour que ça dure au-delà de 60 jours)

GitHub désactive les workflows planifiés d'un dépôt resté **60 jours sans activité
humaine**. Les pushs faits par le jeton intégré (`GITHUB_TOKEN`) ne comptent pas
comme activité humaine — ceux faits avec un PAT personnel, si. Sans PAT, il faudra
donc réactiver le workflow à la main environ tous les deux mois (GitHub envoie un
e-mail d'avertissement avant).

À faire toi-même sur https://github.com/settings/personal-access-tokens :

- **Fine-grained token**, expiration la plus longue possible
- *Repository access* → **Only select repositories** → `daily-log`
- *Permissions → Repository permissions → Contents* → **Read and write**

Puis colle le jeton quand cette commande le demande :

```
gh secret set DAILY_PAT --repo NelioMega/daily-log
```

Aucune autre modification n'est nécessaire : le workflow détecte le secret et
l'utilise automatiquement s'il existe.

## Ce qui fait qu'un commit compte comme contribution

Trois conditions, toutes remplies ici :

1. L'e-mail de l'auteur du commit est rattaché **et vérifié** sur le compte GitHub.
2. Le commit est sur la **branche par défaut** du dépôt (`main`).
3. Le dépôt appartient au compte et n'est pas un fork.

L'identité de celui qui *pousse* n'entre pas en jeu. Pour vérifier à tout moment
que le lien commit → compte est bien établi :

```
gh api repos/NelioMega/daily-log/commits --jq '.[0] | "\(.commit.author.email) -> \(.author.login // "AUCUN LIEN")"'
```

## Réglages

```
gh variable set MAX_COMMITS --repo NelioMega/daily-log --body 4
```

| Variable | Défaut | Rôle |
|---|---|---|
| `MIN_COMMITS` | `1` | Nombre minimum de commits par jour |
| `MAX_COMMITS` | `3` | Nombre maximum de commits par jour |
| `GIT_USER_NAME` | `Nélio Prodhomme` | Nom de l'auteur |
| `GIT_USER_EMAIL` | `nelioprodhomme@gmail.com` | E-mail de l'auteur (doit rester vérifié) |

L'heure se change dans le `cron` de `.github/workflows/daily.yml`, en **UTC**
(09h23 UTC = 11h23 à Montpellier en été, 10h23 en hiver).

## Commandes utiles

Lancer une exécution immédiate :

```
gh workflow run "Contribution quotidienne" --repo NelioMega/daily-log -f commits=1
```

Voir les dernières exécutions :

```
gh run list --repo NelioMega/daily-log --limit 5
```

Consulter le journal d'une exécution qui a échoué :

```
gh run view --repo NelioMega/daily-log --log-failed
```

## Dépannage

| Symptôme | Cause quasi certaine |
|---|---|
| Run vert mais carré gris | e-mail retiré ou dé-vérifié dans *Settings → Emails* |
| Plus aucun run depuis ~2 mois | règle des 60 jours → réactiver le workflow dans l'onglet Actions, ou poser le PAT |
| `remote: Permission denied` | PAT expiré, ou permission *Contents* laissée en lecture seule |
| Le run part avec 20 min de retard | normal, le cron GitHub se décale quand la charge est haute |
