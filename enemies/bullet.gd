extends Node2D


var direction : Vector2 = Vector2.RIGHT

@onready var sprite := $AnimatedSprite2D


func _process(delta: float) -> void:
	position += direction * 120 * delta

func when_hit() -> void:
	kill()

func kill() -> void:
	if sprite.visible:
		sprite.visible = false
		$HitArea.queue_free()
		$FireParticles.emitting = false
		await get_tree().create_timer(0.5).timeout
		queue_free()
