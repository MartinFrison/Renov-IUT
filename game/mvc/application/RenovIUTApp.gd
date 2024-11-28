class_name RenovIUTApp
extends Node

static var app : RenovIUTApp
var scene
var illkirch : IUTFacade
var panelChoixScenario : Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("start")
	
	app = self
	Utils.create_iut_db()
	illkirch = IUTFacade.new()
	add_child(illkirch)
	
	scene = load("res://mvc/views/Node2D/choixScenario/PanelChoixScenario.tscn")
	panelChoixScenario = scene.instantiate()
	add_child(panelChoixScenario)
	if panelChoixScenario.has_method("init"):
		panelChoixScenario.init(illkirch, self)





#Fonction appelé une fois que le jeu est chargé pour que les actions n'engendre pas de bug
func game_loaded() -> void:
	open_building(1)



func startGame() -> void:
	if panelChoixScenario:
		print("On va supprimer le panel.")
		panelChoixScenario.queue_free()  # Marquer le nœud pour suppression
	else:
		print("Le panel est déjà supprimé.")
		
	illkirch.startGame()





func close_app() -> void:
	Utils.db.clear_tables()
	Utils.db.close_db()


func open_notif() -> void:
	scene = load("res://mvc/views/Node2D/NotifList/PanelNotifList.tscn")
	var panelNotif = scene.instantiate()
	add_child(panelNotif)

func open_bankrupt() -> void:
		scene = load("res://mvc/views/Node2D/FinJeu/PanelBankrupt.tscn")
		var panelBankrupt = scene.instantiate()
		add_child(panelBankrupt)


func open_building(id) -> void:
	var panelAction = get_tree().get_current_scene().get_node("BuildingAction")
	panelAction.init(id)



func _on_next_pressed() -> void:
	illkirch._time.next_Trimestre()
