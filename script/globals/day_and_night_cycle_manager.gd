extends Node

#每天的分钟数
const MINUTES_PER_DAY: int = 24*60
#每小时的分钟数
const MINUTES_PER_HOUR: int = 60
#游戏分钟持续时间
const GAME_MINUTE_DURATTOM: float = TAU / MINUTES_PER_DAY

#游戏时间速度
var game_speed: float = 5.0

var initial_day: int = 1
var initial_hour: int = 12
var initial_minute:int =30

var time: float = 0.0
var current_minute: int = -1#当前分钟数
var current_day:int = 0

#声明游戏时间
signal game_time(time: float)
#时间刻度
signal time_tick(day: int, hour: int, minute: int)
#表示天数的时间流逝
signal time_tick_day(day: int)

func _ready() -> void:
	set_initial_time()
	
func _process(delta: float) -> void:
	time += delta * game_speed * GAME_MINUTE_DURATTOM
	game_time.emit(time)
	
	recalculate_time()
	
#用于初始化时间
func set_initial_time()-> void:
	var initial_total_minute = initial_day * MINUTES_PER_DAY + initial_hour * MINUTES_PER_HOUR + initial_minute
	
	time = initial_total_minute * GAME_MINUTE_DURATTOM

func recalculate_time() -> void:
	var total_minutes: int = int(time / GAME_MINUTE_DURATTOM)
	var day: int = int(total_minutes / MINUTES_PER_DAY)
	#取模今天的分钟
	var current_day_minutes: int = total_minutes % MINUTES_PER_DAY
	#取模当前为第几小时
	var hour: int = int(current_day_minutes / MINUTES_PER_HOUR)
	var minute: int = int(current_day_minutes % MINUTES_PER_HOUR)
	
	if current_minute != minute:
		current_minute = minute
		time_tick.emit(day,hour,minute)
		
	if current_day != day:
		current_day = day
		time_tick_day.emit(day)
