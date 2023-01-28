extends Node

const CLICK = preload("res://assets/sounds/click3.ogg")
const MUSIC = preload("res://assets/sounds/bleeding_out2.ogg")
const ENEMY_SPAWN = preload("res://assets/sounds/footstep_carpet_000.ogg")
const ENEMY_CONTACT = preload("res://assets/sounds/footstep_concrete_002.ogg")
const DIED = preload("res://assets/sounds/impactBell_heavy_001.ogg")
const WIN = preload("res://assets/sounds/impactMining_000.ogg")
const LEVEL_UP = preload("res://assets/sounds/impactTin_medium_004.ogg")

onready var audioPlayers := $AudioPlayers
onready var musicPlayers := $MusicPlayers

func play_sound(sound):	
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break

func play_music(sound):	
	for audioStreamPlayer in musicPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
			
func stop_music():
	for audioStreamPlayer in musicPlayers.get_children():
		if audioStreamPlayer.playing:
			audioStreamPlayer.stop()
