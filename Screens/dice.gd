extends Node2D

var dice_number = 0
var can_roll = true

var initial_timer_delay = 0.05
var current_timer_delay = initial_timer_delay
var timer = create_timer(current_timer_delay)

var initial_pitch_scale = 1.25
var current_pitch_scale = initial_pitch_scale

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("dice_roll") and can_roll:
			can_roll = false
			roll_dice()

func roll_dice():
	var total_rolls = get_random_number(8, 16)
	var rolls_when_slowing_down = get_random_number(4, 6)
	
	for roll in range(total_rolls, -1, -1):
		dice_number = get_random_number(0, 5)
		$Ding.play(0.25)
		$AnimatedSprite2D.set_frame(dice_number)
		
		if roll <= rolls_when_slowing_down:
			slower_roll()
		
		# Add delay till the next loop so it looks like the dice is "thrown".
		# The delay increases depending on the if statement above.
		timer.start()
		await timer.timeout
	
	finish_roll()
	print("finished roll")
	
	if dice_number > 0:
		positive_roll_outcome()
	else:
		negative_roll_outcome()
	
	can_roll = true

func positive_roll_outcome():
	$Earn.play()
	pass

func negative_roll_outcome():
	$Loss.play()
	pass

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
	var timer = Timer.new()
	self.add_child(timer)
	
	timer.wait_time = seconds
	timer.one_shot = true
	
	return timer

func update_timer_delay(updated_timer, updated_seconds):
	updated_timer.wait_time = updated_seconds

func update_pitch_scale(audio_node, new_scale):
	audio_node.set_pitch_scale(new_scale)
