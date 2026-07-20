# Midnight Helper 2.8.3

A small follow-up to 2.8.2, from testing on a second account: the Omnium Folio button had
one more way to go wrong, and a large block of text was still English for half the
supported languages.

## 📖 The Folio button could open the wrong window entirely

On a character whose minimap button is still parked on an older expansion's landing page,
pressing "Open rune window" opened that page instead — a Covenant Sanctum, not the runes.

The check was asking the landing page frame which expansion it was configured for. That
reports Midnight even while the button is set to something else, so the click went ahead
and delivered the wrong window. It now asks the button itself what it will actually open,
and says plainly when that is a garrison or covenant page rather than the Folio.

## 🌍 Translations

The healer boss tips, the dispel reference, the consumable ready board and the Mythic+
commands were only ever written in English and quietly fell back to it in every other
language. They are now translated into German, French, Spanish, Portuguese and Italian.

These are working translations rather than Blizzard's own in-game wording, so a term here
and there may not match the official one — if you spot one that reads wrong in your
language, please say so and it will be corrected.

## 🔧 Also

- Ritual Sites now read as tiers 1–6. Tier 6 had been live for some time while the text
  still said 1–5.
