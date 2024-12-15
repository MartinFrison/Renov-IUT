extends Camera3D

#Taille par defaut
var _default_scale = [0,0,0,0,0,0]
var _building : Array[MeshInstance3D] = [null, null, null, null, null, null]
var big = false

func _ready() -> void:
	_building[1] = get_tree().current_scene.get_node("Vue3D/IUT_V4/batiment_chimie") as MeshInstance3D
	_building[2] = get_tree().current_scene.get_node("Vue3D/IUT_V4/batiment_genie_civil") as MeshInstance3D
	_building[3] = get_tree().current_scene.get_node("Vue3D/IUT_V4/Batiment_Administration") as MeshInstance3D
	_building[4] = get_tree().current_scene.get_node("Vue3D/IUT_V4/bat_info") as MeshInstance3D
	_building[5] = get_tree().current_scene.get_node("Vue3D/IUT_V4/Batiment_infocom") as MeshInstance3D
	for i in range (1,6):
		_default_scale[i] = _building[i].scale


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
		for i in range(1, 6):
			if "colision" + str(i) == result.collider.name:
				big_build(i)
				Input.set_default_cursor_shape(2)
				return
	if big == true:
		big_build(-1)
		Input.set_default_cursor_shape(0)

func big_build(build : int) -> void:
	for i in range(1,6):
		_building[i].scale = _default_scale[i] * 1
	if build > 0:
		_building[build].scale = _default_scale[build] * 1.12
		big = true
	else:
		big = false
