extends Node2D

var _message : String
var tick = 0

func _ready() -> void:
	self.position = Vector2(450, 0)

func _process(delta: float) -> void:
	var y_vector = -(abs(tick-50)) * (tick-50)/550
	self.position += Vector2(0, y_vector)
	tick += 1


func init(message : String) -> void:
	_message = message
	var msg = get_node("Message")
	msg.text = _message

	# Créer un Timer
	var timer = Timer.new()
	timer.wait_time = 4.0  # Définit le temps d'attente à 2 secondes
	timer.one_shot = true  # Rend le timer à usage unique
	add_child(timer)  # Ajoute le timer en tant qu'enfant de ce node
	timer.start()
	await timer.timeout
	queue_free()
