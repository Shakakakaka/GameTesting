extends CharacterBody2D

var speed= 70
var player_chase = false
var player = null
@onready var animations = $AnimationPlayer
var player_angle = 0
var direction = "down"
var isDead = false
var knockbackPower = 1000
var health = 100.0
var maxHealth = health
var stunned = false
@onready var healthBar = $healthBar

func set_health_bar():
	healthBar.value = health
	if health == maxHealth:
		healthBar.visible = false
	else: 
		healthBar.visible = true

func updateAnimation():
	if velocity.is_zero_approx():
		animations.play("idle_"+direction)
	else:
		player_angle = rad_to_deg(get_angle_to(player.global_position))
		if player_angle >= -135 and player_angle <= -45:
			direction = "up"
		elif player_angle <= 135 and player_angle >= 45:
			direction = "down"
		elif player_angle >= -45 and player_angle <=45:
			direction = "right"
		else:
			direction = "left"
		animations.play("walk_"+direction)





func _on_detection_area_body_entered(body):
	player = body
	if body.name == "Player":
		player_chase = true



func _on_detection_area_body_exited(body):
		player = null
		player_chase = false

func knockback(enemyVelocity: Vector2):
	velocity = (player.velocity - velocity).normalized() * knockbackPower
	move_and_slide()
	stunned = true
	await get_tree().create_timer(0.5).timeout
	stunned = false

func _physics_process(delta):
	if isDead: return
	if player_chase:
		velocity = (player.position - position).normalized() * speed
		if !stunned:
			move_and_slide()
	else:
		velocity = Vector2(0,0)
	updateAnimation()


func _ready():
	set_health_bar()

func _on_hurt_box_area_entered(area):

	if area == $hitBox: return
	health = (health - area.get_parent().get_parent().weapon.weaponDamage)
	set_health_bar()
	print(healthBar.value)
	knockback(velocity)
	if health <= 0:  
		$hitBox.process_mode = Node.PROCESS_MODE_DISABLED
		isDead = true
		healthBar.visible = false
		animations.play("death")
		await animations.animation_finished
		queue_free()
