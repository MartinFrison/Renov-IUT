extends Node


static func call_event(id : int):
	var choice = Event.event_choice(id)
	var name = Event.event_name(id)
	var desc = Event.event_description(id)
	 
	#for row in choice:
		#row["id_choice"]
		#row["description"]
	
