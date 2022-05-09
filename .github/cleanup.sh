#!/usr/bin/env sh

export LC_CTYPE=C
export LANG=C

# Prepare variables
NAME="${GITHUB_REPOSITORY##*/}"
ACTOR=$(echo $GITHUB_ACTOR | tr '[:upper:]' '[:lower:]')
SAFE_NAME=$(echo $NAME | sed 's/[^a-zA-Z0-9]//g' | tr '[:upper:]' '[:lower:]')
SAFE_ACTOR=$(echo $ACTOR | sed 's/[^a-zA-Z0-9]//g' | tr '[:upper:]' '[:lower:]')
GROUP="com.github.$SAFE_ACTOR.$SAFE_NAME"

# Replace placeholders in the template-cleanup files
sed -i "s/%NAME%/$NAME/g" .github/template-cleanup/*
sed -i "s/%REPOSITORY%/${GITHUB_REPOSITORY/\//\\/}/g" .github/template-cleanup/*
sed -i "s/%GROUP%/$GROUP/g" .github/template-cleanup/*

# Replace template package name in project files with $GROUP
find src -type f -exec sed -i "s/org.jetbrains.plugins.template/$GROUP/g" {} +
find src -type f -exec sed -i "s/Template/$NAME/g" {} +
find src -type f -exec sed -i "s/JetBrains/$ACTOR/g" {} +

# Move content
mkdir -p src/main/kotlin/${GROUP//.//}
mkdir -p src/test/kotlin/${GROUP//.//}
cp -R .github/template-cleanup/* .
cp -R src/main/kotlin/org/jetbrains/plugins/template/* src/main/kotlin/${GROUP//.//}/
cp -R src/test/kotlin/org/jetbrains/plugins/template/* src/test/kotlin/${GROUP//.//}/

# Cleanup
rm -rf \
  .github/ISSUE_TEMPLATE \
  .github/readme \
  .github/template-cleanup \
  .github/workflows/template-cleanup.yml \
  .idea/icon.png \
  src/main/kotlin/org \
  src/test/kotlin/org \
  CODE_OF_CONDUCT.md \
  LICENSE
