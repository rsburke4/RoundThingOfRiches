extends RigidBody2D

var rng = RandomNumberGenerator.new()
var can_spin
var landed_value
var just_stopped
var landed_node
signal landed_on_value(value)

@export var wheel_choices:Array[int]
@export var angular_threshold:float

func spin():
	var random_num = rng.randf_range(10.0, 20.0)
	apply_torque_impulse(random_num * 10.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	can_spin = false
	input_pickable = true
	just_stopped = false
	#Set up colliders for all wheel sections
	for i in wheel_choices.size():
		if i == 0:
			continue
		var section = get_node("WheelSection1").duplicate()
		section.name = "WheelSection" + str(i + 1)
		section.rotation_degrees = i * 360/wheel_choices.size()
		add_child(section)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if angular_velocity < angular_threshold:
		if just_stopped == true:
			landed_value = landed_node.name.get_slice("WheelSection", 1)
			just_stopped = false
			angular_velocity = 0.0
			landed_on_value.emit(wheel_choices[int(landed_value)-1])
	#This is a placeholder. For now, can_spin allows
	#infinite spins, but this should also factor gamestate in
	else:
		can_spin = false
		just_stopped = true
	
func _on_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_released("SpinWheel"):
		if can_spin:
			spin()

#This is my clever workaround to connecting the round over signa
# to the wheel, without knowing the path until the main scene instances it
func connect_puzzle(nodePath):
	var puzzle = get_node(nodePath)
	puzzle.guess_complete.connect(_on_guess_over)

# TODO - not sure if this is the best way to do this, but need to control if wheel can spin or not
func set_spin(b):
	can_spin = b

func set_just_stopped(b):
	just_stopped = b

func _on_decision_area_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	landed_node = area.get_parent()
	
func _on_guess_over(_c, _g):
	can_spin = true
