extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ObserverGlobalData.addObserver(self)
	ObserverPopulation.addObserver(self)
	notifyBudgetChanged()
	notifyDateChanged()
	while true:
		notifyLevelChanged()
		notifySatisfactionChanged()
		await get_tree().create_timer(1).timeout

func formatBudget(number: int) -> String:
	var number_str = str(number)
	var formatted_number = ""
	var length = number_str.length()
	for i in range(length):
		formatted_number += number_str[length - 1 - i]
		if (i + 1) % 3 == 0 and i + 1 != length:
			formatted_number += " "
	return formatted_number.reverse()

func notifyBudgetChanged() -> void:
	var label = get_node("budget")
	label.text = formatBudget(GlobalData.getTotalBudget()) + " €"

func notifyLevelChanged() -> void: 
	var label = get_node("level")
	label.text = str(Student.avg_level()*100) + " %"


func notifySatisfactionChanged() -> void:
	var label = get_node("mood_stud")
	label.text = str(Student.avg_mood()*100) + " %"
	label = get_node("mood_teach")
	label.text = str(Teacher.avg_mood()*100) + " %"


func notifyDateChanged() -> void: 
	var label = get_node("date")
	label.text = GlobalData.get_season_text() + " " + GlobalData.get_year_to_str()
