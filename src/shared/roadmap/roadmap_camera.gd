class_name RoadmapCamera extends Camera2D


#region fields

var _is_dragging = false
var _drag_start_position = Vector2.ZERO
var _camera_start_position = Vector2.ZERO
var _zoom_in_tween: Tween
var _dragging_enabled: bool = true
var _manual_zooming_enabled: bool = true

@export var zoom_speed: float = 0.1
@export var min_zoom: Vector2 = Vector2(0.5, 0.5)
@export var max_zoom: Vector2 = Vector2(3.0, 3.0)

#endregion


#region builtins

func _input(event: InputEvent) -> void:
	if _dragging_enabled: _handle_cam_drag(event)
	if _manual_zooming_enabled: _handle_zoom_in_out(event)

#endregion


#region public

## This method is asynchronous
func do_zoom_in(zoom_position: Vector2, duration: float = 0.8) -> void:

	if _zoom_in_tween:
		print("Camera is already zooming in, kill previous tween animation")
		_zoom_in_tween.stop()
		_zoom_in_tween.kill()
	
	# Disable camera interactions
	_dragging_enabled = false
	_manual_zooming_enabled = false

	_zoom_in_tween = create_tween()

	zoom = min_zoom
	
	_zoom_in_tween.tween_property(self, "zoom", max_zoom, duration)
	_zoom_in_tween.parallel().tween_property(self, "position", zoom_position, duration)
	_zoom_in_tween.play()

	await _zoom_in_tween.finished

	_dragging_enabled = true
	_manual_zooming_enabled = true

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
