extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ObserverGlobalData.addObserver(self)
	ObserverPopulation.addObserver(self)
	notifyBudgetChanged()
	notifyLevelChanged()
	notifySatisfactionChanged()
	updateDate()

func _process(delta: float) -> void:
	updateDate()


func notifyBudgetChanged() -> void:
	var label = get_node("budget")
	label.text = str(GlobalData.getTotalBudget()) + "$"

func notifyLevelChanged() -> void: 
	var label = get_node("level")
	label.text = str(Student.avg_level()*100) + "%"


func notifySatisfactionChanged() -> void:
	var label = get_node("mood_stud")
	label.text = str(Student.avg_mood()*100) + "%"
	label = get_node("mood_teach")
	label.text = str(Teacher.avg_mood()*100) + "%"


func updateDate() -> void: 
	var label = get_node("date")
	label.text = GlobalData.get_date()
