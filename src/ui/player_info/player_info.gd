class_name PlayerInfoUI extends Control


#region fields

var _player_info: PlayerInfo

#endregion


#region static

static func of(player_info: PlayerInfo) -> PlayerInfoUI:
	var player_info_ui = Registry.instantiate(Id.of_game("scenes.ui.player_info", "PlayerInfo")) as PlayerInfoUI
	player_info_ui._player_info = player_info
	return player_info_ui

#endregion
