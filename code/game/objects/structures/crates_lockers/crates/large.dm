/obj/structure/closet/crate/large
	name = "large crate"
	desc = "A hefty wooden crate. You'll need a crowbar to get it open."
	icon_state = "largecrate"
	density = TRUE
	material_drop = /obj/item/stack/sheet/mineral/wood
	material_drop_amount = 4
	delivery_icon = "deliverybox"
	integrity_failure = 0 //Makes the crate break when integrity reaches 0, instead of opening and becoming an invisible sprite.
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50

/obj/structure/closet/crate/large/attack_hand(mob/user)
	add_fingerprint(user)
	if(manifest)
		tear_manifest(user)
	else
		to_chat(user, "<span class='warning'>You need a crowbar to pry this open!</span>")

/obj/structure/closet/crate/large/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_CROWBAR)
		if(manifest)
			tear_manifest(user)

		user.visible_message("<span class='notice'>[user] pries \the [src] open.</span>", \
							 "<span class='notice'>You pry open \the [src].</span>", \
							 "<span class='hear'>You hear splitting wood.</span>")
		playsound(src.loc, 'sound/weapons/slashmiss.ogg', 75, TRUE)

		var/turf/T = get_turf(src)
		for(var/i in 1 to material_drop_amount)
			new material_drop(src)
		for(var/atom/movable/AM in contents)
			AM.forceMove(T)

		qdel(src)

	else
		if(user.a_intent == INTENT_HARM)	//Only return  ..() if intent is harm, otherwise return 0 or just end it.
			return ..()						//Stops it from opening and turning invisible when items are used on it.

		else
			to_chat(user, "<span class='warning'>You need a crowbar to pry this open!</span>")
			return FALSE //Just stop. Do nothing. Don't turn into an invisible sprite. Don't open like a locker.
					//The large crate has no non-attack interactions other than the crowbar, anyway.

/obj/structure/closet/crate/large/shuttle
	name = "Shuttle Construction Kit"
	desc = "An all you can build shuttle construction kit, complete with basic weapon systems."

/obj/structure/closet/crate/large/shuttle/PopulateContents()
	..()
	new /obj/machinery/portable_atmospherics/canister/toxins(src)
	new /obj/item/construction/rcd/loaded(src)
	new /obj/item/rcd_ammo/large(src)
	new /obj/item/rcd_ammo/large(src)
	new /obj/item/shuttle_creator(src)
	new /obj/item/pipe_dispenser(src)
	new /obj/item/storage/toolbox/mechanical(src)
	new /obj/item/storage/toolbox/electrical(src)
	new /obj/item/circuitboard/computer/shuttle/docker(src)
	new /obj/item/circuitboard/computer/shuttle/flight_control(src)
	new /obj/item/circuitboard/machine/shuttle/engine/plasma(src)
	new /obj/item/circuitboard/machine/shuttle/engine/plasma(src)
	new /obj/item/circuitboard/machine/shuttle/heater(src)
	new /obj/item/circuitboard/machine/shuttle/heater(src)
	new /obj/item/wallframe/shuttle_weapon/laser(src)
	new /obj/item/storage/part_replacer/bluespace/tier2(src)
	new /obj/item/electronics/apc(src)
	new /obj/item/stock_parts/cell/high/plus(src)
	new /obj/item/circuitboard/computer/shuttle/weapons(src)
