extends Node2D

# Fonction d'initialisation avec en parametre la référence au scénario qui était joué
func init(scenario : Scenario):
	show_result(scenario)


func show_result(scenario : Scenario) -> void:
	var audio_player = get_node("win")
	audio_player.play()
	
	var titre = get_node("MessageTitre") as Label
	titre.text = "Les rénovations sont terminées !"
	
	var msg = get_node("Message") as Label
	msg.text = scenario.player_report()


# Le joueur peut cliquer sur un bouton pour quitter le jeu
func _on_quitter_pressed() -> void:
	get_tree().quit() 
