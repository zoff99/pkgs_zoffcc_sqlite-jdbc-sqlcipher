#! /bin/bash

_HOME2_=$(dirname $0)
export _HOME2_
_HOME_=$(cd $_HOME2_;pwd)
export _HOME_

basedir="$_HOME_""/../"
cd "$basedir"

pkg='pkgs_zoffcc_sqlite-jdbc-sqlcipher'
zip_pkg_name='local_maven_sqlitejdbc_'
ext="jar"

f3=$(ls -1tr "$zip_pkg_name"*.zip|tail -1|tr -d " ")
VERSION=$(echo "$f3" | sed -e 's#^.*'"$zip_pkg_name"'##'|sed -e 's#.zip$##')
hash_file="$pkg""-""$VERSION"".aar.sha256"
LOCAL_HASH=$(cat "$hash_file" | cut -f1 -d' ')
echo "Local Hash:    $LOCAL_HASH"


# Download the jitpack artefact
ARTEFACT_URL="https://jitpack.io/com/github/zoff99/${pkg}/${VERSION}/${pkg}-${VERSION}.${ext}"
echo "Artefact URL: $ARTEFACT_URL"

REMOTE_ARTEFACT_FILE="remote_artefact.tmp"
rm -f "$REMOTE_ARTEFACT_FILE"
echo "Downloading remote artefact..."
curl -sL "$ARTEFACT_URL" -o "$REMOTE_ARTEFACT_FILE"
# calculate the hash of the downloaded file
REMOTE_HASH=$(sha256sum "$REMOTE_ARTEFACT_FILE" | cut -f1 -d' ')
echo "Remote Hash:   $REMOTE_HASH"
rm -f "$REMOTE_ARTEFACT_FILE"


# Compare the sums
if [ "$LOCAL_HASH" == "$REMOTE_HASH" ]; then
    echo "SUCCESS: The SHA256 sums match!"
    exit 0
else
    echo "ALARM: The SHA256 sums do NOT match !!!"
    exit 1
fi



