extends Sprite2D
@onready var damage_component: DamageComponent = $DamageComponent
@onready var hurt_component: HurtComponent = $HurtComponent

var log_scene = preload("res://scenes/object/trees/log.tscn")

#绑定受伤和死亡的信号
func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damage_reachd.connect(on_max_damaged_reached)

#受伤处理
func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)
	material.set_shader_parameter("shake_intensity",0.5)
	await get_tree().create_timer(1.0).timeout
	material.set_shader_parameter("shake_intensity",0.0)
	
#死亡处理
func on_max_damaged_reached() -> void:
	call_deferred("add_log_scene")
	print("max damage reached")
	queue_free()

func add_log_scene() -> void:
	var log_instance = log_scene.instantiate() as Node2D
	log_instance.global_position = global_position
	get_parent().add_child(log_instance)
