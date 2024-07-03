extends CharacterBody2D

@onready var animations = $AnimationPlayer
var speed = 100


func handleInput():
	var moveDirection = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = moveDirection * speed 

func handleAnimation():
	var direction = "down"
	if velocity.is_zero_approx():
		animations.stop
	else:
		var animationDirection
		if velocity.x < 0: animationDirection = "left"
		elif velocity.x > 0: animationDirection = "right"
		elif velocity.y < 0: animationDirection = "up"
		animations.play("walk_" + animationDirection)
		print(animationDirection)



func _physics_process(delta):
	handleInput()
	move_and_slide()
	handleAnimation()
	print(velocity)
