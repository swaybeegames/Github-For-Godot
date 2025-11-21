@tool
extends EditorPlugin


# A class member to hold the dock during the plugin life cycle.
var dock: Control
var dockActions: GitHub


func _enter_tree():
	dock = preload("res://addons/github-ui/scenes/github-pannel.tscn").instantiate()
	dockActions = dock.get_node("GitHub")
	if not dockActions.check_git():
		dockActions.init()
	add_control_to_dock(DOCK_SLOT_LEFT_BR, dock)


func _exit_tree():
	remove_control_from_docks(dock)
	# Erase the control from the memory.
	dock.free()

func _enable_plugin():
	var setting_path = "display/window/per_pixel_transparency/allowed"
	var is_allowed = ProjectSettings.get_setting(setting_path)
	if not is_allowed:
		ProjectSettings.set_setting(setting_path, true)
		ProjectSettings.save()
		print("[Git Plugin] Enabled per-pixel transparency. Please restart the editor if the window looks black.")
