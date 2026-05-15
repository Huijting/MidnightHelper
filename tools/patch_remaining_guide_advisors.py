#!/usr/bin/env python3
"""One-shot patch: add curated leveling advisor blocks + locale keys for all specs missing them."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GUIDE_DATA = ROOT / "Addons" / "GuideData.lua"
ENUS = ROOT / "Locales" / "enUS.lua"
NLNL = ROOT / "Locales" / "nlNL.lua"


def leveling_block(prefix: str) -> str:
    """Standard bracket layout matching existing curated specs (no talentMilestones)."""
    lines = ["\t\tleveling = {"]
    for bracket, rot_n, def_n in (
        (10, 3, 3),
        (30, 3, 2),
        (60, 3, 2),
        (80, 2, 2),
    ):
        lines.append(f"\t\t\t[{bracket}] = {{")
        lines.append("\t\t\t\trotation = {")
        for i in range(1, rot_n + 1):
            lines.append(f'\t\t\t\t\t"{prefix}_{bracket}_ROT_{i}",')
        lines.append("\t\t\t\t},")
        lines.append("\t\t\t\tdefensives = {")
        for i in range(1, def_n + 1):
            lines.append(f'\t\t\t\t\t"{prefix}_{bracket}_DEF_{i}",')
        lines.append("\t\t\t\t},")
        lines.append("\t\t\t\ttalentFocus = {")
        lines.append(f'\t\t\t\t\t"{prefix}_{bracket}_TAL_1",')
        lines.append(f'\t\t\t\t\t"{prefix}_{bracket}_TAL_2",')
        lines.append("\t\t\t\t},")
        lines.append("\t\t\t},")
    lines.append("\t\t},")
    return "\n".join(lines)


# Archetype advisor strings (English). Keys: {level}_{ROT|DEF|TAL}_{n}
ARCH = {
    "caster": {
        "10_ROT_1": "Maintain your main damage-over-time or setup effects while moving between packs.",
        "10_ROT_2": "Use your primary nuke on cooldown when resources allow—avoid long idle globals.",
        "10_ROT_3": "Save strong AoE tools for 3+ enemies grouped tightly.",
        "10_DEF_1": "Use your defensive barrier or shield before engaging larger pulls.",
        "10_DEF_2": "Crowd control and interrupts prevent more damage than reactive healing.",
        "10_DEF_3": "Create distance with snares/blinks when melee enemies threaten you.",
        "10_TAL_1": "Prioritize talents that smooth cast flow and resource generation.",
        "10_TAL_2": "Pick mobility or passive defense early if pulls routinely reach you.",
        "30_ROT_1": "Align major cooldowns with elites or dense packs instead of random presses.",
        "30_ROT_2": "Keep cleave decisions disciplined—do not scatter pulls before AoE lands.",
        "30_ROT_3": "Plan movement windows so instant casts cover repositioning.",
        "30_DEF_1": "Rotate personal cooldowns between pulls instead of stacking everything at once.",
        "30_DEF_2": "Hold one emergency button when routing chains of elites.",
        "30_TAL_1": "Favor talents that improve burst consistency on priority targets.",
        "30_TAL_2": "Add survivability nodes if elites routinely survive your opener.",
        "60_ROT_1": "Plan route tempo around major cooldown recharge timings.",
        "60_ROT_2": "Refresh maintenance effects cleanly before committing burst.",
        "60_ROT_3": "Use AoE windows aggressively in Delves and crowded quest hubs.",
        "60_DEF_1": "Enter scary pulls with a defensive plan and an escape route.",
        "60_DEF_2": "Silence or stun overlapping caster casts before they spike simultaneously.",
        "60_TAL_1": "Pick talents that reduce downtime between pulls.",
        "60_TAL_2": "Utility beats fragile optimizations while leveling.",
        "80_ROT_1": "Refine cooldown discipline around pull cadence rather than perfect parses.",
        "80_ROT_2": "Keep resource buffers healthy before movement-heavy segments.",
        "80_DEF_1": "Always reserve one defensive during elite chains.",
        "80_DEF_2": "Save interrupts for casts that actually threaten your route timing.",
        "80_TAL_1": "Shift toward your preferred endgame build while preserving solo stability.",
        "80_TAL_2": "Retain crowd control for caster-heavy segments.",
    },
    "melee": {
        "10_ROT_1": "Open priority targets from stealth or gap-close tools when available.",
        "10_ROT_2": "Spend finishing resources before they overcap; keep builders rolling.",
        "10_ROT_3": "Use AoE/cleave tools whenever multiple enemies stay in melee range.",
        "10_DEF_1": "Use short mitigation or heals proactively—not only at critical HP.",
        "10_DEF_2": "Kick dangerous casts early to reduce total damage taken.",
        "10_DEF_3": "Use slows/stuns to reduce melee uptime on dangerous enemies.",
        "10_TAL_1": "Prioritize talents that improve resource flow and sustained damage.",
        "10_TAL_2": "Mobility talents earn time faster than marginal single-target tweaks.",
        "30_ROT_1": "Align burst cooldowns with elites or grouped packs.",
        "30_ROT_2": "Maintain DoT or maintenance effects without letting them drop during chains.",
        "30_ROT_3": "Pool resources lightly before multi-target pulls.",
        "30_DEF_1": "Rotate defensive cooldowns instead of stacking during one fight.",
        "30_DEF_2": "Keep one emergency answer available when routing elites.",
        "30_TAL_1": "Favor talents that improve cleave and chain-pull pacing.",
        "30_TAL_2": "Add survival if incoming damage outpaces your recovery tools.",
        "60_ROT_1": "Plan pulls around major cooldown availability.",
        "60_ROT_2": "Avoid dead globals between builders and spenders during sustained fights.",
        "60_ROT_3": "Use AoE tools deliberately when density rewards them.",
        "60_DEF_1": "Enter larger pulls knowing which ability answers physical vs magic spikes.",
        "60_DEF_2": "Interrupt heals or nukes before they stall kill tempo.",
        "60_TAL_1": "Pick talents that smooth downtime between packs.",
        "60_TAL_2": "Utility crowd control beats greedy damage while leveling.",
        "80_ROT_1": "Refine sequencing so burst overlaps stacked packs reliably.",
        "80_ROT_2": "Keep resource rhythm tight entering mixed single-target/AoE transitions.",
        "80_DEF_1": "Start dangerous pulls with mitigation planned—not improvised.",
        "80_DEF_2": "Keep movement tools ready when mechanics overlap.",
        "80_TAL_1": "Move toward your preferred endgame path gradually.",
        "80_TAL_2": "Retain interrupts/stuns on caster-heavy routes.",
    },
    "tank": {
        "10_ROT_1": "Maintain your active mitigation rhythm during physical pressure.",
        "10_ROT_2": "Use AoE threat tools when rounding multi-target packs.",
        "10_ROT_3": "Spend resources into mitigation or sustain instead of overcapping.",
        "10_DEF_1": "Apply major mitigation effects early on scary elites.",
        "10_DEF_2": "Interrupt or silence dangerous casts before damage ramps.",
        "10_DEF_3": "Save one stronger cooldown for accidental overpulls.",
        "10_TAL_1": "Prioritize talents that smooth resource generation and mitigation uptime.",
        "10_TAL_2": "Pick utility that improves pull control when routing.",
        "30_ROT_1": "Layer mitigation instead of spamming everything in one global window.",
        "30_ROT_2": "Position packs so cleave hits efficiently without dragging hazards.",
        "30_ROT_3": "Use mobility to reposition—not to panic kite unless planned.",
        "30_DEF_1": "Rotate cooldowns across pulls to avoid empty defensive windows.",
        "30_DEF_2": "Track dangerous overlaps and assign an answer to each.",
        "30_TAL_1": "Favor talents that improve AoE stability while leveling.",
        "30_TAL_2": "Keep baseline mitigation talents until survivability feels steady.",
        "60_ROT_1": "Plan route pulls around sustained mitigation coverage.",
        "60_ROT_2": "Maintain threat while weaving defensive globals during spikes.",
        "60_ROT_3": "Use group utility to reduce incoming damage at the source.",
        "60_DEF_1": "Enter multi-elite pulls with a cooldown mentally earmarked.",
        "60_DEF_2": "Separate magic answers from physical answers when possible.",
        "60_TAL_1": "Pick talents that reduce cooldown drift during chain pulls.",
        "60_TAL_2": "Utility beats marginal damage while tanking open-world routes.",
        "80_ROT_1": "Refine opener sequencing so spikes meet mitigation windows.",
        "80_ROT_2": "Keep resource discipline—do not chase spikes reactively every pull.",
        "80_DEF_1": "Always reserve one major defensive during elite chains.",
        "80_DEF_2": "Use interrupts/stuns to prevent caster pulls from spiraling.",
        "80_TAL_1": "Shift toward your preferred endgame tank tree without dropping baseline safety.",
        "80_TAL_2": "Retain control tools that stabilize unpredictable routing.",
    },
    "healer": {
        "10_ROT_1": "While solo questing, weave efficient damage spells between heals to maintain pace.",
        "10_ROT_2": "Keep yourself topped between pulls—enter fights healthy.",
        "10_ROT_3": "Use instant mobility tools to skip bad positioning during ranged combat.",
        "10_DEF_1": "Press personal defensive cooldowns early during elite melee overlaps.",
        "10_DEF_2": "Crowd control dangerous enemies instead of trying to out-heal everything.",
        "10_DEF_3": "Interrupt caster bursts before they force inefficient healing.",
        "10_TAL_1": "Prioritize throughput talents that speed up solo killing without gutting survivability.",
        "10_TAL_2": "Take mobility or passive defense if you take frequent melee hits.",
        "30_ROT_1": "Align cooldowns with elites or dense packs for faster quest clears.",
        "30_ROT_2": "Maintain efficient HoT or shield uptime during prolonged fights.",
        "30_ROT_3": "Use AoE damage windows only when enemies remain grouped.",
        "30_DEF_1": "Rotate defensives across pulls instead of panic stacking.",
        "30_DEF_2": "Keep one emergency heal or immunity mentally reserved.",
        "30_TAL_1": "Favor talents that improve mana efficiency while leveling.",
        "30_TAL_2": "Add survivability if elites routinely force inefficient healing.",
        "60_ROT_1": "Plan Delve pulls knowing when you can contribute damage safely.",
        "60_ROT_2": "Keep healing globals smooth during movement-heavy encounters.",
        "60_ROT_3": "Use group utility to reduce damage rather than only reacting afterward.",
        "60_DEF_1": "Enter scary pulls with a defensive plan for yourself first.",
        "60_DEF_2": "Silence/stun overlapping casts during chaotic packs.",
        "60_TAL_1": "Pick talents that reduce downtime between pulls.",
        "60_TAL_2": "Utility beats fragile optimizations during leveling routes.",
        "80_ROT_1": "Refine cooldown cadence around stacked pulls and predictable elites.",
        "80_ROT_2": "Preserve mana or resource buffers before intensive segments.",
        "80_DEF_1": "Always reserve one defensive during elite chains.",
        "80_DEF_2": "Track dangerous overlaps and assign answers proactively.",
        "80_TAL_1": "Shift toward your preferred endgame healing path gradually.",
        "80_TAL_2": "Retain crowd control for caster-heavy segments.",
    },
    "support": {
        "10_ROT_1": "Maintain your core augmentation buffs before engaging packs.",
        "10_ROT_2": "Use damaging globals to contribute while solo—do not only buff thin air.",
        "10_ROT_3": "Save stronger AoE/support windows for grouped enemies.",
        "10_DEF_1": "Use defensive mobility early when melee enemies connect.",
        "10_DEF_2": "Interrupt dangerous casts to reduce pressure on your route.",
        "10_DEF_3": "Keep distance using slows or knockbacks when positioning matters.",
        "10_TAL_1": "Prioritize talents that stabilize buff uptime and ease of application.",
        "10_TAL_2": "Pick mobility or defense early if routing is dangerous.",
        "30_ROT_1": "Align major cooldowns with elites or dense packs.",
        "30_ROT_2": "Refresh buff discipline—avoid dropping coverage during chains.",
        "30_ROT_3": "Plan movement so support spells land on the targets that matter.",
        "30_DEF_1": "Rotate personal cooldowns instead of stacking everything at once.",
        "30_DEF_2": "Hold one defensive when chaining elites.",
        "30_TAL_1": "Favor talents that improve group tempo when allies join.",
        "30_TAL_2": "Keep survivability until incoming pressure stabilizes.",
        "60_ROT_1": "Plan route pulls around cooldown recharge timings.",
        "60_ROT_2": "Use AoE windows aggressively when packs stack.",
        "60_ROT_3": "Keep selfish survivability—dead supports contribute nothing.",
        "60_DEF_1": "Enter scary pulls knowing your escape plan.",
        "60_DEF_2": "Silence or CC caster overlaps before simultaneous spikes.",
        "60_TAL_1": "Pick talents that reduce downtime between pulls.",
        "60_TAL_2": "Utility beats marginal theoretical gains while leveling.",
        "80_ROT_1": "Refine sequencing toward stacked pulls and predictable elites.",
        "80_ROT_2": "Preserve resource buffers before burst-heavy segments.",
        "80_DEF_1": "Always reserve one defensive during elite chains.",
        "80_DEF_2": "Save interrupts for casts that threaten route timing.",
        "80_TAL_1": "Shift toward your preferred endgame Augmentation path steadily.",
        "80_TAL_2": "Retain crowd control for caster-heavy segments.",
    },
}

ARCH_NL = {
    "caster": {
        "10_ROT_1": "Handhaaf je belangrijkste DoT/setup-effecten tijdens het verplaatsen tussen packs.",
        "10_ROT_2": "Gebruik je primaire nuke op cooldown als resources het toelaten — voorkom lange idle globals.",
        "10_ROT_3": "Bewaar sterke AoE-tools voor 3+ vijanden die strak gegroepeerd blijven.",
        "10_DEF_1": "Gebruik barrier/shield vóór grotere pulls.",
        "10_DEF_2": "CC en interrupts voorkomen meer schade dan reactieve heals.",
        "10_DEF_3": "Creëer afstand met slows/blinks als melee vijanden dreigen.",
        "10_TAL_1": "Prioriteer talents die cast-flow en resource-gen glad maken.",
        "10_TAL_2": "Kies vroeg mobiliteit of passieve defense als pulls je bereiken.",
        "30_ROT_1": "Lijn grote cooldowns uit met elites of dichte packs.",
        "30_ROT_2": "Houd cleave-beslissingen strak — verspreid pulls niet vóór AoE landt.",
        "30_ROT_3": "Plan movement-zodat instant casts repositionering dekken.",
        "30_DEF_1": "Wissel persoonlijke cooldowns tussen pulls i.p.v. alles tegelijk.",
        "30_DEF_2": "Houd één noodknop vrij bij elite-ketens.",
        "30_TAL_1": "Geef de voorkeur aan talents die burst-consistentie op priority verbeteren.",
        "30_TAL_2": "Voeg survivability toe als elites je opener routinematig overleven.",
        "60_ROT_1": "Plan route-tempo rond recharge van grote cooldowns.",
        "60_ROT_2": "Ververs maintenance-effecten netjes vóór burst.",
        "60_ROT_3": "Gebruik AoE-vensters agressief in Delves en drukke quest hubs.",
        "60_DEF_1": "Ga scary pulls in met defensief plan en vlucht-route.",
        "60_DEF_2": "Silence of stun overlappende caster-casts vóór gelijktijdige pieken.",
        "60_TAL_1": "Kies talents die downtime tussen pulls verlagen.",
        "60_TAL_2": "Utility verslaat fragiele optimalisaties tijdens leveling.",
        "80_ROT_1": "Verfijn cooldown-discipline rond pull-cadans i.p.v. perfecte parses.",
        "80_ROT_2": "Houd resource-buffers gezond vóór movement-zware segmenten.",
        "80_DEF_1": "Reserveer altijd één defensief tijdens elite-ketens.",
        "80_DEF_2": "Bewaar interrupts voor casts die route-tempo bedreigen.",
        "80_TAL_1": "Verschuif naar je gewenste endgame-build met behoud van solo-stabiliteit.",
        "80_TAL_2": "Behoud crowd control voor caster-zware segmenten.",
    },
    "melee": {
        "10_ROT_1": "Open priority-doelen vanuit stealth of gap-close waar beschikbaar.",
        "10_ROT_2": "Spend finishing-resources vóór overcappen; houd builders gaande.",
        "10_ROT_3": "Gebruik AoE/cleave zodra meerdere vijanden in melee blijven.",
        "10_DEF_1": "Gebruik korte mitigatie of heals proactief — niet alleen bij kritieke HP.",
        "10_DEF_2": "Kick gevaarlijke casts vroeg om totale schade te verlagen.",
        "10_DEF_3": "Gebruik slows/stuns om melee-uptime op gevaarlijke vijanden te verlagen.",
        "10_TAL_1": "Prioriteer talents die resource-flow en sustained schade verbeteren.",
        "10_TAL_2": "Mobiliteitstalents winnen tijd sneller dan marginale ST-tweaks.",
        "30_ROT_1": "Lijn burst-cooldowns uit met elites of gegroepeerde packs.",
        "30_ROT_2": "Handhaaf DoT/maintenance zonder drops tijdens ketens.",
        "30_ROT_3": "Pool resources licht vóór multi-target pulls.",
        "30_DEF_1": "Wissel defensieve cooldowns af i.p.v. stapelen in één fight.",
        "30_DEF_2": "Houd één nood-antwoord bij elite-routing.",
        "30_TAL_1": "Geef de voorkeur aan talents die cleave en chain-pull tempo verbeteren.",
        "30_TAL_2": "Voeg survival toe als inkomende schade je recovery overstijgt.",
        "60_ROT_1": "Plan pulls rond beschikbaarheid van grote cooldowns.",
        "60_ROT_2": "Voorkom dode globals tussen builders en spenders.",
        "60_ROT_3": "Gebruik AoE bewust als density het loont.",
        "60_DEF_1": "Ga grotere pulls in wetend welke ability fysiek vs magisch beantwoordt.",
        "60_DEF_2": "Interrupt heals of nukes voordat kill-tempo stokt.",
        "60_TAL_1": "Kies talents die downtime tussen packs verlagen.",
        "60_TAL_2": "Utility CC verslaat greedy schade tijdens leveling.",
        "80_ROT_1": "Verfijn sequencing zodat burst overlapt met gestapelde packs.",
        "80_ROT_2": "Houd resource-ritme strak bij gemengde ST/AoE-overgangen.",
        "80_DEF_1": "Start gevaarlijke pulls met geplande mitigatie.",
        "80_DEF_2": "Houd movement gereed bij overlappende mechanics.",
        "80_TAL_1": "Ga geleidelijk naar je gewenste endgame-pad.",
        "80_TAL_2": "Behoud interrupts/stuns op caster-routes.",
    },
    "tank": {
        "10_ROT_1": "Handhaaf actieve mitigatie-ritme bij fysieke druk.",
        "10_ROT_2": "Gebruik AoE-threat bij multi-target packs.",
        "10_ROT_3": "Spend resources in mitigatie of sustain i.p.v. overcapen.",
        "10_DEF_1": "Zet grote mitigatie vroeg op scary elites.",
        "10_DEF_2": "Interrupt of silence gevaarlijke casts voordat schade oploopt.",
        "10_DEF_3": "Bewaar één sterkere cooldown voor accidentele overpulls.",
        "10_TAL_1": "Prioriteer talents die resource-gen en mitigatie-uptime glad maken.",
        "10_TAL_2": "Utility die pull-control verbetert bij routing.",
        "30_ROT_1": "Leg mitigatie gelaagd i.p.v. alles in één global.",
        "30_ROT_2": "Positioneer packs zodat cleave efficiënt raakt zonder hazards.",
        "30_ROT_3": "Gebruik mobiliteit om te repositioneren — niet als paniek-kite tenzij gepland.",
        "30_DEF_1": "Wissel cooldowns over pulls om lege defensive vensters te voorkomen.",
        "30_DEF_2": "Houd gevaarlijke overlaps bij en wijs elk een antwoord toe.",
        "30_TAL_1": "Geef de voorkeur aan talents die AoE-stabiliteit verbeteren.",
        "30_TAL_2": "Behoud basis-mitigatie tot overleving stabiel aanvoelt.",
        "60_ROT_1": "Plan pulls rond aanhoudende mitigatie-dekking.",
        "60_ROT_2": "Handhaaf threat terwijl je defensive globals bij pieken weeft.",
        "60_ROT_3": "Gebruik group utility om schade bij de bron te verlagen.",
        "60_DEF_1": "Ga multi-elite pulls in met een mentally gereserveerde cooldown.",
        "60_DEF_2": "Scheid magische antwoorden van fysieke waar mogelijk.",
        "60_TAL_1": "Kies talents die cooldown-drift bij chain-pulls verlagen.",
        "60_TAL_2": "Utility verslaat marginale schade tijdens open-world tank-routes.",
        "80_ROT_1": "Verfijn opener-sequencing zodat pieken mitigatie-vensters treffen.",
        "80_ROT_2": "Houd resource-discipline — jaag niet reactief elke piek na.",
        "80_DEF_1": "Reserveer altijd één grote defensive tijdens elite-ketens.",
        "80_DEF_2": "Gebruik interrupts/stuns zodat caster-pulls niet escaleren.",
        "80_TAL_1": "Ga naar je gewenste endgame tank-tree zonder basisveiligheid te slopen.",
        "80_TAL_2": "Behoud control-tools voor onvoorspelbare routing.",
    },
    "healer": {
        "10_ROT_1": "Solo: weef efficiënte damage-spells tussen heals voor tempo.",
        "10_ROT_2": "Top jezelf tussen pulls — start fights gezond.",
        "10_ROT_3": "Gebruik instant mobility om slechte positioning te vermijden.",
        "10_DEF_1": "Zet persoonlijke defensives vroeg bij elite-melee-overlaps.",
        "10_DEF_2": "CC gevaarlijke vijanden i.p.v. alles te willen out-healen.",
        "10_DEF_3": "Interrupt caster-bursts voordat ze inefficient healing forceren.",
        "10_TAL_1": "Prioriteer throughput-talents die solo kills versnellen zonder survivability te slopen.",
        "10_TAL_2": "Neem mobiliteit of passieve defense bij frequente melee-hits.",
        "30_ROT_1": "Lijn cooldowns uit met elites of dichte packs.",
        "30_ROT_2": "Handhaaf efficiënte HoT/shield-uptime tijdens langere fights.",
        "30_ROT_3": "Gebruik AoE-schade alleen als vijanden gegroepeerd blijven.",
        "30_DEF_1": "Wissel defensives over pulls i.p.v. paniek-stapelen.",
        "30_DEF_2": "Houd één noodheal of immunity mental gereserveerd.",
        "30_TAL_1": "Geef de voorkeur aan talents die mana-efficiëntie verbeteren.",
        "30_TAL_2": "Voeg survivability toe als elites inefficient healing forceren.",
        "60_ROT_1": "Plan Delve-pulls wetend wanneer je veilig damage kunt bijdragen.",
        "60_ROT_2": "Houd healing globals soepel tijdens movement-heavy encounters.",
        "60_ROT_3": "Gebruik group utility om schade te verminderen i.p.v. alleen te reacten.",
        "60_DEF_1": "Ga scary pulls in met plan voor jezelf eerst.",
        "60_DEF_2": "Silence/stun overlappende casts bij chaos-packs.",
        "60_TAL_1": "Kies talents die downtime tussen pulls verlagen.",
        "60_TAL_2": "Utility verslaat fragiele optimalisaties tijdens routes.",
        "80_ROT_1": "Verfijn cooldown-cadans rond gestapelde pulls en voorspelbare elites.",
        "80_ROT_2": "Behoud mana/resource buffers vóór intensieve segmenten.",
        "80_DEF_1": "Reserveer altijd één defensief tijdens elite-ketens.",
        "80_DEF_2": "Track overlaps en wijs antwoorden proactief toe.",
        "80_TAL_1": "Ga geleidelijk naar je gewenste endgame healing-pad.",
        "80_TAL_2": "Behoud crowd control voor caster-segmenten.",
    },
    "support": {
        "10_ROT_1": "Handhaaf kern augmentation-buffs vóór engagement.",
        "10_ROT_2": "Gebruik schade-globals solo — buff niet zonder bijdrage.",
        "10_ROT_3": "Bewaar sterkere AoE/support-vensters voor gegroepeerde vijanden.",
        "10_DEF_1": "Gebruik defensive mobility vroeg als melee raakt.",
        "10_DEF_2": "Interrupt gevaarlijke casts om druk op je route te verlagen.",
        "10_DEF_3": "Houd afstand met slows/knockbacks als positioning telt.",
        "10_TAL_1": "Prioriteer talents die buff-uptime en toepassing stabiliseren.",
        "10_TAL_2": "Mobiliteit of defense vroeg als routing gevaarlijk is.",
        "30_ROT_1": "Lijn grote cooldowns uit met elites of dichte packs.",
        "30_ROT_2": "Buff-discipline — voorkom coverage-drops tijdens ketens.",
        "30_ROT_3": "Plan movement zodat support-spells de juiste doelen raken.",
        "30_DEF_1": "Wissel persoonlijke cooldowns af i.p.v. alles stapelen.",
        "30_DEF_2": "Houd één defensief bij elite-ketens.",
        "30_TAL_1": "Geef de voorkeur aan talents die groepstempo verbeteren met allies.",
        "30_TAL_2": "Behoud survivability tot druk stabiel aanvoelt.",
        "60_ROT_1": "Plan pulls rond cooldown-recharge.",
        "60_ROT_2": "Gebruik AoE-vensters agressief bij gestapelde packs.",
        "60_ROT_3": "Egoïstische survivability — dode supports leveren niets.",
        "60_DEF_1": "Ga scary pulls in met escape-plan.",
        "60_DEF_2": "Silence/CC caster-overlaps vóór gelijktijdige pieken.",
        "60_TAL_1": "Kies talents die downtime tussen pulls verlagen.",
        "60_TAL_2": "Utility verslaat marginale theoretische wins tijdens leveling.",
        "80_ROT_1": "Verfijn sequencing naar gestapelde pulls en voorspelbare elites.",
        "80_ROT_2": "Behoud resource buffers vóór burst-zware segmenten.",
        "80_DEF_1": "Reserveer altijd één defensief tijdens elite-ketens.",
        "80_DEF_2": "Bewaar interrupts voor casts die route-tempo bedreigen.",
        "80_TAL_1": "Ga stap voor stap naar je gewenste Augmentation-endgame-pad.",
        "80_TAL_2": "Behoud crowd control voor caster-zware segmenten.",
    },
}


# (unique_title_line, old_stats_lua_fragment, stats_key_en, prefix, archetype)
PATCHES: list[tuple[str, str, str, str, str]] = [
    ('title = "Balance Guide"', '\t\tstats = "|cffffcc00Intellect|r is je belangrijkste punt, daarna focus je op |cffffcc00Haste|r en |cffffcc00Mastery|r.",', "GUIDE_STATS_DRUID_BALANCE", "GUIDE_ADVISOR_DRUID_BALANCE", "caster"),
    ('title = "Feral Guide"', '\t\tstats = "|cffffcc00Agility|r staat bovenaan, gevolgd door |cffffcc00Mastery|r en |cffffcc00Critical Strike|r voor hardere bleeds.",', "GUIDE_STATS_DRUID_FERAL", "GUIDE_ADVISOR_DRUID_FERAL", "melee"),
    ('title = "Restoration Guide"', "\t\tstats = \"|cffffcc00Intellect|r is je hoofdstat als healer — wapen en sieraden met Int boven alles.\\n\"\n\t\t\t.. \"|cffffcc00Mastery|r en |cffffcc00Haste|r maken je heals sterker/sneller; |cffffcc00Versatility|r is altijd nuttig.\\n\"\n\t\t\t.. \"|cffffcc00Critical Strike|r geeft grotere heals — verdeel secundair stats volgens de Icy Veins-gids.\",", "GUIDE_STATS_DRUID_RESTO", "GUIDE_ADVISOR_DRUID_RESTO", "healer"),
    ('title = "Blood Death Knight Guide"', '\t\tstats = "|cffffcc00Strength|r is je basis, focus daarna op |cffffcc00Haste|r voor snellere runes en |cffffcc00Versatility|r voor minder schade.",', "GUIDE_STATS_DK_BLOOD", "GUIDE_ADVISOR_DK_BLOOD", "tank"),
    ('title = "Frost Death Knight Guide"', '\t\tstats = "|cffffcc00Strength|r eerst, daarna |cffffcc00Mastery|r voor meer Frost schade en |cffffcc00Critical Strike|r voor harde klappen.",', "GUIDE_STATS_DK_FROST", "GUIDE_ADVISOR_DK_FROST", "melee"),
    ('title = "Unholy Death Knight Guide"', '\t\tstats = "|cffffcc00Strength|r is leidend, gevolgd door |cffffcc00Mastery|r om de schade van je ondoden en ziektes te verhogen.",', "GUIDE_STATS_DK_UNHOLY", "GUIDE_ADVISOR_DK_UNHOLY", "melee"),
    ('title = "Devourer Demon Hunter Guide"', '\t\tstats = "|cffffcc00Intellect|r > |cffffcc00Mastery|r > |cffffcc00Crit|r",', "GUIDE_STATS_DH_DEVOURER", "GUIDE_ADVISOR_DH_DEVOURER", "caster"),
    ('title = "Devastation Evoker Guide"', '\t\tstats = "|cffffcc00Intellect|r > |cffffcc00Mastery|r > |cffffcc00Haste|r.",', "GUIDE_STATS_EVOKER_DEVASTATION", "GUIDE_ADVISOR_EVOKER_DEVASTATION", "caster"),
    ('title = "Preservation Evoker Guide"', '\t\tstats = "|cffffcc00Intellect|r > |cffffcc00Critical Strike|r > |cffffcc00Mastery|r.",', "GUIDE_STATS_EVOKER_PRESERVATION", "GUIDE_ADVISOR_EVOKER_PRESERVATION", "healer"),
    ('title = "Augmentation Evoker Guide"', '\t\tstats = "|cffffcc00Intellect|r > |cffffcc00Mastery|r > |cffffcc00Versatility|r.",', "GUIDE_STATS_EVOKER_AUGMENTATION", "GUIDE_ADVISOR_EVOKER_AUGMENTATION", "support"),
    ('title = "Survival Hunter Guide"', '\t\tstats = "|cffffcc00Agility|r > |cffffcc00Haste|r > |cffffcc00Mastery|r > |cffffcc00Crit|r > |cffffcc00Versatility|r",', "GUIDE_STATS_HUNTER_SURV", "GUIDE_ADVISOR_HUNTER_SURV", "melee"),
    ('title = "Arcane Mage Guide"', '\t\tstats = "|cffffcc00Intellect|r > |cffffcc00Mastery|r > |cffffcc00Haste|r",', "GUIDE_STATS_MAGE_ARCANE", "GUIDE_ADVISOR_MAGE_ARCANE", "caster"),
    ('title = "Frost Mage Guide"', '\t\tstats = "|cffffcc00Intellect|r > |cffffcc00Crit (tot 33%)|r > |cffffcc00Haste|r",', "GUIDE_STATS_MAGE_FROST", "GUIDE_ADVISOR_MAGE_FROST", "caster"),
    ('title = "Brewmaster Monk Guide"', '\t\tstats = "|cffffcc00Agility|r > |cffffcc00Versatility|r > |cffffcc00Mastery|r",', "GUIDE_STATS_MONK_BREWMASTER", "GUIDE_ADVISOR_MONK_BREWMASTER", "tank"),
    ('title = "Mistweaver Monk Guide"', '\t\tstats = "|cffffcc00Intellect|r > |cffffcc00Haste|r > |cffffcc00Mastery|r",', "GUIDE_STATS_MONK_MISTWEAVER", "GUIDE_ADVISOR_MONK_MISTWEAVER", "healer"),
    ('title = "Holy Paladin Guide"', '\t\tstats = "|cffffcc00Intellect|r > |cffffcc00Haste|r > |cffffcc00Critical Strike|r",', "GUIDE_STATS_PALADIN_HOLY", "GUIDE_ADVISOR_PALADIN_HOLY", "healer"),
    ('title = "Discipline Priest Guide"', '\t\tstats = "|cffffcc00Intellect|r > |cffffcc00Haste|r > |cffffcc00Critical Strike|r",', "GUIDE_STATS_PRIEST_DISCIPLINE", "GUIDE_ADVISOR_PRIEST_DISCIPLINE", "healer"),
    ('title = "Holy Priest Guide"', '\t\tstats = "|cffffcc00Intellect|r > |cffffcc00Mastery|r > |cffffcc00Critical Strike|r",', "GUIDE_STATS_PRIEST_HOLY", "GUIDE_ADVISOR_PRIEST_HOLY", "healer"),
    ('title = "Assassination Rogue Guide"', '\t\tstats = "|cffffcc00Agility|r > |cffffcc00Mastery|r > |cffffcc00Haste|r",', "GUIDE_STATS_ROGUE_ASSASSINATION", "GUIDE_ADVISOR_ROGUE_ASSASSINATION", "melee"),
    ('title = "Subtlety Rogue Guide"', '\t\tstats = "|cffffcc00Agility|r > |cffffcc00Mastery|r > |cffffcc00Versatility|r",', "GUIDE_STATS_ROGUE_SUBTLETY", "GUIDE_ADVISOR_ROGUE_SUBTLETY", "melee"),
    ('title = "Elemental Shaman Guide"', '\t\tstats = "|cffffcc00Intellect|r > |cffffcc00Haste|r > |cffffcc00Mastery|r",', "GUIDE_STATS_SHAMAN_ELEMENTAL", "GUIDE_ADVISOR_SHAMAN_ELEMENTAL", "caster"),
    ('title = "Restoration Shaman Guide"', '\t\tstats = "|cffffcc00Intellect|r > |cffffcc00Versatility|r > |cffffcc00Critical Strike|r",', "GUIDE_STATS_SHAMAN_RESTO", "GUIDE_ADVISOR_SHAMAN_RESTO", "healer"),
    ('title = "Demonology Warlock Guide"', '\t\tstats = "|cffffcc00Intellect|r > |cffffcc00Haste|r > |cffffcc00Mastery|r",', "GUIDE_STATS_WARLOCK_DEMONOLOGY", "GUIDE_ADVISOR_WARLOCK_DEMONOLOGY", "caster"),
    ('title = "Destruction Warlock Guide"', '\t\tstats = "|cffffcc00Intellect|r > |cffffcc00Haste|r > |cffffcc00Critical Strike|r",', "GUIDE_STATS_WARLOCK_DESTRUCTION", "GUIDE_ADVISOR_WARLOCK_DESTRUCTION", "caster"),
    ('title = "Arms Warrior Guide"', '\t\tstats = "|cffffcc00Strength|r > |cffffcc00Critical Strike|r > |cffffcc00Haste|r",', "GUIDE_STATS_WARRIOR_ARMS", "GUIDE_ADVISOR_WARRIOR_ARMS", "melee"),
    ('title = "Protection Warrior Guide"', '\t\tstats = "|cffffcc00Strength|r > |cffffcc00Haste|r > |cffffcc00Versatility|r",', "GUIDE_STATS_WARRIOR_PROTECTION", "GUIDE_ADVISOR_WARRIOR_PROTECTION", "tank"),
]

STATS_VALUES_EN: dict[str, str] = {
    "GUIDE_STATS_DRUID_BALANCE": "|cffffcc00Intellect|r > |cffffcc00Haste|r > |cffffcc00Mastery|r",
    "GUIDE_STATS_DRUID_FERAL": "|cffffcc00Agility|r > |cffffcc00Mastery|r > |cffffcc00Critical Strike|r",
    "GUIDE_STATS_DRUID_RESTO": "|cffffcc00Intellect|r > |cffffcc00Mastery|r > |cffffcc00Haste|r — |cffffcc00Versatility|r and |cffffcc00Critical Strike|r are strong secondary picks.",
    "GUIDE_STATS_DK_BLOOD": "|cffffcc00Strength|r > |cffffcc00Haste|r > |cffffcc00Versatility|r",
    "GUIDE_STATS_DK_FROST": "|cffffcc00Strength|r > |cffffcc00Mastery|r > |cffffcc00Critical Strike|r",
    "GUIDE_STATS_DK_UNHOLY": "|cffffcc00Strength|r > |cffffcc00Mastery|r > |cffffcc00Haste|r",
    "GUIDE_STATS_DH_DEVOURER": "|cffffcc00Intellect|r > |cffffcc00Mastery|r > |cffffcc00Crit|r",
    "GUIDE_STATS_EVOKER_DEVASTATION": "|cffffcc00Intellect|r > |cffffcc00Mastery|r > |cffffcc00Haste|r.",
    "GUIDE_STATS_EVOKER_PRESERVATION": "|cffffcc00Intellect|r > |cffffcc00Critical Strike|r > |cffffcc00Mastery|r.",
    "GUIDE_STATS_EVOKER_AUGMENTATION": "|cffffcc00Intellect|r > |cffffcc00Mastery|r > |cffffcc00Versatility|r.",
    "GUIDE_STATS_HUNTER_SURV": "|cffffcc00Agility|r > |cffffcc00Haste|r > |cffffcc00Mastery|r > |cffffcc00Crit|r > |cffffcc00Versatility|r",
    "GUIDE_STATS_MAGE_ARCANE": "|cffffcc00Intellect|r > |cffffcc00Mastery|r > |cffffcc00Haste|r",
    "GUIDE_STATS_MAGE_FROST": "|cffffcc00Intellect|r > |cffffcc00Crit|r (to ~33%) > |cffffcc00Haste|r",
    "GUIDE_STATS_MONK_BREWMASTER": "|cffffcc00Agility|r > |cffffcc00Versatility|r > |cffffcc00Mastery|r",
    "GUIDE_STATS_MONK_MISTWEAVER": "|cffffcc00Intellect|r > |cffffcc00Haste|r > |cffffcc00Mastery|r",
    "GUIDE_STATS_PALADIN_HOLY": "|cffffcc00Intellect|r > |cffffcc00Haste|r > |cffffcc00Critical Strike|r",
    "GUIDE_STATS_PRIEST_DISCIPLINE": "|cffffcc00Intellect|r > |cffffcc00Haste|r > |cffffcc00Critical Strike|r",
    "GUIDE_STATS_PRIEST_HOLY": "|cffffcc00Intellect|r > |cffffcc00Mastery|r > |cffffcc00Critical Strike|r",
    "GUIDE_STATS_ROGUE_ASSASSINATION": "|cffffcc00Agility|r > |cffffcc00Mastery|r > |cffffcc00Haste|r",
    "GUIDE_STATS_ROGUE_SUBTLETY": "|cffffcc00Agility|r > |cffffcc00Mastery|r > |cffffcc00Versatility|r",
    "GUIDE_STATS_SHAMAN_ELEMENTAL": "|cffffcc00Intellect|r > |cffffcc00Haste|r > |cffffcc00Mastery|r",
    "GUIDE_STATS_SHAMAN_RESTO": "|cffffcc00Intellect|r > |cffffcc00Versatility|r > |cffffcc00Critical Strike|r",
    "GUIDE_STATS_WARLOCK_DEMONOLOGY": "|cffffcc00Intellect|r > |cffffcc00Haste|r > |cffffcc00Mastery|r",
    "GUIDE_STATS_WARLOCK_DESTRUCTION": "|cffffcc00Intellect|r > |cffffcc00Haste|r > |cffffcc00Critical Strike|r",
    "GUIDE_STATS_WARRIOR_ARMS": "|cffffcc00Strength|r > |cffffcc00Critical Strike|r > |cffffcc00Haste|r",
    "GUIDE_STATS_WARRIOR_PROTECTION": "|cffffcc00Strength|r > |cffffcc00Haste|r > |cffffcc00Versatility|r",
}

STATS_VALUES_NL: dict[str, str] = {
    "GUIDE_STATS_DRUID_BALANCE": "|cffffcc00Intellect|r > |cffffcc00Haste|r > |cffffcc00Mastery|r",
    "GUIDE_STATS_DRUID_FERAL": "|cffffcc00Agility|r > |cffffcc00Mastery|r > |cffffcc00Critical Strike|r",
    "GUIDE_STATS_DRUID_RESTO": "|cffffcc00Intellect|r > |cffffcc00Mastery|r > |cffffcc00Haste|r — |cffffcc00Versatility|r en |cffffcc00Critical Strike|r zijn sterke secundaire keuzes.",
    "GUIDE_STATS_DK_BLOOD": "|cffffcc00Strength|r > |cffffcc00Haste|r > |cffffcc00Versatility|r",
    "GUIDE_STATS_DK_FROST": "|cffffcc00Strength|r > |cffffcc00Mastery|r > |cffffcc00Critical Strike|r",
    "GUIDE_STATS_DK_UNHOLY": "|cffffcc00Strength|r > |cffffcc00Mastery|r > |cffffcc00Haste|r",
    "GUIDE_STATS_DH_DEVOURER": "|cffffcc00Intellect|r > |cffffcc00Mastery|r > |cffffcc00Crit|r",
    "GUIDE_STATS_EVOKER_DEVASTATION": "|cffffcc00Intellect|r > |cffffcc00Mastery|r > |cffffcc00Haste|r.",
    "GUIDE_STATS_EVOKER_PRESERVATION": "|cffffcc00Intellect|r > |cffffcc00Critical Strike|r > |cffffcc00Mastery|r.",
    "GUIDE_STATS_EVOKER_AUGMENTATION": "|cffffcc00Intellect|r > |cffffcc00Mastery|r > |cffffcc00Versatility|r.",
    "GUIDE_STATS_HUNTER_SURV": "|cffffcc00Agility|r > |cffffcc00Haste|r > |cffffcc00Mastery|r > |cffffcc00Crit|r > |cffffcc00Versatility|r",
    "GUIDE_STATS_MAGE_ARCANE": "|cffffcc00Intellect|r > |cffffcc00Mastery|r > |cffffcc00Haste|r",
    "GUIDE_STATS_MAGE_FROST": "|cffffcc00Intellect|r > |cffffcc00Crit|r (tot ~33%) > |cffffcc00Haste|r",
    "GUIDE_STATS_MONK_BREWMASTER": "|cffffcc00Agility|r > |cffffcc00Versatility|r > |cffffcc00Mastery|r",
    "GUIDE_STATS_MONK_MISTWEAVER": "|cffffcc00Intellect|r > |cffffcc00Haste|r > |cffffcc00Mastery|r",
    "GUIDE_STATS_PALADIN_HOLY": "|cffffcc00Intellect|r > |cffffcc00Haste|r > |cffffcc00Critical Strike|r",
    "GUIDE_STATS_PRIEST_DISCIPLINE": "|cffffcc00Intellect|r > |cffffcc00Haste|r > |cffffcc00Critical Strike|r",
    "GUIDE_STATS_PRIEST_HOLY": "|cffffcc00Intellect|r > |cffffcc00Mastery|r > |cffffcc00Critical Strike|r",
    "GUIDE_STATS_ROGUE_ASSASSINATION": "|cffffcc00Agility|r > |cffffcc00Mastery|r > |cffffcc00Haste|r",
    "GUIDE_STATS_ROGUE_SUBTLETY": "|cffffcc00Agility|r > |cffffcc00Mastery|r > |cffffcc00Versatility|r",
    "GUIDE_STATS_SHAMAN_ELEMENTAL": "|cffffcc00Intellect|r > |cffffcc00Haste|r > |cffffcc00Mastery|r",
    "GUIDE_STATS_SHAMAN_RESTO": "|cffffcc00Intellect|r > |cffffcc00Versatility|r > |cffffcc00Critical Strike|r",
    "GUIDE_STATS_WARLOCK_DEMONOLOGY": "|cffffcc00Intellect|r > |cffffcc00Haste|r > |cffffcc00Mastery|r",
    "GUIDE_STATS_WARLOCK_DESTRUCTION": "|cffffcc00Intellect|r > |cffffcc00Haste|r > |cffffcc00Critical Strike|r",
    "GUIDE_STATS_WARRIOR_ARMS": "|cffffcc00Strength|r > |cffffcc00Critical Strike|r > |cffffcc00Haste|r",
    "GUIDE_STATS_WARRIOR_PROTECTION": "|cffffcc00Strength|r > |cffffcc00Haste|r > |cffffcc00Versatility|r",
}


def inject_after_consumables(section_text: str, prefix: str) -> str:
    """Insert leveling block between consumables closing and theme."""
    lb = leveling_block(prefix)
    needle = "\t\t},\n\t\ttheme = {"
    if needle not in section_text:
        raise RuntimeError("Could not find consumables→theme anchor in section")
    if "\t\tleveling = {" in section_text:
        return section_text  # already patched
    return section_text.replace(needle, "\t\t},\n" + lb + "\n\t\ttheme = {", 1)


def extract_section(text: str, title_marker: str) -> tuple[int, int, str]:
    """Return start, end indices of spec table entry containing title_marker."""
    pos = text.find(title_marker)
    if pos < 0:
        raise RuntimeError(f"Title marker not found: {title_marker}")
    segment = text[:pos]
    matches = list(re.finditer(r"^\t\[(\d+)\] = \{", segment, flags=re.MULTILINE))
    if not matches:
        raise RuntimeError(f"No spec header before {title_marker}")
    m = matches[-1]
    start = m.start()
    open_brace = m.end() - 1
    depth = 0
    i = open_brace
    while i < len(text):
        c = text[i]
        if c == "{":
            depth += 1
        elif c == "}":
            depth -= 1
            if depth == 0:
                return start, i + 1, text[start : i + 1]
        i += 1
    raise RuntimeError(f"Unbalanced braces for {title_marker}")


def patch_guide_data(text: str) -> str:
    for title_marker, old_stats, stats_key, prefix, arch in PATCHES:
        s, e, section = extract_section(text, title_marker)
        new_section = section
        if old_stats:
            if old_stats not in new_section:
                raise RuntimeError(f"old_stats not in section {title_marker}")
            new_section = new_section.replace(old_stats, f'\t\tstats = "{stats_key}",', 1)
        else:
            # Holy Priest / Subtlety — replace first stats = line in section
            m = re.search(r"\t\tstats = .+", new_section)
            if not m:
                raise RuntimeError(f"No stats line for {title_marker}")
            new_section = new_section[: m.start()] + f'\t\tstats = "{stats_key}",' + new_section[m.end() :]
        new_section = inject_after_consumables(new_section, prefix)
        text = text[:s] + new_section + text[e:]
    return text


def build_locale_lines(lang: str) -> list[str]:
    arch = ARCH if lang == "en" else ARCH_NL
    lines: list[str] = []
    for _, _, _, prefix, archetype in PATCHES:
        tmpl = arch[archetype]
        for key, val in sorted(tmpl.items(), key=lambda kv: kv[0]):
            lua_key = f"{prefix}_{key}"
            escaped = val.replace("\\", "\\\\").replace('"', '\\"')
            lines.append(f'\t{lua_key} = "{escaped}",')
    return lines


def insert_locale_file(path: Path, stats_header_lines: list[str], advisor_lines: list[str]) -> None:
    raw = path.read_text(encoding="utf-8")
    if "GUIDE_ADVISOR_DRUID_BALANCE_10_ROT_1" in raw:
        return
    anchor = "\tGUIDE_GEAR_DK_BLOOD_1 = "
    idx = raw.find(anchor)
    if idx < 0:
        raise RuntimeError(f"Anchor not found in {path}")

    stats_block = "\n".join(["\t-- Full curated advisor rollout (remaining specs)"] + stats_header_lines) + "\n\n"
    advisor_block = "\n".join(["\t-- Advisor strings (remaining specs)"] + advisor_lines) + "\n\n"

    stats_anchor = "\tGUIDE_STATS_SHAMAN_ENH = "
    si = raw.rfind(stats_anchor, 0, idx)
    if si < 0:
        raise RuntimeError("GUIDE_STATS_SHAMAN_ENH not found before DK gear")
    line_end = raw.find("\n", si)
    insert_at = line_end + 1
    raw = raw[:insert_at] + "\n" + stats_block + raw[insert_at:]

    raw = raw.replace(anchor, advisor_block + anchor, 1)
    path.write_text(raw, encoding="utf-8")


def main() -> None:
    gd = GUIDE_DATA.read_text(encoding="utf-8")
    if "GUIDE_ADVISOR_DRUID_BALANCE_10_ROT_1" not in gd:
        GUIDE_DATA.write_text(patch_guide_data(gd), encoding="utf-8")
        print("Updated GuideData.lua")
    else:
        print("GuideData.lua already contains DRUID_BALANCE advisor; skipping data patch.")

    stats_lines_en = []
    for k, v in STATS_VALUES_EN.items():
        esc = v.replace("\\", "\\\\").replace('"', '\\"')
        stats_lines_en.append(f'\t{k} = "{esc}",')

    stats_lines_nl = []
    for k, v in STATS_VALUES_NL.items():
        esc = v.replace("\\", "\\\\").replace('"', '\\"')
        stats_lines_nl.append(f'\t{k} = "{esc}",')

    insert_locale_file(ENUS, stats_lines_en, build_locale_lines("en"))
    insert_locale_file(NLNL, stats_lines_nl, build_locale_lines("nl"))
    print("Locale files updated (or already contained batch).")


if __name__ == "__main__":
    main()
