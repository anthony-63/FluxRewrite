extends Sprite3D

@export var target_width: float
@export var target_height: float

var lerp_factor = 10

func _ready():
	target_width = self.scale.x
	target_height = self.scale.y

func _process(_delta):
	self.scale.x += (target_width - self.scale.x) / lerp_factor
	self.scale.y += (target_height - self.scale.y) / lerp_factor
