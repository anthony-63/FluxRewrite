extends Node
var cursor_size = 1024

func load_cursorset(dir: String):
	var d: DirAccess = DirAccess.open("user://cursorsets/%s" % dir)
	print("Loading cursorset: %s" % dir)
	Flux.cursorsets[dir] = []
	var files: PackedStringArray = d.get_files()
	print("Cursorset Files: ", files)
	for file in files:
		print("File loading from noteset %s: " % dir, file)
		var i: Image = Image.new()
		var err = i.load("user://cursorsets/%s/%s" % [dir, file])
		if err != 0:
			print("Error loading cursorset image: %s" % file)
			continue
			
		i.resize(cursor_size, cursor_size)
			
		var itex: ImageTexture = ImageTexture.create_from_image(i)
		
		Flux.cursorsets[dir].append(itex)

func load_default_cursorset():
	var files: Array = []
	
	files.append("res://prefabs/user/cursor.png")
	
	Flux.cursorsets["default"] = []
	
	for file in files:
		var res: Image = Image.load_from_file(file)
		res.resize(cursor_size, cursor_size)
		var itex: ImageTexture = ImageTexture.new()
		itex.set_image(res)
		Flux.cursorsets["default"].append(itex)
