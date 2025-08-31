extends GPUParticles2D


func start(direction : Vector2) -> void:
	rotate(Vector2.LEFT.angle_to(direction))
	emitting = true

func _on_timer_timeout() -> void:
	queue_free()
