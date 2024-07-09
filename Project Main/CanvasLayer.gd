extends CanvasLayer


@onready var inventory = $InventoryGui
@onready var gameOver = $"Game Over"
@onready var player = $"../TileMap/Player"
@onready var quit = $Quit
@onready var yousuck = $"Quit/you suck"

func _ready():
	inventory.close()
	gameOver.text = ""
	gameOver.position = Vector2(-10000,-10000)
	player.connect("dead", playerDeath)
	$RestartButton.visible = false
	quit.visible = false
	yousuck.visible = false

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		if inventory.isOpen:
			inventory.close()
		else:
			inventory.open()

func playerDeath():
	gameOver.text = "GAME OVER!"
	gameOver.position = Vector2(32,86)
	$RestartButton.visible = true
	quit.visible = true
	get_tree().paused = true

func _on_restart_button_button_up():
	get_tree().reload_current_scene()

func _on_quit_button_up():
	yousuck.visible = true
