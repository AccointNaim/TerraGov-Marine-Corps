//This is an uguu head restoration surgery TOTALLY not yoinked from chinsky's limb reattacher

/datum/surgery_step/head
	priority = 1
	can_infect = 0

/datum/surgery_step/head/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!hasorgans(target))
		return 0
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(!affected)
		return 0
	if(!(affected.status & ORGAN_DESTROYED))
		return 0
	if(affected.parent)
		if(affected.parent.status & ORGAN_DESTROYED)
			return 0
	return affected.name == "head"

/datum/surgery_step/head/peel
	allowed_tools = list(
	/obj/item/weapon/retractor = 100,           \
	/obj/item/weapon/crowbar = 75,              \
	/obj/item/weapon/kitchen/utensil/fork = 50, \
	)

	min_duration = 30
	max_duration = 40

/datum/surgery_step/head/peel/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/datum/organ/external/affected = target.get_organ(target_zone)
		return !(affected.status & ORGAN_CUT_AWAY)

/datum/surgery_step/head/peel/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	is_same_target = affected
	user.visible_message("<span class='notice'>[user] starts peeling back tattered flesh where [target]'s head used to be with \the [tool].</span>", \
	"<span class='notice'>You start peeling back tattered flesh where [target]'s head used to be with \the [tool].</span>")
	..()

/datum/surgery_step/head/peel/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(is_same_target != affected) //We are not aiming at the same organ as when be begun, cut him up
		user << "<span class='warning'><b>You failed to start the surgery.</b> Aim at the same organ as the one that you started working on originally.</span>"
		return
	user.visible_message("<span class='notice'>[user] peels back tattered flesh where [target]'s head used to be with \the [tool].</span>",	\
	"<span class='notice'>You peel back tattered flesh where [target]'s head used to be with \the [tool].</span>")
	affected.status |= ORGAN_CUT_AWAY

/datum/surgery_step/head/peel/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(affected.parent)
		affected = affected.parent
		user.visible_message("<span class='warning'>[user]'s hand slips, ripping [target]'s [affected.display_name] open!</span>", \
		"<span class='warning'>Your hand slips,  ripping [target]'s [affected.display_name] open!</span>")
		affected.createwound(CUT, 10)
		affected.update_wounds()

/datum/surgery_step/head/shape
	allowed_tools = list(
	/obj/item/weapon/FixOVein = 100,         \
	/obj/item/stack/cable_coil = 75,         \
	/obj/item/device/assembly/mousetrap = 10
	)

	min_duration = 60
	max_duration = 80

/datum/surgery_step/head/shape/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/datum/organ/external/affected = target.get_organ(target_zone)
		return affected.status & ORGAN_CUT_AWAY && target.op_stage.head_reattach == 0 && !(affected.status & ORGAN_ATTACHABLE)

/datum/surgery_step/head/shape/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	is_same_target = affected
	user.visible_message("<span class='notice'>[user] is beginning to reshape [target]'s esophagal and vocal region with \the [tool].</span>", \
	"<span class='notice'>You start to reshape [target]'s [affected.display_name] esophagal and vocal region with \the [tool].</span>")
	..()

/datum/surgery_step/head/shape/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(is_same_target != affected) //We are not aiming at the same organ as when be begun, cut him up
		user << "<span class='warning'><b>You failed to start the surgery.</b> Aim at the same organ as the one that you started working on originally.</span>"
		return
	user.visible_message("<span class='notice'>[user] has finished repositioning flesh and tissue to something anatomically recognizable where [target]'s head used to be with \the [tool].</span>",	\
	"<span class='notice'>You have finished repositioning flesh and tissue to something anatomically recognizable where [target]'s head used to be with \the [tool].</span>")
	target.op_stage.head_reattach = 1

/datum/surgery_step/head/shape/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(affected.parent)
		affected = affected.parent
		user.visible_message("<span class='warning'>[user]'s hand slips, further rending flesh on [target]'s neck!</span>", \
		"<span class='warning'>Your hand slips, further rending flesh on [target]'s neck!</span>")
		target.apply_damage(10, BRUTE, affected)
		target.updatehealth()

/datum/surgery_step/head/suture
	allowed_tools = list(
	/obj/item/weapon/hemostat = 100, \
	/obj/item/stack/cable_coil = 60, \
	/obj/item/weapon/FixOVein = 80
	)

	min_duration = 60
	max_duration = 80

/datum/surgery_step/head/suture/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		return target.op_stage.head_reattach == 1

/datum/surgery_step/head/suture/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	is_same_target = affected
	user.visible_message("<span class='notice'>[user] is stapling and suturing flesh into place in [target]'s esophagal and vocal region with \the [tool].</span>", \
	"<span class='notice'>You start to staple and suture flesh into place in [target]'s esophagal and vocal region with \the [tool].</span>")
	..()

/datum/surgery_step/head/suture/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(is_same_target != affected) //We are not aiming at the same organ as when be begun, cut him up
		user << "<span class='warning'><b>You failed to start the surgery.</b> Aim at the same organ as the one that you started working on originally.</span>"
		return
	user.visible_message("<span class='notice'>[user] has finished stapling [target]'s neck into place with \the [tool].</span>",	\
	"<span class='notice'>You have finished stapling [target]'s neck into place with \the [tool].</span>")
	target.op_stage.head_reattach = 2

/datum/surgery_step/head/suture/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(affected.parent)
		affected = affected.parent
		user.visible_message("<span class='warning'>[user]'s hand slips, ripping apart flesh on [target]'s neck!</span>", \
		"<span class='warning'>Your hand slips, ripping apart flesh on [target]'s neck!</span>")
		target.apply_damage(10, BRUTE, affected)
		target.updatehealth()

/datum/surgery_step/head/prepare
	allowed_tools = list(
	/obj/item/weapon/cautery = 100,			\
	/obj/item/clothing/mask/cigarette = 75,	\
	/obj/item/weapon/flame/lighter = 50,    \
	/obj/item/weapon/weldingtool = 25
	)

	min_duration = 60
	max_duration = 80

/datum/surgery_step/head/prepare/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		return target.op_stage.head_reattach == 2

/datum/surgery_step/head/prepare/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	is_same_target = affected
	user.visible_message("<span class='notice'>[user] starts adjusting area around [target]'s neck with \the [tool].</span>", \
	"<span class='notice'>You start adjusting area around [target]'s neck with \the [tool].</span>")
	..()

/datum/surgery_step/head/prepare/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(is_same_target != affected) //We are not aiming at the same organ as when be begun, cut him up
		user << "<span class='warning'><b>You failed to start the surgery.</b> Aim at the same organ as the one that you started working on originally.</span>"
		return
	user.visible_message("<span class='notice'>[user] has finished adjusting the area around [target]'s neck with \the [tool].</span>",	\
	"<span class='notice'>You have finished adjusting the area around [target]'s neck with \the [tool].</span>")
	target.op_stage.head_reattach = 0
	affected.status |= ORGAN_ATTACHABLE
	affected.amputated = 1
	affected.setAmputatedTree()
	affected.open = 0

/datum/surgery_step/head/prepare/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(affected.parent)
		affected = affected.parent
		user.visible_message("<span class='warning'>[user]'s hand slips, searing [target]'s neck!</span>", \
		"<span class='warning'>Your hand slips, searing [target]'s [affected.display_name]!</span>")
		target.apply_damage(10, BURN, affected)
		target.updatehealth()

/datum/surgery_step/head/attach
	allowed_tools = list(/obj/item/weapon/organ/head = 100)
	can_infect = 0

	min_duration = 60
	max_duration = 80

/datum/surgery_step/head/attach/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/datum/organ/external/head = target.get_organ(target_zone)
		return head.status & ORGAN_ATTACHABLE

/datum/surgery_step/head/attach/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	is_same_target = affected
	user.visible_message("<span class='notice'>[user] starts attaching [tool] to [target]'s reshaped neck.</span>", \
	"<span class='notice'>You start attaching [tool] to [target]'s reshaped neck.</span>")

/datum/surgery_step/head/attach/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(is_same_target != affected) //We are not aiming at the same organ as when be begun, cut him up
		user << "<span class='warning'><b>You failed to start the surgery.</b> Aim at the same organ as the one that you started working on originally.</span>"
		return
	user.visible_message("<span class='notice'>[user] has attached [target]'s head to the body.</span>",	\
	"<span class='notice'>You have attached [target]'s head to the body.</span>")

	//Update our dear victim to have a head again

	affected.status = 0
	affected.amputated = 0
	affected.destspawn = 0
	target.updatehealth()
	target.update_body()
	target.UpdateDamageIcon()

	//Prepare mind datum

	var/obj/item/weapon/organ/head/B = tool

	if(B.brainmob.mind)
		B.brainmob.mind.transfer_to(target)

	//Deal with the head item properly
	user.temp_drop_inv_item(B)
	cdel(B)

/datum/surgery_step/head/attach/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, damaging connectors on [target]'s neck!</span>", \
	"<span class='warning'>Your hand slips, damaging connectors on [target]'s neck!</span>")
	target.apply_damage(10, BRUTE, affected, sharp = 1)
	target.updatehealth()