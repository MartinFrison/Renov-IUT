extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var audio_player = get_node("lost")
	audio_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_quitter_pressed() -> void:
	get_tree().quit() 
