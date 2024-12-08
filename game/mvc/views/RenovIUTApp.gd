class_name RenovIUTApp
extends Node

static var app : RenovIUTApp
var scene
var illkirch : IUTFacade
var panelChoixScenario : Node2D
var loaded = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("start")
	
	#Masquer tout les travaux au début
	for i in range (1,6):
		building_work(i, false)
	
	#Créer la base de donnée
	app = self
	Utils.create_iut_db()
	illkirch = IUTFacade.new()
	add_child(illkirch)
	ObserverGlobalData.addObserver(self)
	ObserverBuilding.addObserver(self)
	
	#Affichage du panel de choix du scénario et du mode 
	scene = load("res://mvc/views/Node2D/choixScenario/PanelChoixScenario.tscn")
	panelChoixScenario = scene.instantiate()
	add_child(panelChoixScenario)
	if panelChoixScenario.has_method("init"):
		panelChoixScenario.init(illkirch, self)



#Lance le jeu avec le scénario et mode de jeu choisie
func startGame() -> void:
	if panelChoixScenario:
		print("On va supprimer le panel.")
		panelChoixScenario.queue_free()  # Marquer le nœud pour suppression
	else:
		print("Le panel a déjà été supprimé.")
		
	illkirch.startGame()



#Fonction appelé une fois que le jeu est chargé pour que les actions n'engendre pas de bug
func game_loaded() -> void:
	loaded = true
	open_building(1)
	print("Game loaded")


# Passer au trimestre suivant à la demande du joueur
func _on_next_pressed() -> void:
	var band = get_node("PanelStat/friseAttente")
	band.visible = true
	await get_tree().create_timer(1.0).timeout
	illkirch._time.next_Trimestre()
	band.visible = false
	

# Ferme l'appli
func close_app() -> void:
	Utils.db.clear_tables()
	Utils.db.close_db()


# Affiche une notification
func open_notif() -> void:
	scene = load("res://mvc/views/Node2D/NotifList/PanelNotifList.tscn")
	var panelNotif = scene.instantiate()
	add_child(panelNotif)

# Affiche la fin du jeu ou on fait faillite
func open_bankrupt() -> void:
		scene = load("res://mvc/views/Node2D/FinJeu/PanelBankrupt.tscn")
		var panelBankrupt = scene.instantiate()
		add_child(panelBankrupt)

# Afficher les info et action d'un batiment
func open_building(id) -> void:
	if loaded:
		var panelAction = get_tree().get_current_scene().get_node("BuildingAction")
		panelAction.init(id)



# Affiche/Masque les travaux d'un batiment
func building_work(id : int, visible : bool) -> void:
	var path = "Vue3D/Travaux/Travaux" + str(id)
	var work_build = get_tree().get_current_scene().get_node(path)
	work_build = work_build as Node3D
	work_build.visible = visible


#Réagir quand la date change pour mettre de la neige en hivert
func notifyDateChanged() -> void:
	var herbe = load("res://mvc/views/Node3D/IUT_V4/material/herbe.tres") as StandardMaterial3D
	var snow = load("res://mvc/views/Node3D/IUT_V4/material/snow.tres") as StandardMaterial3D
	var plane = get_tree().get_current_scene().get_node("Vue3D/IUT_V4/herbe")
	plane = plane as MeshInstance3D
	if GlobalData._month >= 12 or GlobalData._month <= 2:
		plane.material_override = snow
	else:
		plane.material_override = herbe



#Réagir au changement détat des batiments
func notifyStateChanged() -> void:
	var _building : Array[MeshInstance3D] = [null, null, null, null, null, null]
	_building[1] = get_tree().current_scene.get_node("Vue3D/IUT_V4/batiment_chimie") as MeshInstance3D
	_building[2] = get_tree().current_scene.get_node("Vue3D/IUT_V4/batiment_genie_civil") as MeshInstance3D
	_building[3] = get_tree().current_scene.get_node("Vue3D/IUT_V4/Batiment_Administration") as MeshInstance3D
	_building[4] = get_tree().current_scene.get_node("Vue3D/IUT_V4/bat_info") as MeshInstance3D
	_building[5] = get_tree().current_scene.get_node("Vue3D/IUT_V4/Batiment_infocom") as MeshInstance3D
	for i in range(1, 6):
		var build = Building.get_building(Utils.dept_index_to_string(i))
		var crack_intensity = int((100-build.get_inventory())/25)
		crack_intensity = ((float(crack_intensity))/4)**2
		var mesh3D = _building[i]
		var crack = ResourceLoader.load("res://mvc/views/Node3D/IUT_V4/crack.webp") as Texture2D
		
		if mesh3D is MeshInstance3D:  # Vérifiez que le node est bien un MeshInstance3D
			var mesh = mesh3D.mesh
			 
			if mesh and mesh is ArrayMesh:  # Assurez-vous que le mesh est un ArrayMesh
				for material_index in mesh.get_surface_count():
					var material = mesh.surface_get_material(material_index)
					var name = material.resource_name
					if material is ShaderMaterial:
						# Si le matériau utilise déjà le shader, on ajuste uniquement l'intensité
						material.set_shader_parameter("crack_intensity", crack_intensity)
						material.set_shader_parameter("crack", crack)
					elif material and name.begins_with("mur"):
						# Remplace le matériau par un ShaderMaterial si ce n'est pas déjà le cas
						var new_material = ShaderMaterial.new()
						var shader = load("res://mvc/views/Node3D/IUT_V4/material/crack.gdshader")
						new_material.shader = shader
						new_material.set_shader_parameter("crack_intensity", crack_intensity)
						new_material.set_shader_parameter("crack", crack)
							
						# Transfert des propriétés du matériau existant
						if material is StandardMaterial3D:
							new_material.set_shader_parameter("color", material.albedo_color)
							new_material.set_shader_parameter("albedo", material.albedo_color)
							new_material.set_shader_parameter("roughness", material.roughness)
							new_material.set_shader_parameter("metallic", material.metallic)
							if material.normal_texture:
								new_material.set_shader_parameter("normal_map", material.normal_texture)
							if material.roughness_texture:
								new_material.set_shader_parameter("roughness_map", material.roughness_texture)
							if material.metallic_texture:
								new_material.set_shader_parameter("metallic_map", material.metallic_texture)
						
						# Remplace le matériau sur la surface
						mesh.surface_set_material(material_index, new_material)

		
