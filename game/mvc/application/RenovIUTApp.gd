class_name RenovIUTApp
extends Node

var scene
var panelChoixScenario : Node2D
var panelChoixDifficulty : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var label = get_tree().get_root().get_node("Node2D/Label")
	label = label as Label
	label.text = "Bonjour"
	Utils.create_iut_db()
	
	var illkirch = IUTFacade.new()
	scene = load("res://mvc/views/Node2D/PanelChoixScenario.tscn")
	panelChoixScenario = scene.instantiate()
	add_child(panelChoixScenario)
	
	if panelChoixScenario.has_method("init"):
		panelChoixScenario.init(illkirch, self)


func choiceDifficulty() -> void:
	if panelChoixScenario:
		print("On va supprimer le panel.")
		panelChoixScenario.queue_free()  # Marquer le nœud pour suppression
	else:
		print("Le panel est déjà supprimé.")


func close_app() -> void:
	Utils.db.clear_tables()
	Utils.db.close_db()
