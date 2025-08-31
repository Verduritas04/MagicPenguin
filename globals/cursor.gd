extends Sprite2D


@onready var animPlay := $AnimationPlayer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left_click"):
		animPlay.play("Click")

func _process(_delta: float) -> void:
	var mousePos : Vector2 = get_global_mouse_position()
	position = Vector2(int(mousePos.x), int(mousePos.y))
