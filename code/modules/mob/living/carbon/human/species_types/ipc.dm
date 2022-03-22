/datum/species/ipc
	name = "IPC"
	id = "ipc"
	say_mod = "states"
	sexes = FALSE
	species_traits = list(NOTRANSSTING,NOEYESPRITES,NO_DNA_COPY,ROBOTIC_LIMBS,NOZOMBIE,MUTCOLORS,REVIVESBYHEALING,NOHUSK,NOMOUTH,NOBLOOD,NOSTOMACH,TRAIT_NOBREATH,NOSCAN,AGENDER)
	inherent_traits = list(TRAIT_RESISTCOLD,TRAIT_RADIMMUNE,TRAIT_GENELESS,TRAIT_LIMBATTACHMENT,TRAIT_NOCRITDAMAGE,TRAIT_EASYDISMEMBER,TRAIT_NOHUNGER,TRAIT_XENO_IMMUNE, TRAIT_TOXIMMUNE)
	inherent_biotypes = list(MOB_ROBOTIC, MOB_HUMANOID)
	mutantbrain = /obj/item/organ/brain/theophilus
	mutanteyes = /obj/item/organ/eyes/robotic
	mutanttongue = /obj/item/organ/tongue/robot
	mutantliver = /obj/item/organ/liver/cybernetic/upgraded/ipc
	mutantears = /obj/item/organ/ears/robot
	mutant_bodyparts = list("ipc_screen", "ipc_antenna", "ipc_chassis")
	//default_features = list("mcolor" = "#7D7D7D", "ipc_screen" = "Static", "ipc_antenna" = "None", "ipc_chassis" = "Morpheus Cyberkinetics(Greyscale)")
	meat = /obj/item/stack/sheet/plasteel
	skinned_type = /obj/item/stack/sheet/metal
	damage_overlay_type = "synth"
	limbs_id = "synth"
	mutant_bodyparts = list("ipc_screen", "ipc_antenna", "ipc_chassis")
	//default_features = list("ipc_screen" = "BSOD", "ipc_antenna" = "None")
	burnmod = 2
	heatmod = 1.5
	brutemod = 1
	siemens_coeff = 1.5
	reagent_tag = PROCESS_SYNTHETIC
	species_gibs = GIB_TYPE_ROBOTIC
	attack_sound = 'sound/items/trayhit1.ogg'
	allow_numbers_in_name = TRUE
	deathsound = "sound/voice/borg_deathsound.ogg"
	changesource_flags = MIRROR_BADMIN | WABBAJACK
	species_language_holder = /datum/language_holder/synthetic
	//special_step_sounds = list('sound/effects/servostep.ogg')

	var/saved_screen //for saving the screen when they die
	var/datum/action/innate/change_screen/change_screen

/datum/species/ipc/random_name(unique)
	var/ipc_name = "[pick(GLOB.posibrain_names)]-[rand(100, 999)]"
	return ipc_name

/datum/species/ipc/on_species_gain(mob/living/carbon/C)
	. = ..()
	var/obj/item/organ/appendix/A = C.getorganslot("appendix") //See below.
	if(A)
		A.Remove(C)
		QDEL_NULL(A)
	var/obj/item/organ/lungs/L = C.getorganslot("lungs") //Hacky and bad. Will be rewritten entirely in KapuCarbons anyway.
	if(L)
		L.Remove(C)
		QDEL_NULL(L)
	var/obj/item/organ/stomach/S = C.getorganslot("stomach")
	if(S)
		S.Remove(C)
		QDEL_NULL(S)
	var/obj/item/organ/heart/D = C.getorganslot("heart") // D for duplicate definition, H was taken
	if(D)
		D.Remove(C)
		QDEL_NULL(D)

	if(ishuman(C) && !change_screen)
		change_screen = new
		change_screen.Grant(C)
	for(var/obj/item/bodypart/O in C.bodyparts)
		O.render_like_organic = TRUE // Makes limbs render like organic limbs instead of augmented limbs, check bodyparts.dm
		var/chassis = C.dna.features["ipc_chassis"]
		var/datum/sprite_accessory/ipc_chassis/chassis_of_choice = GLOB.ipc_chassis_list[chassis]
		C.dna.species.limbs_id = chassis_of_choice.limbs_id
		if(chassis_of_choice.color_src == MUTCOLORS && !(MUTCOLORS in C.dna.species.species_traits)) // If it's a colorable(Greyscale) chassis, we use MUTCOLORS.
			C.dna.species.species_traits += MUTCOLORS
		else if(MUTCOLORS in C.dna.species.species_traits)
			C.dna.species.species_traits -= MUTCOLORS
		O.light_brute_msg = "scratched"
		O.medium_brute_msg = "dented"
		O.heavy_brute_msg = "sheared"

		O.light_burn_msg = "burned"
		O.medium_burn_msg = "scorched"
		O.heavy_burn_msg = "seared"

	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		H.physiology.bleed_mod *= 0.1

/datum/species/ipc/on_species_loss(mob/living/carbon/C)
	. = ..()
	if(change_screen)
		change_screen.Remove(C)

	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		H.physiology.bleed_mod *= 10

/datum/species/ipc/proc/handle_speech(datum/source, list/speech_args)
	speech_args[SPEECH_SPANS] |= SPAN_ROBOT //beep

/datum/species/ipc/spec_death(gibbed, mob/living/carbon/C)
	saved_screen = C.dna.features["ipc_screen"]
	C.dna.features["ipc_screen"] = "BSOD"
	C.update_body()
	addtimer(CALLBACK(src, .proc/post_death, C), 5 SECONDS)

/datum/species/ipc/proc/post_death(mob/living/carbon/C)
	if(C.stat < DEAD)
		return
	C.dna.features["ipc_screen"] = null //Turns off screen on death
	C.update_body()

/datum/action/innate/change_screen
	name = "Change Display"
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "drone_vision"

/datum/action/innate/change_screen/Activate()
	var/screen_choice = input(usr, "Which screen do you want to use?", "Screen Change") as null | anything in GLOB.ipc_screens_list
	var/color_choice = input(usr, "Which color do you want your screen to be?", "Color Change") as null | color
	if(!screen_choice)
		return
	if(!color_choice)
		return
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.dna.features["ipc_screen"] = screen_choice
	H.eye_color = sanitize_hexcolor(color_choice)
	H.update_body()

/datum/species/ipc/spec_life(mob/living/carbon/human/H)
	. = ..()
	if(H.health <= UNCONSCIOUS && H.stat != DEAD) // So they die eventually instead of being stuck in crit limbo.
		H.adjustFireLoss(6) // After bodypart_robotic resistance this is ~2/second
		if(prob(5))
			to_chat(H, "<span class='warning'>Alert: Internal temperature regulation systems offline; thermal damage sustained. Shutdown imminent.</span>")
			H.visible_message("[H]'s cooling system fans stutter and stall. There is a faint, yet rapid beeping coming from inside their chassis.")

/datum/species/ipc/spec_revival(mob/living/carbon/human/H)
	H.notify_ghost_cloning("You have been repaired!")
	H.grab_ghost()
	H.dna.features["ipc_screen"] = "BSOD"
	H.update_body()
	H.say("Reactivating [pick("core systems", "central subroutines", "key functions")]...")
	sleep(3 SECONDS)
	if(H.stat == DEAD)
		return
	H.say("Reinitializing [pick("personality matrix", "behavior logic", "morality subsystems")]...")
	sleep(3 SECONDS)
	if(H.stat == DEAD)
		return
	H.say("Finalizing setup...")
	sleep(3 SECONDS)
	if(H.stat == DEAD)
		return
	H.say("Unit [H.real_name] is fully functional. Have a nice day.")
	H.dna.features["ipc_screen"] = saved_screen
	H.update_body()
	return

// /datum/species/ipc/get_harm_descriptors()
//	return list("bleed" = "leaking", "brute" = "denting", "burn" = "burns")