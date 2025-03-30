extends Node2D
#玉米收割场景
var corn_harvest_scence = preload("res://scenes/object/plant/corn_harvest.tscn")
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var flowering_particles: GPUParticles2D = $FloweringParticles
@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent
@onready var hurt_component: HurtComponent = $HurtComponent
#生长状态
var growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Seed

func _ready() -> void:
	watering_particles.emitting = false
	flowering_particles.emitting = false
	hurt_component.hurt.connect(on_hurt)
	growth_cycle_component.crop_maturity.connect(on_crop_maturity)
	
func _process(delta: float) -> void:
	growth_state = growth_cycle_component.get_current_growth_state()
	sprite_2d.frame = growth_state
	
	if growth_state == DataTypes.GrowthStates.Maturity:
		flowering_particles.emitting = true
	
#告诉系统，已经浇水了
func on_hurt(hit_damage: int)-> void:
	if !growth_cycle_component.is_watered:
		#启用浇水粒子，提示玩家浇水
		watering_particles.emitting = true
		await get_tree().create_timer(5.0).timeout
		watering_particles.emitting = false
		growth_cycle_component.is_watered = true
	
#植物成熟时的调用函数
func on_crop_maturity() -> void:
	#花朵粒子特效开启
	flowering_particles.emitting = true
	
