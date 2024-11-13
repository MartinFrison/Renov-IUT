extends Node2D

var _question : String
var _fonctionReponse : String
var _reponse : Array[String]

var _node : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func init(question : String, reponse : Array[String] ,fonction : String, node : Node) -> void:
	_fonctionReponse = fonction
	_node = node
	_reponse = reponse
	_question = question
	var ques = get_node("Question")
	ques.text = _question
	
	for i in reponse.size():
		create_question_button(reponse[i], i)


func create_question_button(text : String, id : int) -> void:
	# Créer un bouton
	var button = Button.new()
	button.text = _reponse[id]
	button.size = Vector2(160, 60)
	button.position = Vector2(100, id * 100 + 50)

	var panel = get_node("PanelReponse")
	panel.add_child(button)
	button.pressed.connect(Callable(_on_answer_pressed).bind(id))


func _on_answer_pressed(id : int) -> void:
	var c : Callable = Callable(_node, _fonctionReponse)
	c.call(_reponse[id])
	TimeManagement.pause(false)
	queue_free()
