DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

PACKAGES=`git ls-files | xargs dirname | cut -d / -f 1 | sort | uniq | grep -v '^\.\|tool\|\.github$'`

echo '### Detected following packages:'
for p in $PACKAGES; do
  echo " - $p"
done
read -p 'Confirm update of labels and issue templates (y/n):'
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo 'Aborted!'
  exit 1;
fi


for P in $PACKAGES; do
cat <<EOF > $DIR/../.github/ISSUE_TEMPLATE/$P.md
---
name: Issue with $P
about: Bug, feature request or question regarding 'package:$P'
title: ''
labels: pkg:$P, pending-triage
assignees:
---
 * Explain the issue,
 * Using bullet points!

\`\`\`dart
// Write example code here
\`\`\`
EOF
done

# Returns 0, if the list $1 contains the element $2.
# Usage: if `list_contains "$MYLIST" "$MYITEM"`; then echo "$MYITEM is here"; fi
function list_contains {
  if [[ $1 =~ (^|[[:space:]])"$2"($|[[:space:]]) ]] ; then
    return 0
  fi
  return 1
}

LABELS=`hub api -X GET '/repos/google/dart-neats/labels' | jq -r '.[].name' | grep 'pkg:'`

for P in $PACKAGES; do
  if `list_contains "$LABELS" "pkg:$P"`; then 
    echo " - skip pkg:$P"
  else 
    echo " - creating: pkg:$P"
    hub api -X POST '/repos/google/dart-neats/labels' -F name="pkg:$P" -F color=f29513 | jq
  fi
done