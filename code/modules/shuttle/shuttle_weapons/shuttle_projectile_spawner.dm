/proc/fire_projectile_towards(atom/target, spawn_distance = 45, projectile_type = /obj/projectile/beam/laser, missed = FALSE)
	var/angle = rand(0, 360)
	var/x_pos = clamp(target.x + spawn_distance * sin(angle), 6, world.maxx - 6)
	var/y_pos = clamp(target.y + spawn_distance * cos(angle), 6, world.maxy - 6)
	var/turf/spawn_turf = locate(x_pos, y_pos, target.z)
	//Create the projectile
	var/obj/projectile/P = new projectile_type(spawn_turf)
	if(missed)
		var/obj/projectile/bullet/shuttle/shuttle_proj = P
		if(istype(shuttle_proj))
			shuttle_proj.miss = missed
	P.preparePixelProjectile(get_turf(target), spawn_turf)
	P.fire()
