extends Node

var spawn_time
var ms
var index
var hittable: bool
var unhittable: bool
var mod_color: Color
var mouse_over = false

func _ready():
	self.scale = Vector3.ONE*0.865

func check_hit():
	var c = Flux.cursor_pos
	var h = Flux.get_setting("game", "hitbox")
	var ch = Flux.get_setting("game", "cursor_hitbox")
	var t = Vector2(self.transform.origin.x + self.scale.x / 2.0, self.transform.origin.y + self.scale.y / 2.0)
	return c.x < t.x + h and c.x + ch > t.x and c.y < t.y + h and c.y + ch > t.y

func update(currtime: float):
	var current_note = Flux.current_map.diffs["default"][index]
	var time = (float(current_note.ms) - currtime) / (float(current_note.ms) - spawn_time)
	self.transform.origin = Vector3(-current_note.x + 1.0, -current_note.y + 1.0, time * Flux.get_setting("note", "sd"))
	
	if check_hit() and hittable:
		hittable = false
		unhittable = true
		self.visible = false
		Flux.game_stats.hp = clamp(Flux.game_stats.hp + Flux.game_stats.hp_per_hit, 0.0, Flux.game_stats.max_hp)
		Flux.game_stats.combo += 1
		
		if Flux.game_stats.combo > Flux.game_stats.max_combo:
			Flux.game_stats.max_combo = Flux.game_stats.combo
		
		Flux.game_stats.hits += 1
	if currtime >= ms and not unhittable: hittable = true
	if currtime >= ms + Flux.get_setting("game", "hitwindow") and hittable:
		hittable = false
		unhittable = true
		Flux.game_stats.hp = clamp(Flux.game_stats.hp - Flux.game_stats.hp_per_miss, 0.0, Flux.game_stats.max_hp)
		Flux.game_stats.combo = 0
		Flux.game_stats.misses += 1
	
	if Flux.settings.note.fade:
		mod_color = Color(1.0, 1.0, 1.0, 1.0 - time)
	else:
		mod_color = Color(1.0, 1.0, 1.0)
	self.modulate = mod_color
	
	if self.transform.origin.z < -3.0:
		self.visible = false
	
	if self.transform.origin.z < -15.0:
		queue_free()

func _process(delta):
	pass
