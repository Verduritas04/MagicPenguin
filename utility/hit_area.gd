extends Area2D


func _on_area_entered(area: Area2D) -> void:
	var parent = get_parent()
	area.get_hit()
	if parent.has_method("when_hit"):
		parent.when_hit()

func _on_body_entered(_body: Node2D) -> void:
	var parent = get_parent()
	parent.kill()
