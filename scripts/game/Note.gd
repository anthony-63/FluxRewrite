extends Node

var spawn_time: float = 0.0
var ms: int = 0
var index: int = 0
var hittable: bool = false
var unhittable: bool = false
var mod_color: Color = Color(1.0, 1.0, 1.0)
var mouse_over = false
var cursor: Sprite3D

func _ready():
	self.scale = Vector3.ONE*0.865
	cursor = $"../../Cursor"

func check_hit():
	var curs: Vector3 = Flux.cursor_pos
	var note: Vector3 = self.transform.origin
	var curshb: float = Flux.get_setting("game", "cursor_hitbox")
	var notehb: float = Flux.get_setting("game", "hitbox")
	var sc: Vector3 = self.global_transform.basis.get_scale()
	return abs(note.x - curs.x) <= (sc.x + curshb) * 0.5 and abs(note.y - curs.y) <= (sc.y + curshb) * 0.5

func update(currtime: float):
	var current_note: Dictionary = Flux.current_map.diffs["default"][index]
	var time: float = (float(current_note.ms) - currtime) / (float(current_note.ms) - spawn_time)
	self.transform.origin = Vector3(-current_note.x + 1.0, -current_note.y + 1.0, time * Flux.get_setting("note", "sd"))
	
	if Flux.get_setting("note", "fade"):
		mod_color.a = 1.0 - time
	else:
		mod_color = Color(1.0, 1.0, 1.0)
	self.modulate = mod_color
	
	if self.transform.origin.z < -2.0:
		self.visible = false
	
	if self.transform.origin.z < -15.0:
		queue_free()
	
	if currtime >= ms and not unhittable: 
		if Flux.mods.visual_map:
			self.queue_free()
		else: hittable = true
	
	if currtime >= ms + Flux.get_setting("game", "hitwindow") and hittable:
		hittable = false
		unhittable = true
		
		cursor.texture = cursor.cursorset[cursor.cursor_index % len(cursor.cursorset)]
		cursor.alpha_cut = SpriteBase3D.ALPHA_CUT_DISABLED
		cursor.cursor_index += 1
		
		Flux.game_stats.hp = clamp(Flux.game_stats.hp - Flux.game_stats.hp_per_miss, 0.0, Flux.game_stats.max_hp)
		Flux.game_stats.combo = 0
		Flux.game_stats.misses += 1
		self.queue_free()

	if check_hit() and hittable:
		hittable = false
		unhittable = true
		self.visible = false
		
		cursor.texture = cursor.cursorset[cursor.cursor_index % len(cursor.cursorset)]
		cursor.alpha_cut = SpriteBase3D.ALPHA_CUT_DISABLED
		cursor.cursor_index += 1
		
		Flux.game_stats.hp = clamp(Flux.game_stats.hp + Flux.game_stats.hp_per_hit, 0.0, Flux.game_stats.max_hp)
		Flux.game_stats.combo += 1
		
		if Flux.game_stats.combo > Flux.game_stats.max_combo:
			Flux.game_stats.max_combo = Flux.game_stats.combo
		
		Flux.game_stats.hits += 1

func _process(delta):
	pass
