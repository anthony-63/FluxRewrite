extends Node

@onready var notif_scene = preload("res://scenes/Notification.tscn")

func show_notification(parent, type, title: String, body: String, ok_yes_connection = func(): pass, no_connection = func(): pass):
	var notif: Control = notif_scene.instantiate()
	
	print(notif.get_children())
	
	var notif_call = func(f):
		f.call()
		notif.get_node("NotifPanel/Slide").play("slide", -1, -1.5, true)
		await notif.get_node("NotifPanel/Slide").animation_finished
		
		notif.queue_free()
	
	if type == NotificationType.Ok:
		notif.get_node("NotifPanel/Buttons/Ok").visible = true
		notif.get_node("NotifPanel/Buttons/Ok").pressed.connect(notif_call.bind(ok_yes_connection))
		
	if type == NotificationType.YesNo:
		notif.get_node("NotifPanel/Buttons/Yes").visible = true
		notif.get_node("NotifPanel/Buttons/Yes").pressed.connect(notif_call.bind(ok_yes_connection))
		
		notif.get_node("NotifPanel/Buttons/No").visible = true
		notif.get_node("NotifPanel/Buttons/No").pressed.connect(notif_call.bind(no_connection))
		
	notif.get_node("NotifPanel/Body").text = body
	notif.get_node("NotifPanel/TitlePanel/Title").text = title
	
	parent.add_child(notif)
	
	notif.get_node("NotifPanel/Slide").play("slide")
	await notif.get_node("NotifPanel/Slide").animation_finished
