extends Node

var spawn_time
var ms
var index
var hittable: bool
var unhittable: bool

func _ready():
	self.scale = Vector3.ONE*0.865

func check_hit():
	var r1 = {
		"x": self.transform.origin.x + (self.scale.x / 2.0), 
		"y": self.transform.origin.y + (self.scale.y / 2.0),
		"w": Flux.settings.game.hitbox,
		"h": Flux.settings.game.hitbox,
	}
	var r2 = Flux.cursor_info
	# troller
	return (r1.x < r2.x + r2.w and r1.x + r1.w > r2.x and r1.y < r2.y + r2.h and r1.h + r1.y > r2.y)

func update(currtime: float):
	var current_note = Flux.current_map.diffs["default"][index]
	var time = (float(current_note.ms) - currtime) / (float(current_note.ms) - spawn_time)
	self.transform.origin = Vector3(-current_note.x + 1.0, -current_note.y + 1.0, time * Flux.settings["note"]["sd"])
	
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
	if currtime >= ms + (Flux.settings.game.hitwindow) and hittable: 
		hittable = false
		unhittable = true
		Flux.game_stats.hp = clamp(Flux.game_stats.hp - Flux.game_stats.hp_per_miss, 0.0, Flux.game_stats.max_hp)
		Flux.game_stats.combo = 0
		Flux.game_stats.misses += 1
	
	if self.transform.origin.z < -1.5:
		self.visible = false

	if self.transform.origin.z < -15.0:
		queue_free()
