class_name GrowthCycleComponent
extends Node
#植物的当前生长状态，设定种子为默认参数值
@export var current_growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Germination
#收获前的天数
@export_range(5,365) var days_until_hearvest: int = 7

#植物成熟的信号
signal crop_maturity
#植物收获的信号
signal crop_harvesting

#植物浇水状态
var is_watered: bool
#起始日
var starting_day: int
#当前日
var current_day: int

func _read()-> void:
	#获取每日信号
	DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)

#浇水后，生长周期开始
func on_time_tick_day(day: int)-> void:
	if is_watered:
		if starting_day == 0:
			starting_day = day
		
		growth_states(starting_day,day)
		harvest_state(starting_day,day)
		
#成长阶段的，生长状态函数
func growth_states(starting_day: int, current_day: int)-> void:
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		return
		
	#状态数量
	var num_states = 5
	#计算已经生长的天数，生长状态的天数是固定的
	var growth_days_passed=(current_day-starting_day)%num_states
	#状态索引
	var state_index = growth_days_passed + 1
	
	current_growth_state = state_index
	
	var name = DataTypes.GrowthStates.keys()[current_growth_state]
	print("Current growth state: ",name," State index: ",state_index)
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		crop_harvesting.emit()

#收获阶段的，收获状态函数
func harvest_state(starting_day: int, current_day: int)-> void:
	if current_growth_state == DataTypes.GrowthStates.Harvesting:
		return
	#收获状态可以设置不同的天数
	var days_passed = (current_day - starting_day)%days_until_hearvest
	
	if days_passed == days_until_hearvest - 1:
		current_growth_state = DataTypes.GrowthStates.Harvesting
		crop_harvesting.emit()

#获得当前生长的状态
func get_current_growth_state() -> DataTypes.GrowthStates:
	return current_growth_state
