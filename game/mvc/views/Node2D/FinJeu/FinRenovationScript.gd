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
	if months < 9: #début de l'année
		months = months + 4 # septembre, octobre, novembre, décembre
	else:	
		months = months - 9 
	if years == 0:
		node.text = "Vous avez fini la rénovation des bâtiments, félicitations ! \nCela vous a pris %s mois." % [months]
	elif years == 1 and months == 0:
		node.text = "Vous avez fini la rénovation des bâtiments, félicitations ! \nCela vous a pris une année."
	elif years == 1:	
		node.text = "Vous avez fini la rénovation des bâtiments, félicitations ! \nCela vous a pris une année et %s mois." % [months]
	elif months == 0:
		node.text = "Vous avez fini la rénovation des bâtiments, félicitations ! \nCela vous a pris %s années." % [years]
	else:
		node.text = "Vous avez fini la rénovation des bâtiments, félicitations ! \nCela vous a pris %s années et %s mois." % [years, months]
