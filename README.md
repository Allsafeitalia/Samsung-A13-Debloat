# Samsung Galaxy A13 5G Debloat (SM-A136B/DSN)

Script ADB per rimuovere applicazioni preinstallate non necessarie dal Samsung Galaxy A13 5G, senza root e senza modificare il firmware.

## File inclusi

- `ottimizza_samsung.sh`: rimuove per l'utente Android principale le app selezionate.
- `ripristina_samsung.sh`: ripristina solo i pacchetti che risultavano installati prima della pulizia.
- Il primo script crea `samsung_a13_backup_packages.txt` e un log.

## Requisiti

- macOS con Android Platform Tools: `brew install android-platform-tools`
- Debug USB attivo
- Telefono collegato, sbloccato e autorizzato
- `adb devices` deve mostrare il dispositivo con stato `device`

## Installazione e uso

Scarica o clona il repository, poi apri Terminale nella cartella:

```bash
chmod +x ottimizza_samsung.sh ripristina_samsung.sh
./ottimizza_samsung.sh
```

Leggi la lista dei pacchetti mostrata e conferma digitando esattamente `SI`.

Per ripristinare le app:

```bash
./ripristina_samsung.sh
```

**Conserva `samsung_a13_backup_packages.txt`**: è necessario per il ripristino e deve restare nella stessa cartella degli script.

## Applicazioni incluse nella pulizia

- Facebook e relativi servizi preinstallati
- Google TV
- Samsung Free
- AR Zone, AR Emoji e componenti correlati
- Dynamic Lock
- Game Launcher
- Samsung Themes
- Samsung Video
- OneDrive
- Samsung Reminder
- Smart Switch e componenti correlati

Non vengono rimossi Game Booster / Game Optimizing Service, telefonia, fotocamera, launcher, System UI, Google Play Services, servizi SIM/rete, Knox o aggiornamenti.

## Come funziona e limiti

- La rimozione usa `pm uninstall --user 0`: non cancella l'APK dal firmware e in genere è reversibile.
- Il backup contiene solo i pacchetti effettivamente installati per l'utente 0 prima dell'intervento.
- Alcune funzioni collegate alle app rimosse non saranno disponibili finché non vengono ripristinate.
- Non è garantito un aumento netto della RAM: il risultato dipende da quali app e servizi erano attivi.
- Controlla sempre i pacchetti mostrati prima di confermare.
- Non eseguire script ADB di cui non conosci la provenienza.
