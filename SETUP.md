# Installation (5 minutes, une seule fois)

## 1. Créer le dépôt et le pousser

```
gh repo create daily-log --public --source=. --remote=origin --push
```

> Dépôt **public** de préférence. En privé, il faut activer
> *Settings → Public profile → Contributions → Include private contributions on my profile*,
> sinon le graphe reste gris.

## 2. Créer le jeton (PAT)

À faire toi-même sur https://github.com/settings/personal-access-tokens :

- **Fine-grained token**, expiration la plus longue possible (à renouveler à l'échéance)
- *Repository access* → **Only select repositories** → `daily-log`
- *Permissions → Repository permissions → Contents* → **Read and write**

## 3. Enregistrer le jeton comme secret

```
gh secret set DAILY_PAT --repo NelioMega/daily-log
```

La commande demande le jeton en entrée : colle-le, il n'est jamais écrit sur le disque.

## 4. Vérifier tout de suite

```
gh workflow run "Contribution quotidienne" --repo NelioMega/daily-log -f commits=1
```

Puis, après ~30 s :

```
gh run list --repo NelioMega/daily-log --limit 3
```

## Réglages optionnels

```
gh variable set MIN_COMMITS --repo NelioMega/daily-log --body 1
gh variable set MAX_COMMITS --repo NelioMega/daily-log --body 4
gh variable set GIT_USER_EMAIL --repo NelioMega/daily-log --body ton@email.com
```

L'heure se change dans le `cron` de `.github/workflows/daily.yml` (en **UTC**).

## Pourquoi ça compte vraiment comme une contribution

Quatre conditions, toutes remplies ici :

1. L'e-mail de l'auteur du commit est rattaché et vérifié sur ton compte GitHub.
2. Le commit est sur la **branche par défaut** du dépôt.
3. Le dépôt t'appartient et n'est pas un fork.
4. Le push est fait avec **ton** PAT, pas avec le `GITHUB_TOKEN` par défaut —
   sinon l'auteur devient `github-actions[bot]` et rien ne compte.

Bonus du point 4 : GitHub désactive les workflows planifiés après 60 jours
*sans activité utilisateur*. Un push par PAT compte comme activité utilisateur,
donc le cron ne s'éteint jamais tout seul.

## Si ça ne marche pas

| Symptôme | Cause quasi certaine |
|---|---|
| Le run est vert mais le graphe reste gris | e-mail non vérifié dans *Settings → Emails*, ou dépôt privé sans l'option de contributions privées |
| `remote: Permission denied` | PAT expiré, ou permission *Contents* laissée en lecture seule |
| Plus aucun run depuis des semaines | le secret `DAILY_PAT` a expiré → refais l'étape 2 puis l'étape 3 |
| Le run ne part jamais à l'heure | normal, le cron GitHub est décalé quand la charge est haute |
