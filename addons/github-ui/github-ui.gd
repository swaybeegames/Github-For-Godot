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
		print("A repository has been created.")
	else:
		print("A repository exists.")
		dockActions.tree()
	add_control_to_dock(DOCK_SLOT_LEFT_BR, dock)


func _exit_tree():
	remove_control_from_docks(dock)
	# Erase the control from the memory.
	dock.free()
