class_name EventLegislatif
extends Event

static var _effetActif : int = 0

func _init() -> void:
	_name = "Changement législatif"
	_description = "Un changement législatif à eu lieu ! Il a été voté que le budget aloué aux IUT allai baisser."
	_question_script = ""
	_question_answer = []
	_question = false
	start_event()


func start_event() -> void:
	super.start_event()


func react_to_answer(answer : String) -> void:
	print("reponse au changement legislatif")
	_effetActif += 1
