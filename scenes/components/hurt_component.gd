class_name HurtComponent
extends Area2D

@export var tool : DataTypes.Tools = DataTypes.Tools.None
#受伤的类
signal  hurt

#当产生碰撞的时候，执行此函数
func _on_area_entered(area: Area2D) -> void:
	var hit_component = area as HitComponent
	if tool == hit_component.current_tool:
		#发送当前工具所造成的伤害
		hurt.emit(hit_component.hit_damage)
