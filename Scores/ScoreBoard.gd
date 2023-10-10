extends Node2D

var total_players

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func setup_scores(num_players):
	var array = get_node("ScoreArray")
	var score=preload("res://Scores/score.tscn")
	
	total_players = num_players
	
	for i in range(num_players):
		print("adding for player" + str(i))
		var s = score.instantiate()
		
		s.name = "Player" + str(i+1)
		s.change_colors(Colors["COLOR_SCORE_BKGD_ACTIVE_PLAYER" + str(i+1)], \
			Colors["COLOR_SCORE_TEXT_PLAYER" + str(i+1)])
		s.reset_score()
		
		array.add_child(s)
		
	print(array.get_children())
	
func update_score(player, score):
	var cur_score = get_node("ScoreArray/Player" + str(player))
	cur_score.update_score(score)
	
func next_player(player):
	for p in range(total_players):
		var cur_score = get_node("ScoreArray/Player" + str(p+1))
		
		if p == (player-1):
			cur_score.change_colors(Colors["COLOR_SCORE_BKGD_ACTIVE_PLAYER" + str(player)], \
				Colors["COLOR_SCORE_TEXT_PLAYER" + str(player)])
		else:
			cur_score.change_colors(Colors["COLOR_SCORE_BKGD_INACTIVE_PLAYER" + str(p+1)], \
				Colors["COLOR_SCORE_TEXT_PLAYER" + str(p+1)])
