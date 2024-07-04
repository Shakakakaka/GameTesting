extends "res://Collectable.gd"

@onready var animations = $AnimationPlayer

func collect():
	animations.play("collected")
	await animations.animation_finished
	super()
