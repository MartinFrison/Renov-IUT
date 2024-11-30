extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_result()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func show_result() -> void:
	var node
	var dept
	
	node = "Message"
	node = get_node(node)
	node.text = "Vous avez fini la rénovation des batiments, félicitations ! \nCela vous a pris %s mois et %s jours." % [(GlobalData._year-2025)*12, GlobalData._day]
