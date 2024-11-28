class_name RenovIUTApp
extends Node

static var app : RenovIUTApp
var scene
var illkirch : IUTFacade
var panelChoixScenario : Node2D
var loaded = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("start")
	
	for i in range (1,6):
		building_work(i, false)
	
	
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
	loaded = true
	open_building(1)
	print("Game loaded")

#Lance le jeu avec le scénario et mode de jeu choisie
func startGame() -> void:
	if panelChoixScenario:
		print("On va supprimer le panel.")
		panelChoixScenario.queue_free()  # Marquer le nœud pour suppression
	else:
		print("Le panel est déjà supprimé.")
		
	illkirch.startGame()


# Ferme l'appli
func close_app() -> void:
	Utils.db.clear_tables()
	Utils.db.close_db()


# Affiche une notification
func open_notif() -> void:
	scene = load("res://mvc/views/Node2D/NotifList/PanelNotifList.tscn")
	var panelNotif = scene.instantiate()
	add_child(panelNotif)

# Affiche la fin du jeu ou on fait faillite
func open_bankrupt() -> void:
		scene = load("res://mvc/views/Node2D/FinJeu/PanelBankrupt.tscn")
		var panelBankrupt = scene.instantiate()
		add_child(panelBankrupt)

# Afficher les info et action d'un batiment
func open_building(id) -> void:
	if loaded:
		var panelAction = get_tree().get_current_scene().get_node("BuildingAction")
		panelAction.init(id)


# Passer au trimestre suivant à la demande du joueur
func _on_next_pressed() -> void:
	illkirch._time.next_Trimestre()


# Affiche/Masque les travaux d'un batiment
func building_work(id : int, visible : bool) -> void:
	var path = "Vue3D/Travaux/Travaux" + str(id)
	var work_build = get_tree().get_current_scene().get_node(path)
	work_build = work_build as Node3D
	work_build.visible = visible
