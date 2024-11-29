extends Node3D

const trunc_path: String = "res://mvc/views/Node3D/tree/trunc.tres"
const material_path: String = "res://mvc/views/Node3D/tree/leaf.tres"
const texture_path: String = "res://mvc/views/Node3D/tree/Leaf1.png"
const mask_path: String = "res://mvc/views/Node3D/tree/Leaf1.png"




func _ready() -> void:
	ObserverGlobalData.addObserver(self)
	
	

# Fonction récursive pour appliquer le matériau à tous les MeshInstance3D
func apply_material_to_mesh_instances(node: Node3D, material: Material, trunc: Material) -> void:
	for child in node.get_children():
		if child is MeshInstance3D:
			child.material_override = trunc
			for child2 in child.get_children():
				if child2 is MeshInstance3D:
					child2.material_override = material



func notifyDateChanged() -> void: 
	if GlobalData._month <=2 or GlobalData._month>=12:
		winter()
	elif GlobalData._month <=5:
		printer()
	elif GlobalData._month <=8:
		summer()
	elif GlobalData._month <=11:
		autumn()



func summer():
	var material = ResourceLoader.load(material_path) as ShaderMaterial  # Assurez-vous que le matériau est un ShaderMaterial
	var texture = ResourceLoader.load(texture_path) as Texture2D  # Charger la texture comme Texture2D
	var mask = ResourceLoader.load(mask_path) as Texture2D  # Charger le masque comme Texture2D
	var trunc = ResourceLoader.load(trunc_path) as StandardMaterial3D
	
	# Vérification des ressources chargées
	if material == null or texture == null or mask == null:
		print("Erreur : Matériau, texture ou masque introuvable.")
		return
	if material is not ShaderMaterial:
		print("Erreur : Le matériau n'est pas un ShaderMaterial.")
		return
	
	var shader = load("res://mvc/views/Node3D/tree/summer_leaf.gdshader") as Shader  # Remplacez par le chemin vers votre shader
	material.shader = shader

	material.set_shader_parameter("texture", texture)  # Applique la texture principale
	material.set_shader_parameter("alpha_texture", mask)  # Applique le masque

	for tree in get_children():
		apply_material_to_mesh_instances(tree, material, trunc)



func winter():
	var material = ResourceLoader.load("res://mvc/views/Node3D/tree/winter_leaf.tres") as StandardMaterial3D
	var texture = ResourceLoader.load(texture_path) as Texture2D  # Charger la texture comme Texture2D
	var mask = ResourceLoader.load(mask_path) as Texture2D  # Charger le masque comme Texture2D
	var trunc = ResourceLoader.load(trunc_path) as StandardMaterial3D
	
	# Vérification des ressources chargées
	if material == null or texture == null or mask == null:
		print("Erreur : Matériau, texture ou masque introuvable.")
		return
	for tree in get_children():
		apply_material_to_mesh_instances(tree, material, trunc)


func printer():
	var material = ResourceLoader.load(material_path) as ShaderMaterial  # Assurez-vous que le matériau est un ShaderMaterial
	var texture = ResourceLoader.load(texture_path) as Texture2D  # Charger la texture comme Texture2D
	var mask = ResourceLoader.load(mask_path) as Texture2D  # Charger le masque comme Texture2D
	var trunc = ResourceLoader.load(trunc_path) as StandardMaterial3D
	
	# Vérification des ressources chargées
	if material == null or texture == null or mask == null:
		print("Erreur : Matériau, texture ou masque introuvable.")
		return
	# Vérification que le matériau est bien un ShaderMaterial
	if material is not ShaderMaterial:
		print("Erreur : Le matériau n'est pas un ShaderMaterial.")
		return
	
	var shader = load("res://mvc/views/Node3D/tree/printer_leaf.gdshader") as Shader 
	material.shader = shader

	material.set_shader_parameter("texture", texture)  # Applique la texture principale
	material.set_shader_parameter("alpha_texture", mask)  # Applique le masque

	for tree in get_children():
		apply_material_to_mesh_instances(tree, material, trunc)


func autumn():
	var material = ResourceLoader.load(material_path) as ShaderMaterial  # Assurez-vous que le matériau est un ShaderMaterial
	var texture = ResourceLoader.load(texture_path) as Texture2D  # Charger la texture comme Texture2D
	var mask = ResourceLoader.load(mask_path) as Texture2D  # Charger le masque comme Texture2D
	var trunc = ResourceLoader.load(trunc_path) as StandardMaterial3D
	
	# Vérification des ressources chargées
	if material == null or texture == null or mask == null:
		print("Erreur : Matériau, texture ou masque introuvable.")
		return
	# Vérification que le matériau est bien un ShaderMaterial
	if material is not ShaderMaterial:
		print("Erreur : Le matériau n'est pas un ShaderMaterial.")
		return
	
	var shader = load("res://mvc/views/Node3D/tree/autumn_leaf.gdshader") as Shader
	material.shader = shader

	material.set_shader_parameter("texture", texture)  # Applique la texture principale
	material.set_shader_parameter("alpha_texture", mask)  # Applique le masque

	for tree in get_children():
		apply_material_to_mesh_instances(tree, material, trunc)
