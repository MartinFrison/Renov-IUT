extends Node3D

const trunc_path: String = "res://mvc/views/Node3D/tree/trunc.tres"
const material_path: String = "res://mvc/views/Node3D/tree/leaf.tres"
const texture_path: String = "res://mvc/views/Node3D/tree/Leaf1.png"
const mask_path: String = "res://mvc/views/Node3D/tree/Leaf1.png"


func _ready() -> void:
	print("Chargement des matériaux dans l'éditeur...")
	
	# Charger les ressources dynamiquement
	var material = ResourceLoader.load(material_path) as ShaderMaterial  # Assurez-vous que le matériau est un ShaderMaterial
	var texture = ResourceLoader.load(texture_path) as Texture2D  # Charger la texture comme Texture2D
	var mask = ResourceLoader.load(mask_path) as Texture2D  # Charger le masque comme Texture2D
	var trunc = ResourceLoader.load(trunc_path) as StandardMaterial3D
	
	
	# Vérification des ressources chargées
	if material == null or texture == null or mask == null:
		print("Erreur : Matériau, texture ou masque introuvable.")
		return
	
	print(material.resource_path)
	
	# Vérification que le matériau est bien un ShaderMaterial
	if material is not ShaderMaterial:
		print("Erreur : Le matériau n'est pas un ShaderMaterial.")
		return
	
	# Charger le shader depuis le fichier (assurez-vous que le chemin est correct)
	var shader = load("res://mvc/views/Node3D/tree/alpha.gdshader") as Shader  # Remplacez par le chemin vers votre shader
	material.shader = shader

	# Appliquer les textures au shader en utilisant set_shader_parameter
	material.set_shader_parameter("texture", texture)  # Applique la texture principale
	material.set_shader_parameter("alpha_texture", mask)  # Applique le masque

	# Appliquer le matériau aux MeshInstance3D enfants
	for tree in get_children():
		apply_material_to_mesh_instances(tree, material, trunc)
	print("Matériau appliqué à tous les MeshInstance3D.")



# Fonction récursive pour appliquer le matériau à tous les MeshInstance3D
func apply_material_to_mesh_instances(node: Node3D, material: Material, trunc: Material) -> void:
	for child in node.get_children():
		if child is MeshInstance3D:
			child.material_override = trunc
			for child2 in child.get_children():
				if child2 is MeshInstance3D:
					child2.material_override = material
