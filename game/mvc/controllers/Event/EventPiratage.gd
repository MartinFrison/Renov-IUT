class_name EventPiratage
extends Event


func _init() -> void:
	_question = GlobalData.getBudget()>1
	_name = "Piratage"
	_description = "Un piratage massif des données des étudiants à eu lieu, les étudiants sont mécontents !"
	_question_script = "Voulez vous sécuriser les données ? (cout : X)"
	_question_answer = ["NON", "OUI"]
	start_event()


func react_to_answer(answer : String) -> void:
	if answer == _question_answer[0]:
		GlobalData.addBudget(-1)
	elif answer == _question_answer[1]:
		pass
