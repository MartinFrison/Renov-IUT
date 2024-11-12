extends Node2D

var _question : String
var _fonctionReponse : Callable
var _reponse : Array[String]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("bulle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func init(question : String, reponse : Array[String] ,fonction : Callable) -> void:
	_fonctionReponse = fonction
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
	button.pressed.connect(Callable(_on_answer_pressed).bind(1))


func _on_answer_pressed(id : int) -> void:
	_fonctionReponse.call(id)
	TimeManagement.pause(false)
