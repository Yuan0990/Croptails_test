class_name NodeStateMachine
extends Node

#保持初始的状态节点
@export var initial_node_state : NodeState

#node_states会保持所有状态节点
var node_states : Dictionary = {} 
#current_node_state正在运行的节点
var current_node_state : NodeState
#current_node_state_name当前节点的名称
var current_node_state_name : String

func _ready() -> void:
	for child in get_children():#遍历所有的子节点
		if child is NodeState:# 检查是否为 NodeState 类型
			node_states[child.name.to_lower()] = child# 将子节点存入字典（键为小写名称）
			child.transition.connect(transition_to)# 连接状态的 transition 信号到 transition_to 方法
	
	if initial_node_state:# 如果设置了初始状态
		initial_node_state._on_enter()# 调用初始状态的进入逻辑
		current_node_state = initial_node_state
		
func _process(delta: float) -> void:
	if current_node_state:
		current_node_state._on_process(delta)
		
func _physics_process(delta: float) -> void:
	if current_node_state:
		current_node_state._on_physics_process(delta)
		current_node_state._on_next_transitions()# 检查是否满足状态切换条件
		
func transition_to(node_state_name : String) -> void:# 通过状态名称切换状态
	if node_state_name == current_node_state.name.to_lower():# 如果目标状态与当前状态相同，直接返回
		return
	
	var new_node_state = node_states.get(node_state_name.to_lower())
	
	if !new_node_state:
		return
	
	if current_node_state:
		current_node_state._on_exit()
	
	new_node_state._on_enter()
	
	current_node_state = new_node_state#当前状态的切换
	current_node_state_name = current_node_state_name.to_lower()
	print("Current State:",current_node_state_name)
