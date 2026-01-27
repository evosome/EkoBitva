class_name BuffComponent extends Node


#region fields

var _buffs_behaviors: Array[BuffBehavior]

@export var _target: Character
@export var _activating_timer: Timer

#endregion


#region builtins

func _ready() -> void:
    _activating_timer.timeout.connect(_on_activation_timeout)

#endregion


#region private

func _handle_buffs() -> void:
    for buff_behavior in _buffs_behaviors:
        if buff_behavior.should_reveal():
            _buffs_behaviors.erase(buff_behavior)
            continue
        
        buff_behavior.tick(_target)

#endregion


#region event handlers

func _on_activation_timeout() -> void:
    _handle_buffs()

#endregion
