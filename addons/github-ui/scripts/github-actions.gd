@tool
class_name GitHub
extends Node

var link_window_scene = preload("res://addons/github-ui/scenes/link_remote_repository.tscn")

@onready var commitMessageNode = $PannelContainer/InfosContainer/CommitMessageContainer/CommitMessage
@onready var gitTree: GridContainer

func git(args: Array, ou: Array):
	return OS.execute("git", args, ou)

func tree():
	var gitTree = get_node("PannelContainer/InfosContainer/ScrollContainer/RepositoryTree")
	for child in gitTree.get_children():
		child.queue_free()
	
	# En-tête
	var header_file = Label.new()
	header_file.text = "File"
	gitTree.add_child(header_file)
	var header_index = Label.new()
	header_index.text = "Index"
	gitTree.add_child(header_index)
	var header_work = Label.new()
	header_work.text = "Work"
	gitTree.add_child(header_work)
	
	if check_git():
		var output: Array = []
		var err: int = git(["status", "--porcelain"], output)
		
		if err != 0:
			alert(get_tree(), "An error occurred during the recuperation of repository changes. Error code: " + str(err))
		else:
			var full_output: String = "".join(output)
			var data: Array = full_output.split("\n", false)
			for line in data:
				if line.length() < 4:
					continue
				var path_label = Label.new()
				path_label.text = line.substr(3)
				gitTree.add_child(path_label)
				var index_label = Label.new()
				index_label.text = line.substr(0, 1)
				gitTree.add_child(index_label)
				var work_label = Label.new()
				work_label.text = line.substr(1, 1)
				gitTree.add_child(work_label)

func commit(message: String, output):
	git(["add", "."], output)
	if git(["commit", "-m", message], output):
		alert(get_tree(), "Commit has not succeed.")
	else:
		alert(get_tree(), "Commit has been done successfully.")
		

func pull()->bool:
	return git(["pull"], [])

func push():
	return git(["push"], [])

func is_linked()->bool:
	var err = git(["ls-remote"], [])
	if err:
		return false
	return true

func link(addr: String)->bool:
	var output = []
	if git(["remote", "add", "origin", addr], output):
		return false
	return true

func check_git():
	var dir = DirAccess.open("res://")
	if dir.dir_exists(".git"):
		return true
	else:
		return false

func init():
	var output = []
	if git(["init"], output):
		alert(get_tree(), "Repository could not be initialized.")
	else:
		alert(get_tree(), "Repository has been initialized.")
		if commit("Initial commit.", output):
			alert(get_tree(), "The initial commit has not succeed.")
		else:
			alert(get_tree(), "Made the initial commit successfully")
	

func _on_commit_button_pressed() -> void:
	var output = []
	var message = commitMessageNode.text
	if message == "":
		alert(get_tree(), "Please, write a message for the commit")
	else :
		print("trying to commit")
		commit(message, output)


func _on_link_button_pressed() -> void:
	if not is_linked():
		var link_window_instance: GitHubLinkWindow = link_window_scene.instantiate()
		link_window_instance.github = self
		add_child(link_window_instance)

func _on_link_button_tree_entered() -> void:
	var linkButton : Button = get_node("PannelContainer/GitActionContainer/LinkButton")
	if is_linked():
		linkButton.icon.resource_path = "res://addons/github-ui/icons/link.svg"
	else:
		linkButton.icon.resource_path = "res://addons/github-ui/icons/unlink.svg"

static func createAlert(msg: String)->AcceptDialog:
	var dialog = AcceptDialog.new()
	dialog.dialog_text = msg
	dialog.connect("close_requested", Callable(dialog, "queue_free"))
	dialog.connect("confirmed", Callable(dialog, "queue_free"))
	return dialog

static func alert(tree, msg: String):
	var alert = createAlert(msg)
	tree.root.add_child(alert)
	alert.popup_centered()
