# Konfiguration

Technisch bedingt können Arbeitszeiten immer nur zusammen mit einem Artikel erfasst und abgelegt werden, daher legt dieses Add-on mindestens einen eigene Artikel je Ticket an. Dessen Attribute können über die System-Konfiguration festgelegt werden. Dort wird auch eingestellt ob je Ticket nur ein Artikel oder für jede erfasste Zeit ein neuer angelegt wird.

Eine Änderung der Einstellungen wirkt sich auf vorhandene und neue erstellte Tickets aus.

## Einblenden der Zeiterfassung in einem Aktivitätsdialog
Um die Zeit zu erfassen muss das dynamische Feld `ProcessTimeUnits` einem Dialog hinzugefügt werden.

## System-Konfiguration

### Betreff des Artikels
Der Text aus `Znuny4OTRSProcessTimeUnits::Article###Subject` wird als Betreff für den erstellten Artikel verwendet.

### Inhalt des Artikels
Für den Inhalt des Artikels wird der Text aus der Einstellung `Znuny4OTRSProcessTimeUnits::Article###Body` verwendet.

### Erstellertyp des Artikels
Über `Znuny4OTRSProcessTimeUnits::Article###SenderType` wird ausgewählt wer den Artikel erstellt hat:
- das **System**,
- der **Kunde** oder
- der **Agent** (Standardwert)
Für vorhandene Artikel zur Zeiterfassung ist der Typ nicht nachträglich änderbar.

### Anzahl der Artikel
Mit `Znuny4OTRSProcessTimeUnits::ArticleCreateOnce` legen Sie fest ob insgesamt nur ein Artikel je Ticket angelegt werden soll oder einer für jede erfasste Arbeitszeit.
