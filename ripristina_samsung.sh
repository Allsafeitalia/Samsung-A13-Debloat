#!/bin/bash
# Ripristina solo i pacchetti che erano installati prima della pulizia.
set -u

ADB="${ADB:-adb}"
DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_FILE="$DIR/samsung_a13_backup_packages.txt"
LOG_FILE="$DIR/samsung_a13_restore.log"

if ! command -v "$ADB" >/dev/null 2>&1; then
  echo "ERRORE: adb non trovato. Installa con: brew install android-platform-tools"
  exit 1
fi

STATE="$("$ADB" get-state 2>/dev/null || true)"
if [ "$STATE" != "device" ]; then
  echo "ERRORE: telefono non autorizzato o non collegato."
  "$ADB" devices
  exit 1
fi

if [ ! -s "$BACKUP_FILE" ]; then
  echo "ERRORE: backup non trovato o vuoto: $BACKUP_FILE"
  echo "Esegui prima ottimizza_samsung.sh; serve il file creato durante la pulizia."
  exit 1
fi

echo "Verranno ripristinati questi pacchetti:"
cat "$BACKUP_FILE"
echo
read -r -p "Procedere? (scrivi SI per confermare): " CONFIRM
if [ "$CONFIRM" != "SI" ]; then
  echo "Operazione annullata."
  exit 0
fi

: > "$LOG_FILE"
while IFS= read -r pkg; do
  [ -n "$pkg" ] || continue
  echo "Ripristino: $pkg"
  "$ADB" shell cmd package install-existing --user 0 "$pkg" >> "$LOG_FILE" 2>&1 \
    || "$ADB" shell pm install-existing --user 0 "$pkg" >> "$LOG_FILE" 2>&1 \
    || echo "ATTENZIONE: ripristino non riuscito per $pkg (vedi log)"
done < "$BACKUP_FILE"

echo
echo "Ripristino terminato. Riavvia il telefono."
echo "Log: $LOG_FILE"
