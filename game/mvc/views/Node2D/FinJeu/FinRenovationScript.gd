extends Node2D


func init(scenario : Scenario):
	show_result(scenario)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func show_result(scenario : Scenario) -> void:
	var audio_player = get_node("win")
	audio_player.play()
	
	var titre = get_node("MessageTitre") as Label
	titre.text = "Les rénovations sont terminées !"
	
	var msg = get_node("Message") as Label
	msg.text = scenario.player_report()
