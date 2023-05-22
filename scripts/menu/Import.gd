extends Node


func _on_import_from_txt_data_pressed():
	get_tree().change_scene_to_file("res://scenes/TxtDataImporter.tscn")
