@tool

class_name GitHubLinkWindow
extends Window

var github: GitHub
var linkButtonReady = false
var url: String = ""
@onready var usernameInput: LineEdit = get_node("Control/VBoxContainer/Control/Username")
@onready var repoNameInput: LineEdit = get_node("Control/VBoxContainer/Control2/RepoName")
@onready var tokenInput: LineEdit = get_node("Control/VBoxContainer/Control3/Token")

func _on_close_requested() -> void:
	queue_free()

func _on_link_button_pressed() -> void:
	if usernameInput != null and repoNameInput != null and tokenInput != null:
		url = "https://" + tokenInput.text + "@github.com/" + usernameInput.text + "/" + repoNameInput.text
		if github != null:
			if github.link(url):
				queue_free()
