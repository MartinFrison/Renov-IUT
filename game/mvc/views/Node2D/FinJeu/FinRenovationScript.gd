extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TimeManagement.pause(true)
	show_result()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func show_result() -> void:
	var node
	var dept
	
	node = "Message"
	node = get_node(node)
	node.text = "Vous avez finit la rénovation des batiments félicitation ! \nCela vous a prit %s mois et %s jours" % [(GlobalData._year-2025)*12, GlobalData._day]
