class_name DamageComponent

extends Node2D

@export var max_damage = 1
@export var current_damage = 0

signal max_damage_reachd
#应用伤害
func apply_damage(damage: int) -> void:
	#伤害只能在0~max_damage之间
	current_damage = clamp(current_damage + damage,0,max_damage)
	if current_damage == max_damage:
		max_damage_reachd.emit()
		print("树已经被砍掉")
