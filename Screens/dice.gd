extends Node2D

var dice_number: int = 0
var can_roll = true

var initial_timer_delay = 0.05
var current_timer_delay = initial_timer_delay
var timer = create_timer(current_timer_delay)

var initial_pitch_scale = 1.25
var current_pitch_scale = initial_pitch_scale

@onready var player_one = get_node("../Player")

func _ready():
	pass

#TODO: Move process logic to main scene's script.
func _process(delta):
	if Input.is_action_just_pressed("dice_roll") and can_roll:
		can_roll = false
		player_one.current_name_node.set_text("PLAYER1")
		roll_dice()
	
	if Input.is_action_just_pressed("take_points") and can_roll:
		player_one.take_current_points()

func roll_dice():
	var total_rolls = get_random_number(8, 16)
	var rolls_when_slowing_down = get_random_number(4, 6)
	
	for roll in range(total_rolls, -1, -1):
		dice_number = get_random_number(0, 5)
		$Ding.play(0.25)
		$DiceSprite.set_frame(dice_number)
		
		if roll <= rolls_when_slowing_down:
			slower_roll()
		
		# Add delay till the next loop so it looks like the dice is "thrown".
		# The delay increases depending on the if statement above.
		timer.start()
		await timer.timeout
	
	finish_roll()
	
	if dice_number > 1:
		positive_roll_outcome(dice_number)
	else:
		negative_roll_outcome(dice_number)
	
	can_roll = true

# Dice number is 0-5. + 1 is added for accurate score/roll.
func positive_roll_outcome(dice_number: int):
	$Earn.play()
	player_one.increase_current_points(dice_number + 1)

func negative_roll_outcome(dice_number: int):
	$Loss.play()
	player_one.remove_current_points(dice_number + 1)

func slower_roll():
	current_timer_delay += 0.05
	current_pitch_scale -= 0.045
	
	update_timer_delay(timer, current_timer_delay)
	update_pitch_scale($Ding, current_pitch_scale)

func finish_roll():
	current_timer_delay = initial_timer_delay
	current_pitch_scale = initial_pitch_scale
	
	update_timer_delay(timer, current_timer_delay)
	update_pitch_scale($Ding, current_pitch_scale)

func get_random_number(min_range, max_range):
	return randi_range(min_range, max_range);

func create_timer(seconds):
	var newTimer = Timer.new()
	self.add_child(newTimer)
	
	newTimer.wait_time = seconds
	newTimer.one_shot = true
	
	return newTimer

func update_timer_delay(updated_timer, updated_seconds):
	updated_timer.wait_time = updated_seconds

func update_pitch_scale(audio_node, new_scale):
	audio_node.set_pitch_scale(new_scale)
