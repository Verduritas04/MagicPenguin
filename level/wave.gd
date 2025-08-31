extends Node2D


const ENEMIES : Array = [
	{"name" : "fish", "level" : 0, "price" : 1, "inst" : preload("res://enemies/fish.tscn")},
	{"name" : "slime", "level" : 1, "price" : 1, "inst" : preload("res://enemies/slime.tscn")},
	{"name" : "eye", "level" : 2, "price" : 4, "inst" : preload("res://enemies/eye.tscn")}
]

const  WAVES : Array = [
	[3, 5],
	[3, 5],
	[3, 5],
	[3, 5, 7],
	[3, 7, 6, 6, 7, 10]
#	[1],
#	[1],
#	[1],
#	[1],
#	[1]
]

var player
var telegraph
var points      : int
var waveId      : int = 0

var secId : int = 0

signal shop()


func _ready() -> void:
	var hud = get_tree().current_scene.get_node("Hud")
	shop.connect(hud.create_shop)
	hud.wave.connect(create_wave_music)
	set_process(false)
	player = get_tree().current_scene.get_node("Player")
	telegraph = get_tree().current_scene.get_node("Telegraph")
	await get_tree().create_timer(2).timeout
	create_wave()

func _physics_process(_delta: float) -> void:
	for enemy in get_children():
		enemy.playerPos = player.position
		enemy.move()

func _process(_delta: float) -> void:
	if get_child_count() == 0:
		SoundManager.create_sound("Hit")
		var spikes = get_tree().current_scene.get_node("Spikes")
		for spike in spikes.get_children():
			spike.kill()
		secId += 1
		if secId < WAVES[waveId].size():
			create_wave()
		else:
			player.alive = false
			secId = 0
			waveId += 1
			SoundManager.play_music("" if waveId != 4 else "Mars")
			if waveId != 4:
				SoundManager.create_sound("Win")
			emit_signal("shop")
		set_process(false)

func create_wave_music() -> void:
	if waveId < 4:
		SoundManager.play_music("Map")
	else:
		SoundManager.play_music("Boss")
	create_wave()

func create_wave() -> void:
	points = WAVES[waveId][secId]
	var fill = true
	
	while fill:
		var enemyPool : Array = []
		fill = false
		for enemy in ENEMIES:
			if enemy["price"] <= points and enemy["level"] <= waveId:
				enemyPool.append(enemy)
				fill = true
		if enemyPool != []:
			var enemyToAdd = enemyPool[randi() % enemyPool.size()]
			var spawn = Globals.Spawn.instantiate()
			spawn.Enemy = enemyToAdd["inst"]
			points -= enemyToAdd["price"]
			telegraph.add_child(spawn)
			await get_tree().create_timer(randf_range(0.8, 2)).timeout
	
	set_process(true)
