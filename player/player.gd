extends CharacterBody2D


#const KNOCKBACK       : int = 110
const SHOOT_KNOCKBACK : int = 180
const MIN_SPAWN_DIS   : int = 24
const SPREAD_ANGLE : float = 0.3
const RELOAD_START : float = 100.0

var moveDirection = Vector2.ZERO

var maxAmmo   : int = 3
var ammo      : int = maxAmmo

var reloadSpd : int = 180
var reloadTime : float = RELOAD_START

var number : int = 3
var spread : int = 1

var alive : bool = true

@onready var snowParticles := $SnowParticles
@onready var animPlayVFX   := $AnimationPlayerVFX
@onready var animTree      := $AnimationTree

signal update_ammo(ammo : int, maxAmmo : int)


func _input(event: InputEvent) -> void:
	if alive:
#		if event.is_action_pressed("ui_left_click"):
#			moveDirection = get_global_mouse_position().direction_to(position)
#			velocity = moveDirection * KNOCKBACK
#			create_burst_snow()
		if event.is_action_pressed("ui_left_click") and ammo > 0:
			snowParticles.emitting = true
			ammo -= 1
			SoundManager.create_sound("Spike")
			reloadTime = RELOAD_START
			emit_signal("update_ammo", ammo, maxAmmo)
			moveDirection = get_global_mouse_position().direction_to(position)
			velocity = moveDirection * SHOOT_KNOCKBACK
			animPlayVFX.stop()
			animPlayVFX.play("Bounce")
			create_burst_snow()
			create_spikes()
			animTree.active = true
			animTree.set("parameters/blend_position", moveDirection)

func _ready() -> void:
	var hud = get_tree().current_scene.get_node("Hud")
	update_ammo.connect(hud.update_ammo)
	call_deferred("emit_signal", "update_ammo", ammo, maxAmmo)

func _physics_process(delta: float) -> void:
	if alive:
		move()
		reload(delta)

func move() -> void:
		var oldSpd = velocity
		move_and_slide()
		if is_on_floor() or is_on_ceiling():
			velocity.y = -oldSpd.y
			animPlayVFX.stop()
			animPlayVFX.play("Bounce")
		if is_on_wall():
			velocity.x = -oldSpd.x
			animPlayVFX.stop()
			animPlayVFX.play("Bounce")

func reload(delta : float) -> void:
	if ammo < maxAmmo:
		reloadTime -= reloadSpd * delta
		if reloadTime <= 0:
			ammo += 1
			reloadTime = RELOAD_START
			emit_signal("update_ammo", ammo, maxAmmo)

func get_hurt() -> void:
	if alive:
		alive = false
		snowParticles.emitting = false
		SoundManager.play_music("")
		SoundManager.create_sound("GameOver")
		var floorX = get_tree().current_scene.get_node("Floor")
		floorX.texture = Globals.FloorDead
		var hud = get_tree().current_scene.get_node("Hud")
		hud.hboxRestart.visible = true
		var wave = get_tree().current_scene.get_node("Wave")
		for enemy in wave.get_children():
			enemy.canShoot = false
		create_burst_stars()
		wave.set_physics_process(false)

func create_spikes() -> void:
	var direction = get_global_mouse_position().direction_to(position)
	var spikeSpawn = get_parent().get_node("Spikes")
	for i in spread:
		for j in number:
			var spikeSnow = Globals.SpikeSnow.instantiate()
			spikeSnow.position = position - direction.rotated((i - (spread * 0.5 - 0.5)) * SPREAD_ANGLE) \
			* (MIN_SPAWN_DIS + 16 * j)
			spikeSnow.position += Vector2(randi_range(-2, 2), randi_range(-2, 2))
			spikeSpawn.add_child(spikeSnow)

func create_burst_snow() -> void:
	var burstSnow = Globals.BurstSnow.instantiate()
	burstSnow.position = position
	get_parent().add_child(burstSnow)
	burstSnow.start(velocity.normalized())

func create_burst_stars() -> void:
	var burstStars = Globals.BurstStars.instantiate()
	burstStars.position = position
	get_parent().add_child(burstStars)
	burstStars.emitting = true
