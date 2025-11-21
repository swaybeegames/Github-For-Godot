@tool

class_name GitHubLinkWindow
extends Window

var github: GitHub
var linkButtonReady = false
var url: String = ""
@onready var urlInput: LineEdit = get_node("Control/VBoxContainer/Control2/URLInput")

func _on_close_requested() -> void:
	queue_free()

func _on_link_button_pressed() -> void:
	if urlInput != null:
		url = urlInput.text
		if github != null:
			if not github.link(url):
				GitHub.alert(get_tree(), "An error as occurred while trying to link a remote repository. Please, check the provided url and the ssh keys.")
			else:
				queue_free()
