# Buy Claimed Bodies

A standalone loot claim and buyout system for S.T.A.L.K.E.R. Anomaly (G.A.M.M.A.).

When an NPC kills another NPC it claims the body. Instead of only being warned off that body, you can buy it from the claimer. The mod works on its own with no required dependencies, and uses richer integrations when they are present.

## Features

* Buy a claimed body from the NPC who claimed it
* Standalone: it records its own claims at death and blocks looting of claimed bodies, so it works with no base loot claim mod installed
* Dynamic pricing that varies by the victim's rank, the claiming faction's opinion of you, and a small fixed random factor
* Mutant bodies priced by difficulty tier and where they died (map danger)
* Per faction seller personalities with a post Soviet, Ukrainian leaning tone (loners, bandits, Duty, Freedom, Clear Sky, mercs, military, ecologists, Monolith, renegades, Sin, UNISG)
* Corpse labels: claimed bodies read "(Claimed)", bought bodies "(Bought)", free looted bodies "(Stolen)"
* PDA notifications with the seller's name and face, so you know who to find
* Bought bodies are marked with an X on the PDA map and minimap so you can find them, even one bought from a killer while the body lies across the map. The mark clears when you loot it
* Buy all: when a killer has claimed several bodies, the talk menu offers a single option to buy the lot at once, at a small bundle discount
* Claims expire: a claimed body left untouched long enough becomes free to loot again as the NPC loses interest
* No deals mid-combat: a seller in a firefight or downed will not stop to deal, wait until it is over
* Despawned bodies are cleaned up, so stale claims, prices and map marks do not pile up
* Optional: make NPCs respect claims too, so an NPC will not loot a body that a different NPC killed (off by default, needs More Aggressive NPC Looting)
* Russian localization included
* Fully configurable through MCM

## Interaction modes

Set in MCM:

* At the body (default): press use on the claimed corpse to get a yes or no buy prompt. The claimer must be alive, nearby, and not hostile.
* Talk to the killer: using the corpse points you to who claimed it. Walk to that NPC and a dialogue option lets you negotiate and buy. The body can be anywhere, its rank is remembered so it is still priced correctly while offline.

## Pricing

Human body:

```
price = base x rank factor x reputation factor x random jitter
```

Mutant body:

```
price = base x difficulty tier x map danger x reputation factor x random jitter
```

* Rank factor uses the eight stalker rank tiers, novice through legend
* Reputation factor is your goodwill with the claiming NPC's faction. Liked factions cut you a deal, disliked ones charge more
* The random jitter is rolled once per body and cached, so it cannot be save scummed
* Hostile factions refuse to sell and keep the original warning behaviour

Optional loot value pricing (off by default, set the loot value weight above 0):

* A body's gear adds a premium on top of the rank price. Weapons are valued the GAMMA way, by their parts times condition, so a green barrel is the prize and a busted weapon is worth nothing. Artifacts are valued by their cost, the one thing still worth real coin
* Separate weights for the weapon parts (barrel) and for artifacts, so you tune what matters
* Read once at the kill while the body is online, so it still prices right when you buy it offline from the killer. Weapon part values use Weapon Parts Overhaul, which GAMMA ships

Optional "take it anyway" play, both off by default:

* Loot for free when the claimer is too far to stop you
* Free looting can alert the faction, with a configurable chance to turn nearby members hostile

Everything (base and minimum price, rank, mutant and map danger weights, reputation influence, random spread, refuse to sell threshold, deal range, free loot and alert options, haggling, shady betrayal, no deals mid-combat, bulk buyout, claim expiry and its lifetime, map marks, interaction mode, PDA notifications, master switch) is configurable in MCM under "Loot Claim Buyout".

## Compatibility

No hard dependencies. These are detected at runtime and used when present:

* A base loot claim mod (G.A.M.M.A. NPC Loot Claim Remade, or Drunk's NPC Loot Claim Remade). When one is installed this addon takes over the use interaction so the two do not both block looting. When absent, this addon is the claim system.
* Interaction Dot Marks: draws the (Claimed), (Bought) and (Stolen) labels on the corpse in the world. Without it the status shows as a brief on screen line when you look at the body.
* MCM: the configuration menu. Without it the built in defaults in z_npc_loot_buy_mcm.script are used.
* PDA notifications use the game's news helper, with an on screen message as fallback.

### Known conflicts

* **AlifePlus 1.7.7+** ships its own corpse loot ownership (`ap_ext_loot_claim`) that overlaps this mod. With both on you get inconsistent results, a buy prompt from this mod on some bodies and an item take denial from AlifePlus on others, because they track ownership in separate ledgers. Turn AlifePlus loot ownership off in its MCM (**economy, loot**) when using this mod. AlifePlus 1.7.6 and earlier do not have it. The optional "NPCs respect claims" feature disables itself automatically while AlifePlus loot ownership is on.

## Install

Drop the gamedata folder into your mod, or install through your mod manager and place it after any base loot claim mod in the load order. The scripts are z prefixed so they load last and take over the use handler at runtime.

## Localization

English and Russian are included. The Russian file is windows 1251 encoded, as the engine requires.
