#!/usr/bin/env bash
set -euo pipefail

APP_ROOT=/var/www/html
PERSIST_ROOT=${PERSIST_ROOT:-/data}

mkdir -p \
  "$PERSIST_ROOT/runtime" \
  "$PERSIST_ROOT/config" \
  "$PERSIST_ROOT/app/Plugin" \
  "$PERSIST_ROOT/assets/cache" \
  "$PERSIST_ROOT/kernel/Install"

if [ ! -f "$PERSIST_ROOT/config/database.php" ]; then
  cp "$APP_ROOT/config/database.php" "$PERSIST_ROOT/config/database.php"
fi

if [ ! -f "$PERSIST_ROOT/config/store.php" ] && [ -f "$APP_ROOT/config/store.php" ]; then
  cp "$APP_ROOT/config/store.php" "$PERSIST_ROOT/config/store.php"
fi

if [ ! -f "$PERSIST_ROOT/config/terms" ] && [ -f "$APP_ROOT/config/terms" ]; then
  cp "$APP_ROOT/config/terms" "$PERSIST_ROOT/config/terms"
fi

rm -rf "$APP_ROOT/runtime" "$APP_ROOT/config" "$APP_ROOT/app/Plugin" "$APP_ROOT/assets/cache"
ln -sfn "$PERSIST_ROOT/runtime" "$APP_ROOT/runtime"
ln -sfn "$PERSIST_ROOT/config" "$APP_ROOT/config"
ln -sfn "$PERSIST_ROOT/app/Plugin" "$APP_ROOT/app/Plugin"
mkdir -p "$APP_ROOT/assets"
ln -sfn "$PERSIST_ROOT/assets/cache" "$APP_ROOT/assets/cache"

mkdir -p "$APP_ROOT/runtime" "$APP_ROOT/assets/cache" "$APP_ROOT/app/Plugin"
chown -R www-data:www-data "$PERSIST_ROOT" "$APP_ROOT"
find "$PERSIST_ROOT" -type d -exec chmod 775 {} \;
find "$PERSIST_ROOT" -type f -exec chmod 664 {} \; || true

exec "$@"
