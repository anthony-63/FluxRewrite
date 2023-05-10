extends Node

func load_noteset(dir: String):
	var d = DirAccess.open("user://notesets/%s" % dir)
	print("Loading noteset: %s" % dir)
	var files = d.get_files()
	print("erm: ", files)
	for file in files:
		print("%s: " % dir, file)
		var tex: Texture = load("user://notesets/%s/%s" % [dir, file])
		Flux.notesets[dir].append(tex)
