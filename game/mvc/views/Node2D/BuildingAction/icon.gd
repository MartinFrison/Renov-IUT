extends Sprite2D

# Variable pour stocker le chemin de l'image
var image_dir: String = "res://mvc/views/images/backgrounds/outlines/"
var image_name: String = "engineering_building.png" # default

# Appelé lorsque le nœud entre dans l'arbre de la scène pour la première fois.
func _ready() -> void:
	load_image(image_dir + image_name)  # Charger l'image au démarrage

# Fonction pour charger l'image
func load_image(path: String) -> void:
	self.texture = load(path)

# Fonction pour changer dynamiquement l'image si nécessaire
func change_image(new_path: String) -> void:
	var image_path: String = new_path
	load_image(image_path)
