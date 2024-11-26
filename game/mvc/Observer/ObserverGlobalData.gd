class_name ObserverGlobalData
extends Node

static var Observer = []

static func addObserver(O) -> void:
	Observer.append(O)

static func notifyBudgetChanged() -> void:
	for o in Observer:
		if o.has_method("notifyBudgetChanged"):
			var c : Callable = Callable(o, "notifyBudgetChanged")
			c.call()

static func notifyDateChanged() -> void:
	for o in Observer:
		if o.has_method("notifyDateChanged"):
			var c : Callable = Callable(o, "notifyDateChanged")
			c.call()
