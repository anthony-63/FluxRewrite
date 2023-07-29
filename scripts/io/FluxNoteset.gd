extends Node

func load_noteset(dir: String):
	var d: DirAccess = DirAccess.open("user://notesets/%s" % dir)
	print("Loading noteset: %s" % dir)
	Flux.notesets[dir] = []
	var files: PackedStringArray = d.get_files()
	print("Noteset Files: ", files)
	for file in files:
		print("File loading from noteset %s: " % dir, file)
		var i: Image = Image.new()
		var err = i.load("user://notesets/%s/%s" % [dir, file])
		if err != 0:
			print("Error loading noteset image: %s" % file)
			continue
			
		var itex: ImageTexture = ImageTexture.create_from_image(i)
		
		Flux.notesets[dir].append(itex)

func load_default_noteset():
	var files: Array = []
	
	files.append("res://prefabs/user/default_noteset/1.png")
	files.append("res://prefabs/user/default_noteset/2.png")
	
	Flux.notesets["default"] = []
	
	for file in files:
		var res = load(file)
		var itex: ImageTexture = ImageTexture.new()
		itex.set_image(res)
		Flux.notesets["default"].append(itex)
