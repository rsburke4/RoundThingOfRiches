extends Sprite2D

@export var scaleX:float
@export var scaleY:float
@export var scaleX_speed:float
@export var scaleY_speed:float
@export var scaleX_amp:float
@export var scaleY_amp:float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	scale.x = 1.3 + abs(sin(Time.get_ticks_msec() * scaleX_speed)) * scaleX_amp
	scale.y = 1.3 + abs(sin(Time.get_ticks_msec() * scaleY_speed)) * scaleY_amp
