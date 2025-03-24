class_name CollectableComponent
extends Area2D

# 名称作为导出变量
@export var collectable_name: String


func _on_body_entered(body: Node2D) -> void:
	#检查是不是玩家触碰
	if body is Player:
		InventoryManager.add_collectable(collectable_name)
		print("Collected：",collectable_name)
		get_parent().queue_free()
