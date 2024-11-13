class_name ObserverPopulation
extends Node

static var Observer = []

static func addObserver(O) -> void:
	Observer.append(O)

static func notifyLevelChanged() -> void:
	for o in Observer:
		if o.has_method("notifyLevelChanged"):
			var c : Callable = Callable(o, "notifyLevelChanged")
			c.call()


static func notifySatisfactionChanged() -> void:
	for o in Observer:
		if o.has_method("notifySatisfactionChanged"):
			var c : Callable = Callable(o, "notifySatisfactionChanged")
			c.call()
