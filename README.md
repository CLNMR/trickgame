
# (K)ein ganz normales Stichspiel?

# Bienenstich

Ein Spiel von Fabian Balzer und Colin Ihlenfeldt

## Benötigte Karten

Standardmäßig:
**1-15 in 4 Farben (= 60 Karten)**
**+ doppelte Karten von 3 bis 13, die nach Bedarf (Spielerzahl) hinzugefügt werden.**

|Anzahl Spieler | Anzahl Karten | Extra-Karten|
|---------------|---------------|--------------------|
|3 Spieler |    60 (0 übrig) |    - |
|4 Spieler |    76 (2 übrig) |    6, 7, 8, 9 hinzu |
|5 Spieler |    88 (0 übrig) |    3, 4, 5 hinzu |
|6 Spieler |    104 (2 übrig) |    10, 11, 12, 13 hinzu |

## Spielablauf

- Karten werden verteilt: 14 Karten pro Spieler, ein Extrablatt mit 14 Karten, 3 Drückeberger-Karten, 1 trumpfbestimmende Karte
  - Übrige Karten (bei 4 und 6 Spielern) werden verdeckt beiseite gelegt
- Trumpffarbe wird aufgedeckt
- Rollen werden der Reihe nach im Uhrzeigersinn gewählt (beginnend bei der Person links des Gebers, dem *Anspieler*), die entsprechende Königin wird auf die Hand genommen.
  - Variante: Erst stehen nur drei zufällige Rollen zur Auswahl, zwischen denen gewählt wird. Der *Anspieler* wählt eine dieser Rollen, der nächste Spieler erhält die verbliebenen beiden zur Auswahl, ergänzt um eine weitere zufällig gewählte Rolle.
- Rolleneffekte werden anschließend in der gleichen Reihenfolge ausgeführt (Trumpffarbe geändert, Tokens verteilt, …)
- Anschließend beginnt (i.d.R.) der *Anspieler* den ersten Stich.

### Legeregeln

- Trümpfe können nur gespielt werden, wenn man keine Farbe bedienen muss.
- Königinnen können immer gespielt werden, es gewinnt stets die erste gespielte Königin.
- Kein Farbzwang, wenn mit einer Königin angespielt wird.
- Bei identischen Karten: Die zuerst gelegte Karte wird als höher gewertet.

## Rollen

Kein Zugzwang - A  
Du musst nicht legen, wenn du nicht möchtest, dh du kannst auch Karten übrig haben.
Punkte: Anzahl Stiche * 2

Trumpf bestimmen - B  
Du darfst die Trumpffarbe bestimmen.
Punkte: Anzahl Stiche * 2

Drücken - C  
Du darfst am Anfang 3 Karten drücken und dafür 3 der übrigen Karten nehmen.
Punkte: Anzahl Stiche * 2

Letzte Karte - D  [ab 4 Spielern]
Du legst immer als Letztes, es sei denn, du spielst den Stich an.
Punkte: Anzahl Stiche * 2

Kein Farbzwang - E  
Du kannst immer alle Karten spielen
Punkte: Anzahl Stiche

Zwei Karten pro Stich - F  
Du erhältst 20 Karten am Anfang und musst immer wenn du am Zug bist noch eine weitere Karte legen.
Punkte: Anzahl Stiche

Anspielen - G  [ab 4 Spielern]
Du spielst jeden Stich an.
Punkte: Anzahl Stiche * 2

Fremde Punkte sammeln - H [ab 4 Spielern]
Wähle am Anfang zwei Spieler.
Punkte: Die Summe aus deren Punkten abzüglich der eigenen Stichzahl * 2
**TODO** Implementieren

Möglichst wenig ohne Trumpf - I  
Keine deiner Karten ist Trumpf.
Punkte:
- 3 Spieler: max(0, 12 - Anzahl Stiche * 2)
- 4 Spieler: max(0, 10 - Anzahl Stiche * 2)
- 5 Spieler: max(0, 8 - Anzahl Stiche * 2)
- 6 Spieler: max(0, 6 - Anzahl Stiche * 2)
**TODO** Basispunktzahl der Spielerzahl anpassen

Verdeckt Spielen: Tarnungsmeisterin - J
Wenn du nicht ausspielst, spielst du deine Karten verdeckt.
Erst am Ende jedes Stichs wird die verdeckte Karte aufgedeckt.
Punkte: Anzahl Stiche * 2

Seher - K
Vor Spielbeginn darfst du dir die Karten eines anderen Spielers und alle beiseite gelegten Karten anschauen.
Punkte: Anzahl Stiche * 2

Möglichst wenig mit Niete: Drohne - L
Du versuchst keine Stiche zu bekommen. Deine Königin ist eine Drohne, die niemals einen Stich bekommt.
Punkte:
- 3 Spieler: max(0, 12 - Anzahl Stiche * 2)
- 4 Spieler: max(0, 10 - Anzahl Stiche * 2)
- 5 Spieler: max(0, 8 - Anzahl Stiche * 2)
- 6 Spieler: max(0, 6 - Anzahl Stiche * 2)

Nutzung doppelter Karten: Zwilling - M [ab 4 Spielern]
Du kannst zwei identische Exemplare (z.B. zwei grüne Sechsen) gemeinsam ausspielen. Diese werden dann als höchste Karte dieser Farbe gewertet.
Punkte: Anzahl Stiche * 2

Vorhersehung - N
Du sagst für alle Spieler vorher, wie viele Stiche sie erzielen werden.
Punkte:
- 3 Spieler: Pro Spieler: max(0, 4 - Differenz zur Vorhersage)
- 4 Spieler: Pro Spieler: max(0, 3 - Differenz zur Vorhersage)
- 5 Spieler: Pro Spieler: max(0, 2 - Differenz zur Vorhersage)
- 6 Spieler: Pro Spieler: max(0, 1 - Differenz zur Vorhersage)

## Spielstatistik

F C G I - 5 6 3 6
Database-Schema: Alle verfügbaren Karten, dann alle gespielten Karten und deren Punkte:
("ABCDEFGHIJK", "F5C3G3I6")

## Python-version

Pygame kann gestartet werden durch

```python -m tricking_bees```

Benötigt python 3.12 oder höher + pygame.

## TODOs

- [x] Log and display the trump color.
- [x] Implement proper log messages
- [x] Show previous trick
- [x] Distinguish Round and Subgame for log header
- [x] Show player order in nicer way, maybe assign player colors.
- [x] Distinguish between dev and prod mode.
- [x] Log messages:
  - [x] Choose role
  - [x] Playing a card hidden
  - [x] Choose person
  - [x] Choose trump color
  - [x] Extra cards being dealt
- [ ] Logging
  - [ ] Rework how subgames are collapsed - When a previous subgame is un-collapsed, all rounds should be collapsed, but the important info of who won should be visible.
  - [ ] Separate last round and point awarding
- [ ] Implement additional phase at the end of each subgame to show an overview of the awarded points
- [ ] Add version (also dev mode toggle?) to game so we can distinguish
- [ ] Display:
  - [ ] Rework role selection (make it look nice)
  - [ ] Display the queen differently
- [ ] Implement one-queen-per-role mode, distribute queens with the role and have the first queen in a trick be the winning one
- [ ] Rework status messages
  - [x] Choose role
  - [x] Current role
  - [x] Play card
  - [ ] Edge cases?
  - [ ] Dynamic messages after you did something wrong?
- [ ] Implement Basic Bot
  - [x] Implement random action scheme
  - [ ] Implement 'Start game with bots' and have them play automatically
  - [ ] Maybe implement offline mode?
- [ ] Look at end-of-game:
  - [ ] Fix how players with the same amount of points are handled
  - [ ] How is the final leaderboard displayed?
    - [x] Properly calculate order with players at same spot
    - [ ] Rework corresponding log entry
    - [ ] Rework corresponding status message
- [ ] Advanced Role selection: Implement that each player has to choose from a limited number of roles, and add selection capability for that mode
