extends Camera3D

func _input(event):
	# Vérifie si un clic gauche a eu lieu
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Génère un rayon basé sur la position de la souris
		print("input")
		var ray_origin = project_ray_origin(event.position)
		var ray_direction = project_ray_normal(event.position) * 1000  # Distance arbitraire
		var space_state = get_world_3d().direct_space_state

		# Vérifie les collisions avec des objets 3D
		var query = PhysicsRayQueryParameters3D.new()
		query.from = ray_origin
		query.to = ray_origin + ray_direction
		var result = space_state.intersect_ray(query)
		
		
		if result:
			print("Clique détecté sur : ", result.collider.name)
			for i in range (1,6):
				if "colision" + str(i) == result.collider.name:
					RenovIUTApp.app.open_building(i)
