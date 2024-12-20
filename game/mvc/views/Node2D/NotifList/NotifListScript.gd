extends Node2D

var notif : Array
var page : int
var page_size : int = 8
var buttons : Array[Button]



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var message = get_node("Text")
	message.visible = false
	z_index = 2
	# Récupère la liste de toutes les notifs déjà recu
	notif = Notification.get_all_ids()
	# Définie l'index de page à 0
	page = 0	
	# Affiche la page 0
	open_page()


# Affiche la page de notif séléctionner (une page = 8 notifs)
func open_page() -> void:
	for i in buttons:
		i.queue_free()
	buttons.clear()
	# On créer autant de bouton que la taille de page le prévois
	for p in page_size:
		# Selon la page séléctionner on remonte plus ou moins loin dans 
		# l'historique des notifs
		var i = notif.size() - 1 - ((page * page_size) + p)
		if notif.size() > i and i >= 0:
			var id = notif[i]
			create_question_button(Notification.get_object(id), id, p)


# Affiche le bouton correspondant à une notifs
func create_question_button(text : String, id : int, n) -> void:
	# Créer un bouton
	var button = Button.new()
	buttons.append(button)
	
	# Définie le texte, la taille et la position du bouton
	button.text = text
	button.size = Vector2(278, 25)
	button.position = Vector2(15, n * 35 + 15)
	# On ajoute le bouton au panel
	var panel = get_node("PanelNotif")
	panel.add_child(button)
	
	# Ajoute une connection avec un bouton
	# pour qu'il puissent afficher la bonne notif quand on clique dessus
	button.mouse_default_cursor_shape = Input.CURSOR_POINTING_HAND
	button.pressed.connect(Callable(notif_pressed).bind(id))


# Si on clique sur une notif sont contenu s'affiche
func notif_pressed(id : int) -> void:
	var message = get_node("Text") as Label
	message.visible = true
	message.text = "%s" % [Notification.get_message(id)]


# Si le joueur clique dans le vide le panel se ferme
func _on_close_pressed() -> void:
	queue_free()
