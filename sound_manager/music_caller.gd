extends Node


@export var song : String = ""
@export var replace : bool = false
@export var mute    : bool = false
@export var volume : float = -5


func _ready():
	if !mute:
		SoundManager.play_music(song, replace)
		SoundManager.set_volume(volume)
	queue_free()
