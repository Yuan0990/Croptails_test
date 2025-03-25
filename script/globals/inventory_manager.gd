extends Node

#创建一个字典用于装载对应背包物品
var inventory: Dictionary = Dictionary()
#当有物品数量产生变化时，就会触发此信号
signal inventory_changed
#传入一个对应的物品，从而进行++
func add_collectable(colleactable_name: String) -> void:
	inventory.get_or_add(colleactable_name)#添加物品到字典中
	
	if(inventory[colleactable_name] == null):
		inventory[colleactable_name] = 1
	else:
		inventory[colleactable_name] +=1
		
	inventory_changed.emit()
