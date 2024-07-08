extends "res://Collectable.gd"

@onready var animations = $AnimationPlayer

func collect(inventory: Inventory):
	animations.play("collected")
	await animations.animation_finished
	super(inventory)
