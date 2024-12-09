extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_result()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func show_result() -> void:
	var node = get_node("Message")
	node.text = "Sous votre manda, x étudiant on pu intégrer une école d'ingénieur
	à l'issu de leur formation"
	
