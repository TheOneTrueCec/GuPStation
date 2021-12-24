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
	var/first_pass = TRUE
	var/damage_resist_augment = 0
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
	var/mob/living/carbon/human/M = A.affected_mob
	switch(A.stage)
		if(5)
			if(armor_check && first_pass)
				M.physiology.damage_resistance += 10
			if(prob(1) || first_pass)
				for(var/obj/item/bodypart/L in M.bodyparts) //L for Limb
					if(L.status == BODYPART_ORGANIC || !L.ironskin_infected) //Can't infect Robolimbs, and can't iterate over the same limb multiple times
						L.brute_reduction += (5+damage_resist_augment)
						L.burn_reduction += (4+damage_resist_augment)
						infected_parts += L
						L.ironskin_infected = TRUE
						M.visible_message("<span class='warning'>[M]'s skin seems to harden!</span>", "<span class='notice'>You feel the skin of your [L] harden!</span>")
			first_pass = FALSE

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
		for(var/obj/item/bodypart/L  in infected_parts) // Quantum Immune Systems
			L.brute_reduction -= (5+damage_resist_augment)
			L.burn_reduction -= (4+damage_resist_augment)