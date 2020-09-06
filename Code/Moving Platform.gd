extends Node2D

const idle_dir = 1.0

export var move_to = Vector2.RIGHT * 2 * Global.UNIT_SIZE
export var speed = 3

onready var platform = $Platform
onready var tween = $Tween

func _init_tween():
	var dur = move_to.length() / float(speed * Global.UNIT_SIZE)
	tween.interpolate_property(platform, "position", Vector2.ZERO, move_to, dur, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, idle_dir)
	tween.interpolate_property(platform, "position", move_to, dur, Vector2.ZERO, dur, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT, idle_dir)
	tween.start()

func _ready():
	_init_tween()
