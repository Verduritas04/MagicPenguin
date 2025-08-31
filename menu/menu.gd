extends Control


func _ready() -> void:
	SoundManager.create_sound("Intro")
	await get_tree().create_timer(2).timeout
	SoundManager.play_music("Menu")

func _on_button_pressed() -> void:
	SoundManager.create_sound("Powerup", true)
	SoundManager.play_music("")
	$AnimationPlayer.play_backwards("Appear")
	$HBoxContainer.queue_free()
	$Sprite2D.texture = Globals.FloorDead
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://level/level.tscn")
