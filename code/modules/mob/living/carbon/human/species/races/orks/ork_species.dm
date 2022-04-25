/datum/species/ork
	name = SPECIES_ORK
	name_plural = "Orkz"
	secondary_langs = list(LANGUAGE_ORKY)
	name_language = null // Use the first-name last-name generator rather than a language scrambler
	icobase = 'icons/mob/human_races/r_ork.dmi'
	deform = 'icons/mob/human_races/r_def_ork.dmi'
	min_age = 1
	max_age = 65
	total_health = 200
	gluttonous = GLUT_ITEM_NORMAL
	mob_size = MOB_LARGE
	strength = STR_HIGH
	brute_mod = 1.0
	burn_mod = 1.0
	toxins_mod = 0.9
	sexybits_location = BP_GROIN
	inherent_verbs = list(
		//mob/living/carbon/human/ork/proc/evolve,
		/mob/living/carbon/human/ork/proc/scavenge,
		/mob/living/carbon/human/ork/proc/giveorkzstats,
		/mob/living/carbon/human/ork/proc/warscream,
		)
	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/punch,
		/datum/unarmed_attack/bite
		)
/datum/species/ork/handle_post_spawn(var/mob/living/carbon/human/H)
	H.age = rand(min_age,max_age)//Random age
	if(H.h_style)
		H.h_style = "Bald" //never seen an ork wif hair
	if(H.f_style)//orks dont have beards
		H.f_style = "Shaved"
		to_chat(H, "<big><span class='warning'>Youz a Freeboota! Warboss a lazy git and is asleep roight now, but you'z can elect a Nob as a leada till he awakes. We'd come fars and widez on a space hulkz, then we got blasted out of da worp and landed in 'ere. Moight be 'Umies we could offer our servicz too, and if they say nah, we'z can ransack their village..</span></big>
	H.update_eyes()	//hacky fix, i don't care and i'll never ever care (this fixs the weird grey vision shit when placing people in a new mob)
	return ..()


/mob/living/carbon/human/ork/Stat()
	..()
	if(max_waaagh > 0)
		stat(null, "Waaagh: [waaagh]/[max_waaagh]")

/mob/living/carbon/human/ork/Life()
	..()
	var/regen = 0.08
	if(max_waaagh > 0)
		if(inspired)
			regen = 0.10
		else
			regen = 0.08

		waaagh = max(0, min(waaagh + regen, max_waaagh))

/mob/living/carbon/human/ork
	name = "ork"
	real_name = "ork"
	gender = MALE
	status_flags = 0
	var/isempty = 0
	var/waaagh = 0
	var/max_waaagh = 0
	var/inspired = FALSE  //this changes when the ork is buffed by the warboss

/mob/living/carbon/human/ork/New(var/new_loc)
	max_waaagh = 200
	waaagh = max_waaagh
	var/dice = rand(1, 2)
	switch(dice)
		if(1)
			playsound(src, 'sound/voice/ork/dakkashout3.ogg', 50)
		if(2)
			playsound(src, 'sound/voice/ork/workwork.ogg', 50)
	..(new_loc, new_orkz)

/mob/living/carbon/human/ork/Initialize()
	. = ..()
	fully_replace_character_name(random_ork_name(src.gender))
	warfare_faction = ORKZ
	var/decl/hierarchy/outfit/outfit = outfit_by_type(/decl/hierarchy/outfit/job/ork)
	outfit.equip(src)

	hand = 0//Make sure one of their hands is active.
	put_in_hands(new /obj/item/gun/projectile/ork/automatic/shoota)//Give them a weapon.
	src.isburied = 1

/mob/living/carbon/human //the most cursed line in all of this code
	var/new_orkz = SPECIES_ORK
