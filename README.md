# Samsung Galaxy A13 5G Debloat (SM-A136B/DSN)

Script ADB per rimuovere alcune applicazioni preinstallate dal Samsung Galaxy A13 5G, senza root e senza modificare il firmware.

## File inclusi

- `ottimizza_samsung.sh`: rimuove per l'utente Android principale le app selezionate.
- `ripristina_samsung.sh`: ripristina solo i pacchetti che risultavano installati prima della pulizia.
- Lo script di pulizia crea `samsung_a13_backup_packages.txt` e un file di log.

## Requisiti

- macOS con Android Platform Tools: `brew install android-platform-tools`
- Debug USB attivo
- Telefono collegato, sbloccato e autorizzato
- `adb devices` deve mostrare il dispositivo con stato `device`

## Preparazione su Mac

Clona il repository:

```bash
git clone https://github.com/Allsafeitalia/Samsung-A13-Debloat.git
cd Samsung-A13-Debloat
```

Se hai già la cartella sul Mac, entra nella cartella e aggiorna i file:

```bash
cd ~/Samsung-A13-Debloat
git pull origin main
```

Rendi eseguibili gli script:

```bash
chmod +x ottimizza_samsung.sh ripristina_samsung.sh
```

Verifica che ADB veda il telefono:

```bash
adb devices
```

Se compare una richiesta sul telefono, sbloccalo e autorizza il computer.

## Esecuzione sul telefono

Dalla cartella del progetto esegui:

```bash
./ottimizza_samsung.sh
```

Lo script mostra i pacchetti che intende rimuovere. Controlla la lista e digita esattamente `SI` solo se sei d'accordo.

Al termine, riavvia il telefono.

## App selezionate per la rimozione

- Facebook e relativi servizi preinstallati
- Google TV e YouTube Music
- Samsung Free
- AR Zone, AR Emoji e componenti correlati
- Dynamic Lock
- Gaming Hub / Game Launcher
- Samsung Themes
- Samsung Video
- OneDrive
- Samsung Archivio / My Files
- Samsung Reminder
- Smart Switch e componenti correlati

## App che vengono mantenute

- **One UI Home / Samsung Home**: non viene rimosso.
- Game Booster e servizi di ottimizzazione dei giochi.
- Telefonia, fotocamera, System UI, Google Play Services, servizi SIM/rete, Knox e aggiornamenti.

## Ripristino

Conserva `samsung_a13_backup_packages.txt` nella stessa cartella degli script. Per reinstallare le app rimosse:

```bash
./ripristina_samsung.sh
```

Conferma digitando `SI`. Il ripristino usa il backup creato dallo script di pulizia.

## Note importanti

- La rimozione usa `pm uninstall --user 0`: non cancella l'APK dal firmware e in genere è reversibile.
- Il backup contiene solo i pacchetti installati per l'utente 0 prima dell'intervento.
- Le funzioni collegate alle app rimosse non saranno disponibili finché non vengono ripristinate.
- Non è garantito un aumento netto della RAM: dipende dalle app e dai servizi attivi.
- Non scollegare il telefono durante l'esecuzione.
- Controlla sempre la lista dei pacchetti prima di confermare.
