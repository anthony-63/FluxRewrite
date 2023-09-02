extends Sprite3D

var target_width: float
var target_height: float
var single_square_size: float
var lerp_factor = 10

func _ready():
	target_width = self.scale.x
	target_height = self.scale.y
	single_square_size = self.scale.x / 3.0

func _process(_delta):
	self.scale.x += (target_width - self.scale.x) / lerp_factor
	self.scale.y += (target_height - self.scale.y) / lerp_factor
