# Changelog

## 1.0.8 [BETA]

## Fixed
* Fixed Lua errors and log spam when opening a stash or looking at any non body object. The mod checked if the object was alive before confirming it was a stalker or mutant, and the alive check errors on stashes and other classes. It was noisy but never crashed.
* Stopped the MCM "bad path" log spam from the hidden tunables (cached price lifetime and a few others). They now read from the defaults directly instead of asking the menu for an option that is not listed.

## 1.0.7 [BETA]

## Changed
* Hardened the loot window handling. All body loot now opens through a single router that picks the mutant skin screen or the human inventory by body type, so the human and mutant split has one enforcement point and the 1.0.6 fix cannot be bypassed by future code. No change in behavior.

## 1.0.6 [BETA]

## Fixed
* Fixed a crash when stealing a claimed mutant with the confirm popup on. Pressing yes opened the human loot window on the mutant, and the game crashed trying to read its money. Mutants now go through the normal skin handler.

## 1.0.5 [BETA]

## Added
* Optional confirm popup for claimed bodies: a yes or no warning before you steal one, and a notice naming who claimed it, shown as a clear popup instead of a brief on screen line. Made for playing with PDA notifications and corpse dot marks off.
* A sound plays when a deal closes.
* The buy prompt now shows the body's name and rank, so you know what you are paying for.

## Changed
* More flavor: haggling has three lines each for the offer, the success and the refusal; stealing a body now draws a reaction from that faction, one for each of the twelve; the "you cannot afford it" line is per faction too; and there are more "too far to deal" lines.
* Clearer wording: the free looting option is renamed to stealing, since it costs you goodwill with the faction, and "coin" is now roubles or money to match the Zone.
* Cached prices expire after a while, so they track your reputation again instead of staying locked at the first value.
* The scripts are reorganized into a core script and a separate helpers script (z_npc_loot_buy_util) for easier reading and maintenance.

## 1.0.4

## Added
* Optional loot value pricing: a body's gear adds a premium on top of the rank price. Weapons are valued the GAMMA way, by their parts times condition, so a green barrel is the prize and a busted weapon is worth nothing. Artifacts are valued by their cost. Separate weights for the weapon parts and for artifacts, read once at the kill so an offline body still prices right. On by default, set the loot value weight to 0 to turn it off.

## Changed
* Rebalanced the default prices for GAMMA: base price 2500 to 2000, minimum price 100 to 300, reputation discount and surcharge capped at 40% instead of 50%, and shady betrayal chance lowered from 12% to 10%.

## 1.0.3

## Added
* Bought bodies are marked with an X on the PDA map and the minimap, so you can find what you paid for. It works even when you buy from a killer while the body lies across the map, and the mark clears once you loot the body. Has a toggle.
* Buy all: when a killer has claimed several bodies, the talk menu offers a single option to buy the lot at once, at a small bundle discount.
* Claims expire: a claimed body left untouched long enough becomes free to loot again, as the NPC loses interest. The lifetime is configurable.
* No deals mid combat: a seller who is in a firefight or downed will not stop to deal. Wait until the fighting is over.

## Changed
* The MCM page is organized into labelled sections (General, Pricing, Buying and claims, Shady sellers, Stealing, NPCs respecting claims, Interface) instead of one long list.

## Fixed
* When a body despawns, its claim, cached price and map mark are now cleared, so stale entries no longer pile up.

## 1.0.2

## Added
* Talk to the killer now shows a list of every body that NPC has claimed (name, rank, price). Pick one to buy and the menu loops back, so you can buy several without reopening it.
* Haggling: try to talk the price down, once per body. Your rank and standing with the faction improve the odds, and a failed attempt offends the seller and raises the price. Works in both the talk to killer menu and at the body.
* Optional player rank pricing: your own rank affects the price. A rookie gets bullied and pays more, a veteran or higher is respected and pays less. Has its own toggle and a weight.
* Stealing has consequences: free looting a claimed body lowers your goodwill with that faction. Steal enough of their kills and they stop dealing with you.
* Shady seller betrayal: bandits, renegades, mercs and Sin may shove you off and refuse the deal instead of selling, with a per faction message telling you to leave. They do not turn hostile and take no money.
* Optional "NPCs respect claims": an NPC will not loot a body that a different NPC killed, with an owner can loot its kill sub toggle. Needs More Aggressive NPC Looting.

## Fixed
* At the body, clicking buy without enough coin now shows a clear popup instead of a silent PDA line. The PDA copy is sent only when PDA notifications are on.
* The claim warning that printed two to four times per tap now fires once.

## 1.0.0

## Added
* Buy a body from the NPC who claimed it, instead of only being warned off it.
* Standalone: records its own claims when an NPC makes a kill and blocks looting of claimed bodies, so it works with no base loot claim mod installed.
* Dynamic pricing by the victim's rank, the claiming faction's opinion of you, and a small random factor.
* Mutant bodies priced by difficulty tier and where they died (map danger).
* Two interaction modes: a buy prompt at the body, or talk to the killer to deal.
* Per faction seller personalities with a post Soviet, Ukrainian leaning tone.
* Free loot a kill when the claimer is too far to stop you, optionally alerting the faction to turn nearby members hostile.
* Hostile factions refuse to deal and keep the original warn off behaviour.
* Fully configurable through MCM, with Russian localization included.
