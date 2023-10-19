extends AudioStreamPlayer2D

@export var good:AudioStreamWAV
@export var bad:AudioStreamWAV
@export var ping:AudioStreamWAV
@export var very_bad:AudioStreamWAV
@export var win:AudioStreamWAV
@export var congrats:AudioStreamWAV
@export var incorrect:AudioStreamWAV

enum {GOOD, BAD, PING, VERY_BAD, WIN, CONGRATS, INCORRECT}
var sound_clips


# Called when the node enters the scene tree for the first time.
func _ready():
	sound_clips = {
		GOOD : good,
		BAD : bad,
		PING : ping,
		VERY_BAD : very_bad,
		WIN : win,
		CONGRATS : congrats,
		INCORRECT : incorrect
	}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func play_sound(value: int):
	#Volume settings could be applied here
	stream = sound_clips[value]
	play()
