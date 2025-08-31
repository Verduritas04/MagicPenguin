extends Control


var waveId : int = 1
var score  : int = 0

@onready var ammoEmpty   := $AmmoEmpty
@onready var ammoFull    := $Ammo
@onready var scoreLabel  := $Score
@onready var waveLabel   := $Wave
@onready var animScore   := $Score/AnimationPlayer
@onready var hboxRestart := $HBoxContainer
@onready var shop        := $Shop

signal wave()


func update_score(add : int) -> void:
	score += add
	scoreLabel.text = "Score : " + str(score)
	animScore.play("Bouce")

func update_ammo(ammo : int, maxAmmo : int) -> void:
	ammoEmpty.size.x = maxAmmo * 16
	ammoEmpty.position.x = 240 - ammoEmpty.size.x
	
	if ammo * 16 < ammoFull.size.x:
		create_burst_stars(Vector2(248 - ammoFull.size.x, 224))
	
	ammoFull.size.x = ammo * 16
	ammoFull.position.x = 240 - ammoFull.size.x

func create_burst_stars(pos : Vector2) -> void:
	var burstStars = Globals.BurstStars.instantiate()
	burstStars.position = pos
	add_child(burstStars)
	burstStars.emitting = true

func create_shop() -> void:
	if !hboxRestart.visible:
		await get_tree().create_timer(3.8).timeout
		if waveId < 5:
			waveId += 1
			waveLabel.text = "Wave " + str(waveId) + "/5"
			shop.visible = true
		else:
			get_tree().change_scene_to_file("res://menu/menu.tscn")

func _on_button_pressed() -> void:
	SoundManager.create_sound("Hit", true)
	get_tree().reload_current_scene()

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/menu.tscn")

#--------------------------------------------------------------------

func _on_ammo_pressed() -> void:
	var player = get_tree().current_scene.get_node("Player")
	if score >= 500 and player.maxAmmo < 5:
		update_score(-500)
		player.maxAmmo += 1
		SoundManager.create_sound("Powerup")
		update_ammo(player.ammo, player.maxAmmo)
		if player.maxAmmo >= 5:
			$Shop/HBoxContainer2/Ammo.text = "Empty"

func _on_load_pressed() -> void:
	var player = get_tree().current_scene.get_node("Player")
	if score >= 100 and player.reloadSpd < 240:
		update_score(-100)
		player.reloadSpd += 20
		SoundManager.create_sound("Powerup")
		if player.reloadSpd >= 240:
			$Shop/HBoxContainer2/Load.text = "Empty"

func _on_spread_pressed() -> void:
	var player = get_tree().current_scene.get_node("Player")
	if score >= 200 and player.spread < 3:
		player.spread += 1
		update_score(-200)
		SoundManager.create_sound("Powerup")
		if player.spread >= 3:
			$Shop/HBoxContainer2/Spread.text = "Empty"

func _on_one_more_pressed() -> void:
	var player = get_tree().current_scene.get_node("Player")
	if score >= 100 and player.number < 5:
		player.number += 1
		update_score(-100)
		SoundManager.create_sound("Powerup")
		if player.number >= 5:
			$Shop/HBoxContainer2/OneMore.text = "Empty"

func _on_done_pressed() -> void:
	shop.visible = false
	var player = get_tree().current_scene.get_node("Player")
	SoundManager.create_sound("Hit")
	player.alive = true
	emit_signal("wave")
