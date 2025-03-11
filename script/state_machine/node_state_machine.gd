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
	for child in get_children():
		if child is NodeState:
			node_states[child.name.to_lower()] = child
			child.transition.connect(transition_to)
	
	if initial_node_state:
		initial_node_state._on_enter()
		current_node_state = initial_node_state
		
func _process(delta: float) -> void:
	if current_node_state:
		current_node_state._on_process(delta)
		
func _physics_process(delta: float) -> void:
	if current_node_state:
		current_node_state._on_physics_process(delta)
		current_node_state._on_next_transitions()
		
func transition_to(node_state_name : String) -> void:
	if node_state_name == current_node_state.name.to_lower():
		return
	
	var new_node_state = node_states.get(node_state_name.to_lower())
	
	if !new_node_state:
		return
	
	if current_node_state:
		current_node_state._on_exit()
		
	new_node_state._on_enter()
	
	current_node_state = new_node_state
	current_node_state_name = current_node_state_name.to_lower()
	print("Current State:",current_node_state_name)
