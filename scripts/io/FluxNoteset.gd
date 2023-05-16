extends Node

func load_noteset(dir: String):
	var d = DirAccess.open("user://notesets/%s" % dir)
	print("Loading noteset: %s" % dir)
	Flux.notesets[dir] = []
	var files = d.get_files()
	print("erm: ", files)
	for file in files:
		print("%s: " % dir, file)
		var i = Image.new()
		var err = i.load("user://notesets/%s/%s" % [dir, file])
		if err != 0:
			print("Error loading noteset image: %s" % file)
			continue
			
		var itex = ImageTexture.create_from_image(i)
		
		Flux.notesets[dir].append(itex)

func load_default_noteset():
	var files = []
	
	files.append("res://prefabs/user/default_noteset/1.png")
	files.append("res://prefabs/user/default_noteset/2.png")
	
	Flux.notesets["default"] = []
	
	for file in files:
		var res = load(file)
		var itex = ImageTexture.new()
		itex.set_image(res)
		Flux.notesets["default"].append(itex)
