class_name Event
extends RefCounted

var _question : bool
var _name : String
var _description : String
var _question_script : String
var _question_answer : Array[String] = []


func _init() -> void:
	start_event()
	
func start_event() -> void:
	Question.ask_question_event(self)


func react_to_answer(answer : String) -> void:
	pass

# Retourne la valeur de _question
func get_question() -> bool:
	return _question

# Retourne la valeur de _name
func get_name() -> String:
	return _name

# Retourne la valeur de _description
func get_description() -> String:
	return _description

# Retourne la valeur de _question_script
func get_question_script() -> String:
	return _question_script

# Retourne la valeur de _question_answer
func get_question_answer() -> Array[String]:
	return _question_answer
