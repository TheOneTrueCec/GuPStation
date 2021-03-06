/datum/outfit/encounter
	name = "Encounter Base"
	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/combat
	back = /obj/item/storage/backpack
	id = /obj/item/card/id/syndicate/anyone
	implants = list(/obj/item/implant/weapons_auth)

/datum/outfit/encounter/syndicate
	name = "Syndicate Encounter"
	gloves = /obj/item/clothing/gloves/combat
	glasses = /obj/item/clothing/glasses/night
	back = /obj/item/storage/backpack/duffelbag/syndie
	belt = /obj/item/storage/belt/military
	ears = /obj/item/radio/headset/syndicate/alt

/datum/outfit/encounter/syndicate/pilot
	name = "Syndicate Pilot"
	head = /obj/item/clothing/head/beret
	belt = null

/datum/outfit/encounter/syndicate/weapons_officer
	name = "Syndicate Weapons Officer"
	head = /obj/item/clothing/head/hos/beret/syndicate

/datum/outfit/encounter/syndicate/engineer
	name = "Syndicate Engineer"
	belt = /obj/item/storage/belt/utility/full/engi

//Don't use these sparingly, they have powerful and super rare gear

/datum/outfit/encounter/syndicate/captain
	name = "Syndicate Captain"
	belt = /obj/item/storage/belt/sabre
	suit = /obj/item/clothing/suit/armor/vest/capcarapace/syndicate
	suit_store = /obj/item/gun/ballistic/revolver/mateba
	glasses = /obj/item/clothing/glasses/thermal/eyepatch
	neck = /obj/item/clothing/neck/cloak/syndcap
	shoes = /obj/item/clothing/shoes/combat/swat

//This has evolved from borderline overpowered to just plain overpowered overtime, but its pretty fucking epic for admins
/datum/outfit/encounter/syndicate/admiral
	name = "Syndicate Admiral"
	belt = /obj/item/storage/belt/sabre
	head = /obj/item/clothing/head/helmet/space/beret
	suit = /obj/item/clothing/suit/armor/vest/capcarapace/syndicate/admiral
	suit_store = /obj/item/gun/ballistic/shotgun/automatic/pistol
	glasses = /obj/item/clothing/glasses/thermal/eyepatch
	neck = /obj/item/clothing/neck/cloak/syndadmiral
	mask = /obj/item/clothing/mask/cigarette/cigar/havana
	l_pocket = /obj/item/lighter
	r_pocket = /obj/item/tank/internals/emergency_oxygen/double
	shoes = /obj/item/clothing/shoes/combat/swat
	backpack_contents = list(/obj/item/storage/box/survival=1,/obj/item/clipboard=1,/obj/item/ammo_box/shotgun_lethal=3)
