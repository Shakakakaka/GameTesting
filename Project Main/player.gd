extends CharacterBody2D


signal healthChanged
@export var speed: int = 80
@onready var animations = $AnimationPlayer
@onready var collisionShape = $CollisionShape2D 
@onready var effects = $Effects
@onready var hurtbox = $hurtBox/CollisionShape2D
@onready var weapon = $weapon
@onready var Originx = 182
@onready var Originy = 158
@onready var playerDamage = 10

@export var maxHealth = 10
@onready var currentHealth = maxHealth
@export var knockbackPower = 2000
@export var inventory: Inventory
var lastAnimDirection = "down"
var isAttacking = false
signal dead

func _ready():
	effects.play("RESET")
	weapon.process_mode = Node.PROCESS_MODE_DISABLED
	weapon.visible = false


func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed
	
	if Input.is_action_just_pressed("attack"):
			attack() 
	Sprint()
	noClip()
	reloadScene()

func reloadScene():
	if Input.is_physical_key_pressed(KEY_R):
		get_tree().reload_current_scene()

func attack():
	isAttacking = true
	weapon.visible = true
	weapon.process_mode = Node.PROCESS_MODE_INHERIT
	playerDamage = weapon.weaponDamage
	var mouseAngle
	var mouseDirection = "up"
	mouseAngle = rad_to_deg(get_local_mouse_position().angle())
	if mouseAngle >= -135 and mouseAngle <= -45:
		mouseDirection = "up"
	elif mouseAngle <= 135 and mouseAngle >= 45:
		mouseDirection = "down"
	elif mouseAngle >= -45 and mouseAngle <=45:
		mouseDirection = "right"
	else:
		mouseDirection = "left"
	animations.play("attack" + mouseDirection)
	await animations.animation_finished
	animations.play("walk_" + mouseDirection)
	animations.stop()
	weapon.visible = false
	isAttacking = false
	weapon.process_mode = Node.PROCESS_MODE_DISABLED


func updateAnimation():
	if isAttacking: return
	if velocity.is_zero_approx():
		animations.stop()
	else:
		var direction = "down"
		if velocity.x < 0: direction = "left"
		elif velocity.x > 0: direction = "right"
		elif velocity.y <0: direction = "up"
		animations.play("walk_" + direction)
		lastAnimDirection = direction

func Sprint():
	if Input.is_physical_key_pressed(KEY_SHIFT):
		speed = 130
		animations.advance(0.01)
	else:
		speed = 80

func noClip():
	if Input.is_physical_key_pressed(KEY_V):
		collisionShape.set_disabled(true)
	else:
		collisionShape.set_disabled(false)

func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()


func _physics_process(delta):
	handleInput()
	move_and_slide()
	handleCollision()
	updateAnimation()


func hurtByEnemy(area):
	if area.name == "hitBox":
		currentHealth -= 1
		if currentHealth == 0:
			emit_signal("dead")
			print(dead)
		healthChanged.emit(currentHealth)
		knockback(area.get_parent().velocity)
		effects.play("hurtBlink")
		hurtbox.set_deferred("disabled", true)
		await get_tree().create_timer(1).timeout
		hurtbox.set_deferred("disabled", false)
		effects.play("RESET")

func _on_hurt_box_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)

func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()

