extends Node3D

# Chemins vers les ressources utilisées pour les arbres (troncs, feuilles, textures, masques).
const trunc_path: String = "res://mvc/views/Node3D/tree/trunc.tres"
const material_path: String = "res://mvc/views/Node3D/tree/leaf.tres"
const texture_path: String = "res://mvc/views/Node3D/tree/Leaf1.png"
const mask_path: String = "res://mvc/views/Node3D/tree/Leaf1.png"

# Appelée lorsque le nœud entre dans la scène pour la première fois.
func _ready() -> void:
	# Enregistre ce nœud en tant qu'observateur des données globales.
	ObserverGlobalData.addObserver(self)

# Fonction récursive pour appliquer les matériaux aux MeshInstance3D dans la hiérarchie d'un nœud.
func apply_material_to_mesh_instances(node: Node3D, material: Material, trunc: Material) -> void:
	for child in node.get_children():
		# Si l'enfant est un MeshInstance3D, applique un matériau spécifique.
		if child is MeshInstance3D:
			child.material_override = trunc  # Applique le matériau pour le tronc.
			# Parcourt les enfants de l'enfant pour appliquer un matériau aux sous-meshes.
			for child2 in child.get_children():
				if child2 is MeshInstance3D:
					child2.material_override = material  # Applique le matériau pour les feuilles.

# Notifie les changements de saison et applique les matériaux correspondants.
func notifyDateChanged() -> void: 
	if GlobalData._month <= 2 or GlobalData._month >= 12:
		winter()  # Applique les textures et matériaux pour l'hiver.
	elif GlobalData._month <= 5:
		printer()  # Applique les textures et matériaux pour le printemps.
	elif GlobalData._month <= 8:
		summer()  # Applique les textures et matériaux pour l'été.
	elif GlobalData._month <= 11:
		autumn()  # Applique les textures et matériaux pour l'automne.

# Applique les textures et matériaux pour l'été.
func summer():
	var material = ResourceLoader.load(material_path) as ShaderMaterial  # Charge le matériau pour les feuilles.
	var texture = ResourceLoader.load(texture_path) as Texture2D  # Charge la texture principale.
	var mask = ResourceLoader.load(mask_path) as Texture2D  # Charge le masque alpha.
	var trunc = ResourceLoader.load(trunc_path) as StandardMaterial3D  # Charge le matériau pour le tronc.
	
	# Vérification des ressources chargées.
	if material == null or texture == null or mask == null:
		print("Erreur : Matériau, texture ou masque introuvable.")
		return
	if material is not ShaderMaterial:
		print("Erreur : Le matériau n'est pas un ShaderMaterial.")
		return
	
	# Charge et applique le shader spécifique à l'été.
	var shader = load("res://mvc/views/Node3D/tree/summer_leaf.gdshader") as Shader
	material.shader = shader
	material.set_shader_parameter("texture", texture)  # Applique la texture principale.
	material.set_shader_parameter("alpha_texture", mask)  # Applique le masque alpha.

	# Applique les matériaux à tous les arbres dans la hiérarchie.
	for tree in get_children():
		apply_material_to_mesh_instances(tree, material, trunc)

# Applique les textures et matériaux pour l'hiver.
func winter():
	var material = ResourceLoader.load("res://mvc/views/Node3D/tree/winter_leaf.tres") as StandardMaterial3D  # Matériau des feuilles pour l'hiver.
	var texture = ResourceLoader.load(texture_path) as Texture2D
	var mask = ResourceLoader.load(mask_path) as Texture2D
	var trunc = ResourceLoader.load(trunc_path) as StandardMaterial3D  # Matériau du tronc.
	
	# Vérification des ressources chargées.
	if material == null or texture == null or mask == null:
		print("Erreur : Matériau, texture ou masque introuvable.")
		return
	
	# Applique les matériaux aux arbres.
	for tree in get_children():
		apply_material_to_mesh_instances(tree, material, trunc)

# Applique les textures et matériaux pour le printemps.
func printer():
	var material = ResourceLoader.load(material_path) as ShaderMaterial  # Matériau des feuilles pour le printemps.
	var texture = ResourceLoader.load(texture_path) as Texture2D
	var mask = ResourceLoader.load(mask_path) as Texture2D
	var trunc = ResourceLoader.load(trunc_path) as StandardMaterial3D  # Matériau du tronc.
	
	# Vérification des ressources chargées.
	if material == null or texture == null or mask == null:
		print("Erreur : Matériau, texture ou masque introuvable.")
		return
	if material is not ShaderMaterial:
		print("Erreur : Le matériau n'est pas un ShaderMaterial.")
		return
	
	# Charge et applique le shader spécifique au printemps.
	var shader = load("res://mvc/views/Node3D/tree/printer_leaf.gdshader") as Shader
	material.shader = shader
	material.set_shader_parameter("texture", texture)  # Applique la texture principale.
	material.set_shader_parameter("alpha_texture", mask)  # Applique le masque alpha.

	# Applique les matériaux à tous les arbres dans la hiérarchie.
	for tree in get_children():
		apply_material_to_mesh_instances(tree, material, trunc)

# Applique les textures et matériaux pour l'automne.
func autumn():
	var material = ResourceLoader.load(material_path) as ShaderMaterial  # Matériau des feuilles pour l'automne.
	var texture = ResourceLoader.load(texture_path) as Texture2D
	var mask = ResourceLoader.load(mask_path) as Texture2D
	var trunc = ResourceLoader.load(trunc_path) as StandardMaterial3D  # Matériau du tronc.
	
	# Vérification des ressources chargées.
	if material == null or texture == null or mask == null:
		print("Erreur : Matériau, texture ou masque introuvable.")
		return
	if material is not ShaderMaterial:
		print("Erreur : Le matériau n'est pas un ShaderMaterial.")
		return
	
	# Charge et applique le shader spécifique à l'automne.
	var shader = load("res://mvc/views/Node3D/tree/autumn_leaf.gdshader") as Shader
	material.shader = shader
	material.set_shader_parameter("texture", texture)  # Applique la texture principale.
	material.set_shader_parameter("alpha_texture", mask)  # Applique le masque alpha.

	# Applique les matériaux à tous les arbres dans la hiérarchie.
	for tree in get_children():
		apply_material_to_mesh_instances(tree, material, trunc)
