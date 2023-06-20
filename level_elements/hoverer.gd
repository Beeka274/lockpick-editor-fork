extends Node2D
class_name HoverHighlight

signal adapted_to(obj: Node)

var current_obj: Node:
	set(val):
		current_obj = val if is_instance_valid(val) else null
	get:
		if not is_instance_valid(current_obj):
			stop_adapting()
		return current_obj

@onready var line: Line2D = %Line2D
@export var color: Color:
	set(val):
		color = val
		modulate = color
@export var width := 2:
	set(val):
		width = val
		if not is_node_ready(): return
		adjust_to_width()

func _ready() -> void:
	_hide_all()
	adjust_to_width()

func adjust_to_width() -> void:
	line.width = width

func stop_adapting_to(obj: Object) -> void:
	if obj == current_obj:
		stop_adapting()

func stop_adapting() -> void:
	_hide_all()
	current_obj = null

func _hide_all() -> void:
	line.hide()

func is_adapting() -> bool:
	return is_instance_valid(current_obj)

func adapt_to(obj: Node) -> void:
	if not is_instance_valid(obj):
		stop_adapting()
		return
	if obj == current_obj:
		return
	current_obj = obj
	_hide_all()
	if obj is Door:
		var data: DoorData = obj.door_data
		assert(is_instance_valid(data))
		line.show()
		line.global_position = obj.global_position
		line.clear_points()
		line.add_point(Vector2(0, 0))
		line.add_point(Vector2(data.size.x, 0))
		line.add_point(Vector2(data.size.x, data.size.y))
		line.add_point(Vector2(0, data.size.y))
		line.add_point(Vector2(0, 0))
	if obj is Key:
		var data: KeyData = obj.key_data
		assert(is_instance_valid(data))
		line.show()
		line.global_position = obj.global_position
		line.clear_points()
		line.add_point(Vector2(0, 0))
		line.add_point(Vector2(32, 0))
		line.add_point(Vector2(32, 32))
		line.add_point(Vector2(0, 32))
		line.add_point(Vector2(0, 0))
	adapted_to.emit(obj)
