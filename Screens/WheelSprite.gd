extends Sprite2D

@export var rotation_speed:float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rotation = Time.get_ticks_msec() * rotation_speed
