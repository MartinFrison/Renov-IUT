class_name Event
extends Node

var _question : bool
var _name : String
var _description : String
var _question_script : String
var _question_answer : Array[String] = []


static func create_event(id : int) -> Event:
	match id:
		0:
			return EventPiratage.new()
		1:
			return EventLegislatif.new()
	return null


func _init() -> void:
	pass
	
func start_event() -> void:
	if _question:
		var f ="react_to_answer"
		await BulleGestion.ask_question(_description + "\n\n" + _question_script, _question_answer,f, self)
	else:
		await BulleGestion.send_message(_description)
		react_to_answer("default")


func react_to_answer(answer : String) -> void:
	pass

# Retourne la valeur de _question
func get_question() -> bool:
	return _question

# Retourne la valeur de _name
func get_name_() -> String:
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
