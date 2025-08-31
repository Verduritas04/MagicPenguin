extends CharacterBody2D


var playerPos = Vector2.ZERO

@export var score : int = 100
@export var speed : int = 100
@export var canMove  : bool = false
@export var canShoot : bool = true

@onready var sprite     := $Sprite2D
@onready var animPlay   := $AnimationPlayer
@onready var timer      := $Timer
@onready var timerScore := $TimerScore
@onready var animVFX    := $AnimationPlayerVFX

signal send_score(add : int)


func _ready() -> void:
	randomize()
	sprite.flip_h = randi() % 2 == 0
	var hud = get_tree().current_scene.get_node("Hud")
	send_score.connect(hud.update_score)

func move() -> void:
	if canMove:
		velocity = position.direction_to(playerPos).rotated(\
		(timer.time_left * 10 - 1.57) * 0.5) * speed
		move_and_slide()

func shoot() -> void:
	if canShoot:
		animVFX.play("Bounce")
		var bullet = Globals.Bullet.instantiate()
		var bullets = get_tree().current_scene.get_node("Bullets")
		bullet.direction = position.direction_to(playerPos)
		bullet.position = position + bullet.direction * 16
		bullets.add_child(bullet)

func set_can_move(value : bool) -> void:
	canMove = value

func get_hurt() -> void:
	if canShoot:
		canShoot = false
		SoundManager.create_sound("Hit")
		create_burst_stars()
		create_pop_up()
		emit_signal("send_score", score)
		queue_free()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Appear":
		animPlay.play("Move")

func _on_timer_score_timeout() -> void:
	if score > 10:
		score -= 10
		timerScore.start(1)

func create_burst_stars() -> void:
	var burstStars = Globals.BurstStars.instantiate()
	burstStars.position = position
	get_parent().get_parent().add_child(burstStars)
	burstStars.emitting = true

func create_pop_up() -> void:
	var popUp = Globals.PopUp.instantiate()
	popUp.position = position - Vector2(20, 16)
	get_parent().get_parent().add_child(popUp)
	popUp.text = str(score)
