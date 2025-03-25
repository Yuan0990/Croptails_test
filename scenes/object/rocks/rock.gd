extends Sprite2D
@onready var damage_component: DamageComponent = $DamageComponent
@onready var hurt_component: HurtComponent = $HurtComponent

var stone_scene = preload("res://scenes/object/rocks/stone.tscn")

#绑定受伤和死亡的信号
func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damage_reachd.connect(on_max_damaged_reached)

#受伤处理
func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)
	material.set_shader_parameter("shake_intensity",0.3)
	await get_tree().create_timer(0.5).timeout
	material.set_shader_parameter("shake_intensity",0.0)
	
#死亡处理
func on_max_damaged_reached() -> void:
	call_deferred("add_stone_scene")
	queue_free()

func add_stone_scene() -> void:
	var stone_instance = stone_scene.instantiate() as Node2D
	stone_instance.global_position = global_position
	get_parent().add_child(stone_instance)
