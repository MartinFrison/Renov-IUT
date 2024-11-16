extends Node2D

var notif : Array
var page : int
var page_size : int = 8
var buttons : Array[Button]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 2
	TimeManagement.pause(true)
	notif = Notification.get_all_ids()
	page = 0	
	open_page()


func open_page() -> void:
	for i in buttons:
		i.queue_free()
	buttons.clear()
	for p in page_size:
		var i = notif.size() - 1 - ((page * page_size) + p)
		if notif.size() > i and i >= 0:
			var id = notif[i]
			create_question_button(Notification.get_object(id), id, p)


func create_question_button(text : String, id : int, n) -> void:
	# Créer un bouton
	var button = Button.new()
	buttons.append(button)
	button.text = text
	button.size = Vector2(300, 50)
	button.position = Vector2(20, n * 60 + 10)

	var panel = get_node("PanelNotif")
	panel.add_child(button)
	button.pressed.connect(Callable(notif_pressed).bind(id))



func _on_next_pressed() -> void:
	if notif.size() > (page+1)* page_size:
		page += 1
		open_page()


func _on_last_pressed() -> void:
	if page > 0:
		page -= 1
		open_page()

func notif_pressed(id : int) -> void:
	var message = get_node("Text")
	message.text = "%s: \n\n%s" % [Notification.get_object(id), Notification.get_message(id)]


func _on_close_pressed() -> void:
	TimeManagement.pause(false)
	queue_free()
