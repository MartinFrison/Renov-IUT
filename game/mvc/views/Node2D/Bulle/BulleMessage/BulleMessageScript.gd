extends Node2D

var _message : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func init(message : String) -> void:
	TimeManagement.pause(true)
	_message = message
	var ques = get_node("Message")
	ques.text = _message

func _input(event):
	if event is InputEventKey:
		if event.pressed and (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER):
			print("La touche Entrée a été pressée")
			enter()


func enter() -> void:
	TimeManagement.pause(false)
	queue_free()
