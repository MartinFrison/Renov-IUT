extends Node2D

var _message : String
var _objet : String
var tick = 0

func _ready() -> void:
	self.position = Vector2(350, 100)
	delete()
	while true:
		var y_vector = -(abs(tick-60)) * (tick-60)/800
		self.position += Vector2(0, y_vector)
		tick += 1
		await get_tree().create_timer(0.02).timeout


func delete() -> void:
	await RenovIUTApp.app.get_tree().create_timer(3).timeout
	queue_free()


func init(objet : String, message : String, type : int) -> void:
	_message = message
	var msg = get_node("Message")
	if _message.length() > 200:
		msg.text = _message.substr(0,200) + ".."
	else:
		msg.text = _message
	
	_objet = objet
	var obj = get_node("Objet")
	obj.text = _objet.substr(0,35)
	
	# Créer un Timer
	var timer = Timer.new()
	timer.wait_time = 4.0  # Définit le temps d'attente à 2 secondes
	timer.one_shot = true  # Rend le timer à usage unique
	add_child(timer)  # Ajoute le timer en tant qu'enfant de ce node
	timer.start()
	await timer.timeout
	queue_free()
