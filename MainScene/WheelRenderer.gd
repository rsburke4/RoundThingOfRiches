extends Sprite2D

var insideCollider
var wheel
# Called when the node enters the scene tree for the first time.
func _ready():
	insideCollider = false
	wheel = get_node("../SubViewport/WheelRoot/WheelPhysics")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("SpinWheel") and insideCollider:
		wheel.spin()


func _on_area_2d_mouse_shape_entered(shape_idx):
	insideCollider = true


func _on_area_2d_mouse_shape_exited(shape_idx):
	insideCollider = false
