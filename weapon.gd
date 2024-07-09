extends Node2D

var weaponDamage = 10

func assignDamage():
	for child in get_children():
		if child.name == "sword":
			weaponDamage = 25




func _ready():
	assignDamage()

