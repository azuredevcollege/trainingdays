#!/bin/bash
REMOTE_ORIGIN=$(git remote get-url origin)
set -euo pipefail
shopt -s inherit_errexit

if [ $# -eq 0 ]
  then
    echo "Please provide your GitHub username as argument"
    exit
fi
echo "Using GitHub username: $1";
echo "Asuming GitHub user repo to be: $1/trainingdays"
echo "Asuming origin to point to: azuredevcollege/trainingdays"
if [ "$REMOTE_ORIGIN" != "git@github.com:azuredevcollege/trainingdays.git" ]
  then
    echo "Remote 'origin' not pointing to trainer repo!"
    echo "Please run: git remote set-url origin git@github.com:azuredevcollege/trainingdays.git"
    echo "or: git remote add origin git@github.com:azuredevcollege/trainingdays.git"
    exit
fi
echo "Reseting master to trainer repo"
git fetch origin
git checkout master
git reset origin/master --hard
for i in .github/workflows/day4-scm-*; do
    sed -i "s/'azuredevcollege\/trainingdays'/'$1\/trainingdays'/g" $i
done
echo "Staging changes..."
git add .github/workflows/day4-scm-*
echo "Commiting changes..."
git commit -m "Enable workflow files for $1/trainingdays"
if git remote get-url script > /dev/null 2> /dev/null; then
  echo "Remote already present."
else
  echo "Adding remote 'script'..."
  git remote add script git@github.com:$1/trainingdays.git
fi
echo "Pushing changes..."
git push script master -f
echo "Done! Now Add the 'AZURE_CREDENTIALS' and 'SQL_PASSWORD' secrets to you GitHub pipeline."
