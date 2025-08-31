extends Area2D


var Enemy


func _ready() -> void:
	randomize()
	for i in 3:
		position = Vector2(randf_range(16, 240), randf_range(16, 192))
		if get_overlapping_bodies() == []:
			break
	if get_overlapping_bodies() != []:
		for body in get_overlapping_bodies():
			body.kill()
	
	await get_tree().create_timer(0.7).timeout
	
	var enemy = Enemy.instantiate()
	enemy.position = position
	var wave = get_tree().current_scene.get_node("Wave")
	wave.add_child(enemy)
	queue_free()
