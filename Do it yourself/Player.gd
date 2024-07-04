extends CharacterBody2D

@onready var animations = $AnimationPlayer
var speed = 100
var speedMult = 1.6
var  animMult = (float)(speedMult)
var animationDirection = "down"

func sprint():
	animMult = (float)(speedMult)
	if(Input.get_action_raw_strength("Sprint")):
		animMult = (animMult / (animMult + 100)) 
		velocity =  velocity*speedMult
		animations.advance(animMult)
		print(animMult)

func handleInput():
	var moveDirection = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = moveDirection * speed 
	sprint()

func handleAnimation():
	if velocity.x < 0: animationDirection = "left"
	elif velocity.x > 0: animationDirection = "right"
	elif velocity.y < 0: animationDirection = "up"
	elif velocity.y > 0: animationDirection = "down"
	if velocity.is_zero_approx():
		animations.play("idle_" + animationDirection)
	else:
		animations.play("walk_" + animationDirection)


func _physics_process(delta):
	handleInput()
	move_and_slide()
	handleAnimation()
