extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Si on a perdu on joue un son
	var audio_player = get_node("lost")
	audio_player.play()

# Le joueur peut cliquer sur un bouton pour quitter le jeu
func _on_quitter_pressed() -> void:
	get_tree().quit() 
