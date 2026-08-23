#!/usr/bin/env bash
# Génère N commits datés du jour dans logs/AAAA-MM.md, puis met à jour le README.
set -euo pipefail

MIN_COMMITS="${MIN_COMMITS:-1}"
MAX_COMMITS="${MAX_COMMITS:-3}"

if [ "$MAX_COMMITS" -lt "$MIN_COMMITS" ]; then MAX_COMMITS="$MIN_COMMITS"; fi
span=$(( MAX_COMMITS - MIN_COMMITS + 1 ))
n=$(( RANDOM % span + MIN_COMMITS ))

VERBS=("relecture" "tri des notes" "veille" "nettoyage" "brouillon" "idée en vrac" \
       "lecture technique" "revue de code" "expérimentation" "prise de notes" \
       "refonte mentale" "check-list" "point d'avancement")

day="$(date -u +%F)"
month_file="logs/$(date -u +%Y-%m).md"
mkdir -p logs

if [ ! -f "$month_file" ]; then
  printf '# Journal — %s\n\n' "$(date -u +'%Y-%m')" > "$month_file"
fi

for i in $(seq 1 "$n"); do
  verb="${VERBS[$(( RANDOM % ${#VERBS[@]} ))]}"
  printf -- '- %s UTC · %s\n' "$(date -u +'%F %H:%M:%S')" "$verb" >> "$month_file"

  total=$(cat logs/*.md 2>/dev/null | grep -c '^- ' || true)
  days=$(cat logs/*.md 2>/dev/null | grep -o '^- [0-9-]\{10\}' | sort -u | wc -l | tr -d ' ')

  {
    echo "# Journal quotidien"
    echo
    echo "Petit journal alimenté automatiquement une fois par jour."
    echo
    echo "| | |"
    echo "|---|---|"
    echo "| Dernière entrée | \`$(date -u +'%F %H:%M') UTC\` |"
    echo "| Entrées au total | **$total** |"
    echo "| Jours couverts | **$days** |"
    echo
    echo "Les entrées vivent dans [\`logs/\`](logs/), un fichier par mois."
    echo
    echo "<sub>Généré par [\`.github/workflows/daily.yml\`](.github/workflows/daily.yml).</sub>"
  } > README.md

  git add -A
  git commit -q -m "log: $day ($i/$n) — $verb"
  echo "commit $i/$n : $verb"
  sleep 2
done
