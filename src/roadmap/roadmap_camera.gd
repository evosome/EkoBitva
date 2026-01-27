extends Camera2D


#region fields

var _is_dragging = false
var _drag_start_position = Vector2.ZERO
var _camera_start_position = Vector2.ZERO

@export var zoom_speed: float = 0.1
@export var min_zoom: Vector2 = Vector2(0.5, 0.5)
@export var max_zoom: Vector2 = Vector2(3.0, 3.0)

#endregion


#region builtins

func _input(event: InputEvent) -> void:
	_handle_cam_drag(event)
	_handle_zoom_in_out(event)

#endregion


#region private

func _handle_cam_drag(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				_is_dragging = true
				_drag_start_position = event.position
				_camera_start_position = position
			else:
				_is_dragging = false

	elif event is InputEventMouseMotion and _is_dragging:
		var drag_distance = (event.position - _drag_start_position) / zoom
		position = _camera_start_position - drag_distance


func _handle_zoom_in_out(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var zoom_factor: float = 1.0

		if event.is_action_pressed("zoom_out"):
			zoom_factor = 1.0 / (1.0 + zoom_speed)
		elif event.is_action_pressed("zoom_in"):
			zoom_factor = 1.0 + zoom_speed
		else:
			return

		var mouse_before_zoom: Vector2 = get_global_mouse_position()

		var new_zoom: Vector2 = get_zoom() * zoom_factor
		new_zoom.x = clamp(new_zoom.x, min_zoom.x, max_zoom.x)
		new_zoom.y = clamp(new_zoom.y, min_zoom.y, max_zoom.y)
		set_zoom(new_zoom)

		var mouse_after_zoom: Vector2 = get_global_mouse_position()
		set_global_position(get_global_position() + mouse_before_zoom - mouse_after_zoom)

#endregion
