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
			if github.link(url):
				queue_free()
