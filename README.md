
# (K)ein ganz normales Stichspiel?

# Bienenstich

Ein Spiel von Fabian Balzer und Colin Ihlenfeldt

## Benötigte Karten

1-18 in 5 Farben

|Anzahl Spieler | Anzahl Karten | Kartenkombinationen|
|---------------|---------------|--------------------|
|2 Spieler |    42 (3 übrig) |    3x 1-14|
|3 Spieler |    56 (5 übrig) |    4x 1-14|
|4 Spieler |    68 (5 übrig) |    4x 1-17|
|5 Spieler |    85 (10 übrig) |    5x 1-17|
|6 Spieler |    90 (3 übrig) |    5x 1-18|

## Spielablauf

- Karten werden verteilt: (Anzahl Spieler)+1 Stapel mit je 12 Karten + 2 Karten extra + 1 Karte für Trumpf
  - Übrige Karten kommen beiseite
- Trumpffarbe wird aufgedeckt
- Rollen werden gewählt
  - Gegen den Uhrzeigersinn, beginnend beim Geber
  - Variante: Erst stehen nur drei zufällige Rollen zur Auswahl, zwischen denen gewählt wird. Der Geber wählt eine dieser Rollen, der nächste Spieler erhält die verbliebenen beiden zur Auswahl, ergänzt um eine weitere zufällig gewählte Rolle.
- Rolleneffekte werden ausgeführt (Trumpffarbe geändert, Tokens verteilt, …)

### Legeregeln

- Trümpfe können nur gespielt werden, wenn man keine Farbe bedienen muss
- Nieten können immer gespielt werden
- Letzter Trumpf gewinnt, außer letzte Runde
- Kein Farbzwang, wenn Trumpf gespielt wird

## Rollen

Kein Zugzwang - A  
Du musst nicht legen, wenn du nicht möchtest, dh du kannst auch Karten übrig haben.
Punkte: Anzahl Stiche * 2

Trumpf bestimmen - B  
Du darfst die Trumpffarbe bestimmen.
Punkte: Anzahl Stiche * 2

Drücken - C  
Du darfst am Anfang 2 Karten drücken und dafür 2 der übrigen Karten nehmen.
Punkte: Anzahl Stiche * 2

Letzte Karte - D  
Du legst immer als Letztes, es sei denn, du spielst den Stich an.
Punkte: Anzahl Stiche * 2

Kein Farbzwang - E  
Du kannst immer alle Karten spielen
Punkte: Anzahl Stiche

Zwei Karten pro Stich - F  
Du erhältst 20 Karten am Anfang und musst immer wenn du am Zug bist noch eine weitere Karte legen.
Punkte: Anzahl Stiche

Anspielen - G  
Du spielst jeden Stich an.
Punkte: Anzahl Stiche

Fremde Punkte sammeln - H  
Wähle am Anfang zwei Spieler.
Punkte: Der Mittelwert (aufgerundet) aus deren Punkten

Kein Trumpf - I  
Keine deiner Karten ist Trumpf.
Punkte: max(0, 8 - Anzahl Stiche * 2)

Verdecktes Spiel - J
Wenn du nicht ausspielst, spielst du deine Karten verdeckt.
Erst am Ende jedes Stichs wird die verdeckte Karte aufgedeckt.
Punkte: Anzahl Stiche * 2

Seher - K
Vor Spielbeginn darfst du dir die Karten eines anderen Spielers anschauen.

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
- [ ] Add version (also dev mode toggle?) to game so we can distinguish
- [ ] Rework role selection (make it look nice)
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
  - [ ] How are players with the same amount of points handled?
  - [ ] How is the final leaderboard displayed?
    - [x] Properly calculate order with players at same spot
    - [ ] Rework corresponding log entry
- [ ] Advanced Role selection: Implement that each player has to choose from a limited number of roles, and add selection capability for that mode
