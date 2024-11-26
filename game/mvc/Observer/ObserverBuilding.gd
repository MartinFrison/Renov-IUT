class_name ObserverBuilding
extends Node

static var Observer = []

static func addObserver(O) -> void:
	Observer.append(O)

static func notifyStateChanged() -> void:
	for o in Observer:
		if o.has_method("notifyStateChanged"):
			var c : Callable = Callable(o, "notifyStateChanged")
			c.call()
