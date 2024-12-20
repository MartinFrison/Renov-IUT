extends Node2D

# Fonction d'initialisation avec en parametre la référence au scénario qui était joué
func init(scenario : Scenario):
	show_result(scenario)



# Affiche le rapport de fin de partie avec nottament le temps qu'ont pris les rénovations
func show_result(scenario : Scenario) -> void:
	# Sur le nombre de d'étudiant ayant rejoins une école d'ingénieur
	var audio_player = get_node("win")
	audio_player.play()
	
	var node = get_node("Message")
	node.text = "Voici le bilan de votre quête à l'élitisme."
	
	# Sur le nombre de diplomé
	node = get_node("Message2")
	node.text = scenario.player_report() 


# Le joueur peut cliquer sur un bouton pour quitter le jeu
func _on_quitter_pressed() -> void:
	get_tree().quit() 
