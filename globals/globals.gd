extends Node


# Effects:
const BurstSnow  := preload("res://particles/burst_snow.tscn")
const BurstStars := preload("res://particles/burst_stars.tscn")
const SpikeSnow  := preload("res://spike_snow/spike_snow.tscn")
const Bullet     := preload("res://enemies/bullet.tscn")
const PopUp      := preload("res://particles/pop_up.tscn")

# Textures:
const FloorDead := preload("res://level/FloorDead.png")

# Misc:
const Spawn := preload("res://enemies/spawn.tscn")


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
