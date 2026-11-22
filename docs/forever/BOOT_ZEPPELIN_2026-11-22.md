# Boot en zeppelin: "komt over ~N seconden"? (Forever 1.60.1.71037, 22 nov 2026)

Punt 3 van Robs reeks (21 nov via sparring: *"2 en 1, doe maar, daarna 3 en 4 :)"*). Onderzoek: mh-research (21 nov
afgebroken, 22 nov afgemaakt). Nagekeken door Bouwchat 22-11; per regel staat erbij wie wat mat.

## Uitslag

**Nu niet eerlijk te zeggen aan iemand die bij een steiger aankomt: NIET TE METEN.** De rondetijd is uit te rekenen,
maar MH weet niet waar het schip in zijn ronde is. Er is niets gebouwd.

Wat misschien wel kan: aftellen nadat MH één aankomst heeft meegemaakt. Dat hangt aan twee dingen die niemand van ons
gemeten heeft: (1) roept de zeppelinmeester bij aankomst iets dat een addon kan lezen, (2) blijft die ene waarneming
geldig na een laagwissel of serverherstart. Boten: geen bron gevonden voor zo'n bericht; daar alleen na zelf meevaren
of een knop "hij legt nu aan".

## Wat vaststaat

- GEMETEN (bouwchat, DB2 TaxiPathNode pad 302): twee stops van 60 s, elk met een ArrivalEventID (105984, 105985).
- GEMETEN (mh-research): DB2 heeft route en stoptijd, geen rondetijd of snelheid voor schepen. De gegenereerde API-docs
  (642 bestanden, branch forever) hebben geen functie voor positie of dienstregeling van een transport; controles raakten.
- GEMETEN (mh-research, API-docs): tekst, afzender en GUID van een roep zijn alleen geheim in o.a. bazengevechten en
  dungeons. AFGELEID: bij een steiger leesbaar. Eén melding uit de beta van een geheime afzender, dus eerst testen.
- GEMETEN (bouwchat, opnieuw gedraaid): BroadcastText heeft 12 regels in elk van 11 talen, geen zeppelinroep (controle
  316348 raakte). Bewijst niets over het spel: zulke tekst komt van de server.
- GEMELD, niet gezien: een aankomstbericht bij de twee Skycutters. De hoorn klonk volgens een speler ook zonder
  zeppelin; boten blijven volgens spelers soms hangen. Een schema is dus geen bewijs dat hij er is.
- GEMETEN (mh-research): routes veranderen per build (Dalaran 70450, Mulgore 70450 en 70938). Een vaste lijst veroudert.

## Rondetijden — AFGELEID met ons eigen model, niet in het spel geklokt

Aannames: vorm van de bocht, welke eindstukken gevaren worden, gelijkmatig optrekken en remmen. Snelheid 30 en optrekken
1: uit de clientcache waar "cache" staat, anders aangenomen. De regel voor de eindstukken is afgesteld op gemeten
Classic Era-tijden van NauticusClassicResurrected (MIT; alleen vergeleken, geen getallen overgenomen).
Bouwchat draaide het verfijnde model opnieuw (`legs_locales.py`): zelfde getallen. Het eerdere `period_model.py` geeft
voor 301 en 11457 andere getallen (333,05 en 351,61) doordat het de regel voor sprongen op dezelfde kaart mist.

| Route (pad) | Ronde (s) | Snelheid |
|---|--:|---|
| Orgrimmar - Undercity (302) | 356,29 | cache |
| Grom'gol - Orgrimmar (285) | 303,47 | cache |
| Grom'gol - Undercity (301) | 335,30 | cache |
| Ratchet - Booty Bay (241) | 350,82 | cache |
| Menethil - Theramore (292) | 329,32 | aangenomen |
| Feathermoon - Forgotten Coast (303) | 317,04 | aangenomen |
| Rut'theran - Auberdine (293) | 316,10 | aangenomen |
| Menethil - Southshore - Auberdine (11167) | 486,21 | aangenomen |
| Auberdine - Stormwind (11616) | 247,07 | aangenomen, periode eerst controleren |
| Steamwheedle - Powderfuse (11391) | 271,04 | aangenomen, periode eerst controleren |
| Dalaran - Zephras (11398) | 358,82 | cache |
| Mulgore - Zephras (11457) | 378,67 | cache |

## De kleinste meting (alleen als Rob wil), ongeveer 12 minuten

1. Ga in Forever bij de zeppelintoren van Orgrimmar staan. Typ `/chatlog`.
2. Plak in chat (231 tekens; offline met een nep-client getest, niet in het spel):

   `/run local f=CreateFrame("Frame")f:RegisterEvent("CHAT_MSG_MONSTER_YELL")f:RegisterEvent("CHAT_MSG_MONSTER_SAY")f:SetScript("OnEvent",function(_,_,...)local t,n,_,_,_,_,_,_,_,_,_,g=...print(GetServerTime(),issecretvalue(t),n,g)end)`

3. Wacht tot dezelfde zeppelin twee keer heeft aangelegd. Maak een screenshot van de chat (de cijfers van de macro
   komen niet in het chatlog, alleen de roep zelf). Daarna `/reload`: dan is de macro weg.

Je ziet: servertijd, `false` = leesbaar, wie riep en zijn id. Komt er niets, dan roept daar niemand en vervalt de automatische
weg. Komt er wel iets: nog één aankomst na een laagwissel en één de volgende dag, vóór er iets gebouwd wordt.

## Licenties

Polestar en FlowUp niet geopend, Zygor niet gebruikt. Azeroth Tripview en Shortest Path Forever zijn GPLv3: niets
overgenomen. `tpn_speed.py` van de helper van 21 nov bevat getallen van Tripview: niet hergebruiken.
