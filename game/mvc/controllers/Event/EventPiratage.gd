class_name EventPiratage
extends Event

var cout = 1

func _init() -> void:
	_name = "Piratage"
	_description = "Un piratage massif des données des étudiants à eu lieu, les étudiants sont mécontents !"
	_question_script = "Voulez vous sécuriser les données ? (cout : " + str(cout) + ")"
	_question_answer = ["NON", "OUI"]
	start_event()


func start_event() -> void:
	_question = GlobalData.getBudget()>= cout
	super.start_event()


func react_to_answer(answer : String) -> void:
	print("reponse au piratage")
	if answer == _question_answer[0]:
		GlobalData.addBudget(-1)
	elif answer == _question_answer[1]:
		pass
