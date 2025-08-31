extends Node


const Sound = preload("res://sound_manager/sound.tscn")
const Sound2d = preload("res://sound_manager/2d_sound.tscn")
const Sound3d = preload("res://sound_manager/3d_sound.tscn")
const Music = preload("res://sound_manager/music.tscn")

const MUSIC : Dictionary = {
	"Map" : {"sound" : preload("res://music/Map.wav")},
	"Menu" : {"sound" : preload("res://music/Venus.wav")},
	"Mars" : {"sound" : preload("res://music/Mars.wav")},
	"Intro" : {"sound" : preload("res://music/BossIntro.wav")},
	"Boss" : {"sound" : preload("res://music/BossMain.wav")}
}

const SOUNDS : Dictionary = {
	"Intro" : {"sound" : preload("res://music/Intro Jingle.wav"), "pitchRange" : [1.0, 1.0],
		"volume" : -5},
	"GameOver" : {"sound" : preload("res://music/Warp Jingle.wav"), "pitchRange" : [1.0, 1.0],
		"volume" : -5},
	"Spike" : {"sound" : preload("res://sfx/Spike.wav"), "pitchRange" : [1.5, 1.9],
		"volume" : -12},
	"Hit" : {"sound" : preload("res://sfx/Hit.wav"), "pitchRange" : [1.0, 1.1],
		"volume" : -10},
	"Powerup" : {"sound" : preload("res://sfx/Powerup.wav"), "pitchRange" : [1.0, 1.1],
		"volume" : -10},
	"Win" : {"sound" : preload("res://music/Win Jingle.wav"), "pitchRange" : [1.0, 1.0],
		"volume" : -5}
}

var currentSong : String = ""

@export var mute = false

@onready var music


func _ready() -> void:
	var musicInst = Music.instantiate()
	add_child(musicInst)
	music = get_child(0)

func set_volume(volume : float) -> void:
	music.volume_db = volume

func play_music(songId : String, replay : bool = false) -> void:
	if !mute:
		if songId == "":
			music.stop()
		elif currentSong != songId or replay:
			music.stream = MUSIC[songId]["sound"]
			music.play()
		currentSong = songId

func create_sound(soundId : String, global : bool = false) -> void:
	if soundId != "":
		var sound = Sound.instantiate()
		get_tree().current_scene.call_deferred("add_child", sound) if !global else call_deferred("add_child", sound)
		sound.stream = SOUNDS[soundId]["sound"]
		sound.volume_db = SOUNDS[soundId]["volume"]
		sound.pitch_scale = randf_range(SOUNDS[soundId]["pitchRange"][0],\
		SOUNDS[soundId]["pitchRange"][0])
		sound.call_deferred("play")

func create_sound2d(soundId : String, pos : Vector2, global : bool = false):
	if soundId != "":
		var sound = Sound2d.instantiate()
		get_tree().current_scene.add_child(sound) if !global else add_child(sound)
		sound.position = pos
		sound.stream = SOUNDS[soundId]["sound"]
		sound.pitch_scale = randf_range(SOUNDS[soundId]["pitchRange"][0], SOUNDS[soundId]["pitchRange"][1])
		sound.volume_db = SOUNDS[soundId]["volume"]
		sound.call_deferred("play")

func create_sound3d(soundId : String, pos : Vector3, global : bool = false):
	if soundId != "":
		var sound = Sound3d.instantiate()
		get_tree().current_scene.add_child(sound) if !global else add_child(sound)
		sound.position = pos
		sound.stream = SOUNDS[soundId]["sound"]
		sound.pitch_scale = randf_range(SOUNDS[soundId]["pitchRange"][0], SOUNDS[soundId]["pitchRange"][1])
		sound.volume_db = SOUNDS[soundId]["volume"]
		sound.call_deferred("play")
