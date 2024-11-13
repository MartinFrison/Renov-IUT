class_name RenovIUTApp
extends Node

static var app : RenovIUTApp
var scene
var illkirch : IUTFacade
var panelChoixScenario : Node2D
var panelChoixDifficulty : Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("start")
	app = self
	var label = get_tree().get_root().get_node("Node2D/Label")
	label = label as Label
	label.text = "Bonjour"
	Utils.create_iut_db()
	illkirch = IUTFacade.new()
	add_child(illkirch)
	
	scene = load("res://mvc/views/Node2D/choixScenario/PanelChoixScenario.tscn")
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
		
	scene = load("res://mvc/views/Node2D/choixDifficulty/PanelChoixDifficulty.tscn")
	panelChoixDifficulty = scene.instantiate()
	add_child(panelChoixDifficulty)
	if panelChoixDifficulty.has_method("init"):
		panelChoixDifficulty.init(illkirch, self)


func start_game() -> void:
	if panelChoixScenario:
		print("On va supprimer le panel.")
		panelChoixDifficulty.queue_free()  # Marquer le nœud pour suppression
	else:
		print("Le panel est déjà supprimé.")
		
	illkirch.startGame()


func close_app() -> void:
	Utils.db.clear_tables()
	Utils.db.close_db()
