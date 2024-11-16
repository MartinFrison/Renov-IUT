class_name EventPiratage
extends Event

var cout = 800
static var secure : bool = false

func _init() -> void:
	_name = "Piratage"
	_description = "Un piratage massif des données des étudiants a eu lieu, les étudiants sont mecontents !"
	_question_script = "Voulez vous sécuriser les données ? (cout : " + str(cout) + ")"
	_question_answer = ["NON", "OUI"]
	start_event()


func event_precondition() -> bool:
	return !secure


func start_event() -> void:
	super.start_event()


func react_to_answer(answer : String) -> void:
	print("reponse au piratage")
	if answer == _question_answer[0]:
		if await Expense.try_expense_global(cout):
				secure = true
				await BulleGestion.send_message("Les données ont été sécurisé", true)
		else:
			react_to_answer(_question_answer[1])
	elif answer == _question_answer[1]:
		pass
