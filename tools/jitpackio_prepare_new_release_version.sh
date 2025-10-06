#! /bin/bash

_HOME2_=$(dirname $0)
export _HOME2_
_HOME_=$(cd $_HOME2_;pwd)
export _HOME_

basedir="$_HOME_""/../"

f1="jitpack.yml"
f2="pom.xml"
f3=$(ls -1tr local_maven_sqlitejdbc_*.zip|tail -1|tr -d " ")

cd "$basedir"

if [[ $(git status --porcelain --untracked-files=no) ]]; then
	echo "ERROR: git repo has changes."
	echo "please commit or cleanup the git repo."
	exit 1
else
	echo "git repo clean."
fi

cur_m_version=$(echo "$f3" | sed -e 's#^.*local_maven_sqlitejdbc_##'|sed -e 's#.zip$##')

# thanks to: https://stackoverflow.com/a/8653732
# next_m_version=$(echo "$cur_m_version"|awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}')
next_m_version="$cur_m_version"

echo $cur_m_version
echo $next_m_version

sed -i -e 's#unzip local_maven_sqlitejdbc_.*$#unzip local_maven_sqlitejdbc_'"$next_m_version"'.zip#' "$f1"
sed -i -e 's#.version..*./version.#<version>'"$next_m_version"'</version>#' "$f2"

commit_message="$next_m_version"
tag_name="$next_m_version"

git add "$f3"
git commit -m "$commit_message" "$f1" "$f2" "$f3"
git tag -a "$tag_name" -m "$tag_name"

