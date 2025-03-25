extends Node

var selectd_tool: DataTypes.Tools = DataTypes.Tools.None

signal tool_selected(tool: DataTypes.Tools)

func select_tool(tool: DataTypes.Tools) -> void:
	tool_selected.emit(tool)
	selectd_tool = tool
