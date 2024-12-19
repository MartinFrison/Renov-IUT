extends Node2D


func init(scenario : Scenario):
	show_result(scenario)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func show_result(scenario : Scenario) -> void:
	# Sur le nombre de d'étudiant ayant rejoins une école d'ingénieur
	var audio_player = get_node("win")
	audio_player.play()
	
	var node = get_node("Message")
	node.text = "Voici le bilan de votre quête à l'élitisme"
	
	# Sur le nombre de diplomé
	node = get_node("Message2")
	node.text = scenario.player_report() 



func _on_quitter_pressed() -> void:
	get_tree().quit() 
