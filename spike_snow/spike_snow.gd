extends StaticBody2D


func _on_timer_timeout() -> void:
	$Sprite2D.frame = 1
	$HitArea/CollisionShape2D.disabled = false
	$CollisionShape2D.disabled = false

func kill() -> void:
	create_burst_stars()
	queue_free()

func create_burst_stars() -> void:
	var burstStars = Globals.BurstStars.instantiate()
	burstStars.position = position
	get_parent().get_parent().add_child(burstStars)
	burstStars.emitting = true
