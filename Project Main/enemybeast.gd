extends CharacterBody2D

var speed= 70
var player_chase = false
var player = null
@onready var animations = $AnimatedSprite2D
var player_angle = 0
var direction = "down"

func updateAnimation():
	if velocity.is_zero_approx():
		animations.stop()
	else:
		player_angle = rad_to_deg(get_angle_to(player.global_position))
		if player_angle >= -150 and player_angle <= -30:
			direction = "up"
		elif player_angle <= 150 and player_angle >= 30:
			direction = "down"
		elif player_angle >= 150 and player_angle <=210:
			direction = "left"
		elif player_angle >= -30 and player_angle <= 30:
			direction = "right"
		animations.play("walk_"+direction)




func _on_detection_area_body_entered(body):
	player = body
	if body.name == "Player":
		player_chase = true



func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func _physics_process(delta):
	if player_chase:
		velocity = (player.position - position).normalized() * speed
		move_and_slide()
	else:
		velocity = Vector2(0,0)
	updateAnimation()




