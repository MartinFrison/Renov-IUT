extends Camera3D

func _input(event):
	# Vérifiez si c'est un clic gauche de la souris
	if event is InputEventMouseButton and event.pressed:
		handle_3d_click(event)
	elif event is InputEventMouseMotion:
		handle_hover(event)


func handle_3d_click(event: InputEventMouseButton):
	# Génère un rayon basé sur la position de la souris
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
		for i in range(1, 6):
			if "colision" + str(i) == result.collider.name:
				RenovIUTApp.app.open_building(i)



func handle_hover(event : InputEventMouseMotion):
	# Génère un rayon basé sur la position de la souris
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
		for i in range(1, 6):
			if "colision" + str(i) == result.collider.name:
				big_build(i)

func big_build(i : int) -> void:
	var iut = get_tree().current_scene.get_node("Vue3D/IUT_V4")
	print(iut.name)
