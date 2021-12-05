/datum/symptom/ironskin
	name = "Armored Body" //Organic Augs. For those who embrace the superiority of flesh 
	desc = "The virus reinforces the body of the patient. Reducing incoming damage"
	stealth = -2
	resistance = 1
	stage_speed = -1
	transmittable = -2
	level = 8 
	symptom_delay_min = 1
	symptom_delay_max = 1
	var/armor_check = FALSE
	var/damage_resist_augment = 0
	var/run_check = FALSE
	var/list/infected_parts = list()
	threshold_descs = list(
		"Resistance 7" = "Increases damage reduction.",
		"Resistance 4" = "Increases damage resistance.",
	)

/datum/symptom/ironskin/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["resistance"] >= 4) //Give armor
		armor_check = TRUE
	if(A.properties["resistance"] >= 7) //Increases damage resist values
		damage_resist_augment = 3

/datum/symptom/ironskin/Activate(datum/disease/advance/A)
	if(!..())
		return
	if(run_check)
		return
	var/mob/living/carbon/human/M = A.affected_mob
	switch(A.stage)
		if(5)
			if(armor_check)
				M.physiology.damage_resistance += 10
			for(var/BP in M.bodyparts) //L for Limb
				var/obj/item/bodypart/L = BP
				if(L.status == BODYPART_ORGANIC)
					L.brute_reduction += (5+damage_resist_augment)
					L.burn_reduction += (4+damage_resist_augment)
					infected_parts += BP
			M.visible_message("<span class='warning'>[M]'s skin seems to harden!</span>", "<span class='notice'>You feel your skin harden!</span>")
			run_check = TRUE

		else
			if(prob(5))
				M.visible_message("<span class='warning'>[M] looks hardier</span>", "<span class='notice'>Your skin feels stiff</span>")
/datum/symptom/ironskin/End(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/human/M = A.affected_mob
	if(A.affected_mob)
		if(armor_check)
			M.physiology.damage_resistance -= 10
		for(var/BP in infected_parts)
			var/obj/item/bodypart/L = BP
			L.brute_reduction -= (5+damage_resist_augment)
			L.burn_reduction -= (4+damage_resist_augment)