extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_result()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func show_result() -> void:
	var node
	var dept = null
	
	node = "Message"
	node = get_node(node)
	var years = (GlobalData._year-2025)
	var months = GlobalData._month

	if years == 0 and months >= 9:        # on est toujours en 2025, après septembre
		node.text = "Vous avez fini la rénovation des bâtiments, félicitations ! \nCela vous a pris %s mois." % [months - 8]  # compte les mois après septembre
	elif years == 1 and months == 0:       # en septembre 2026
		node.text = "Vous avez fini la rénovation des bâtiments, félicitations ! \nCela vous a pris une année."
	elif years == 1:                        # Pour l'année 2026
		node.text = "Vous avez fini la rénovation des bâtiments, félicitations ! \nCela vous a pris %s mois." % [months + 3]  # Ajustement pour les mois restants de 2026
	elif months == 0:                       # Cas particulier pour septembre d'une année suivante
		node.text = "Vous avez fini la rénovation des bâtiments, félicitations ! \nCela vous a pris %s années." % years
	else:                                   # Cas général pour plusieurs années et mois
		node.text = "Vous avez fini la rénovation des bâtiments, félicitations ! \nCela vous a pris %s années et %s mois." % [years, months+3]
