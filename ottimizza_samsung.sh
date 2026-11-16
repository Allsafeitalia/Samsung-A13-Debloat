#!/bin/bash
# Samsung Galaxy A13 5G (SM-A136B/DSN) - ADB debloat
# Removes only selected apps for Android user 0. Does NOT delete firmware/system APKs.
# Run from macOS Terminal with the phone connected and USB debugging authorized.

set -u

ADB="${ADB:-adb}"
BACKUP_FILE="$(cd "$(dirname "$0")" && pwd)/samsung_a13_backup_packages.txt"
LOG_FILE="$(cd "$(dirname "$0")" && pwd)/samsung_a13_debloat.log"

# Selected apps and closely related companion packages found in the supplied package list.
PACKAGES=(
  # Facebook app and preinstalled Facebook support services
  "com.facebook.katana"
  "com.facebook.appmanager"
  "com.facebook.system"
  "com.facebook.services"

  # Google TV, YouTube Music e app Google (ricerca/Assistente)
  "com.google.android.videos"
  "com.google.android.apps.youtube.music"
  "com.google.android.googlequicksearchbox"

  # Samsung Free
  "com.samsung.android.app.spage"

  # AR Zone / AR Emoji and directly related editor/sticker components
  "com.samsung.android.arzone"
  "com.samsung.android.aremoji"
  "com.samsung.android.aremojieditor"
  "com.sec.android.mimage.avatarstickers"

  # Dynamic Lock screen
  "com.samsung.android.dynamiclock"

  # Game Launcher (does not remove Game Booster / thermal services)
  "com.samsung.android.game.gamehome"

  # Samsung Galaxy Store
  "com.sec.android.app.samsungapps"

  # Samsung Themes app and its theme center
  "com.samsung.android.themestore"
  "com.samsung.android.themecenter"

  # Samsung Video
  "com.samsung.android.video"

  # OneDrive e Samsung Archivio (My Files)
  "com.microsoft.skydrive"
  "com.sec.android.app.myfiles"

  # Samsung Reminder
  "com.samsung.android.app.reminder"

  # Smart Switch and its companion components
  "com.sec.android.easyMover"
  "com.sec.android.easyMover.Agent"
  "com.samsung.android.smartswitchassistant"
)

echo "== Samsung Galaxy A13 5G: pulizia ADB =="

if ! command -v "$ADB" >/dev/null 2>&1; then
  echo "ERRORE: adb non trovato. Installa con: brew install android-platform-tools"
  exit 1
fi

STATE="$("$ADB" get-state 2>/dev/null || true)"
if [ "$STATE" != "device" ]; then
  echo "ERRORE: telefono non autorizzato o non collegato."
  echo "Controlla il cavo, sblocca il telefono e autorizza il Debug USB."
  "$ADB" devices
  exit 1
fi

MODEL="$("$ADB" shell getprop ro.product.model 2>/dev/null | tr -d '\r')"
echo "Dispositivo rilevato: ${MODEL:-modello non disponibile}"
echo "Backup elenco pacchetti in: $BACKUP_FILE"

# Save only packages currently installed for user 0. This makes restore precise:
# packages absent before this run will not be reinstalled by the restore script.
: > "$BACKUP_FILE"
: > "$LOG_FILE"
CURRENT="$("$ADB" shell pm list packages --user 0 2>/dev/null | sed 's/^package://' | tr -d '\r')"

for pkg in "${PACKAGES[@]}"; do
  if printf '%s\n' "$CURRENT" | grep -Fxq "$pkg"; then
    echo "$pkg" >> "$BACKUP_FILE"
  fi
done

if [ ! -s "$BACKUP_FILE" ]; then
  echo "Nessuna delle app selezionate risulta installata per l'utente principale."
  exit 0
fi

echo
echo "Pacchetti che verranno rimossi per l'utente principale:"
cat "$BACKUP_FILE"
echo
read -r -p "Procedere? (scrivi SI per confermare): " CONFIRM
if [ "$CONFIRM" != "SI" ]; then
  echo "Operazione annullata. Nessuna app rimossa."
  exit 0
fi

echo
echo "Avvio rimozione..."
while IFS= read -r pkg; do
  [ -n "$pkg" ] || continue
  echo "Rimozione: $pkg"
  if "$ADB" shell pm uninstall --user 0 "$pkg" >> "$LOG_FILE" 2>&1; then
    echo "  richiesta inviata"
  else
    echo "  ATTENZIONE: comando non riuscito per $pkg (vedi log)"
  fi
done < "$BACKUP_FILE"

echo
echo "Operazione terminata."
echo "Backup ripristinabile: $BACKUP_FILE"
echo "Log: $LOG_FILE"
echo "Riavvia il telefono e verifica chiamate, fotocamera, rete e app che usi."
echo "Per ripristinare, esegui: ./ripristina_samsung.sh"
