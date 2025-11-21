@tool
class_name GitHub
extends Node

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
			print("An error occurred during the recuperation of repository changes. Error code: " + str(err))
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
	print("Trying to commit.")
	git(["add", "."], output)
	var err = git(["commit", "-m", message], output)
	if err:
		print("Commit has not succeed.")
	else:
		print("Commit has been done successfully.")

func pull():
	pass

func push():
	pass

func link(addr: String):
	var output = []
	var err = git(["remote", "add", "origin", addr], output)
	if err:
		print("Could not link to the remote repository.")

func check_git():
	var dir = DirAccess.open("res://")
	if dir.dir_exists(".git"):
		return true
	else:
		return false

func init():
	var output = []
	var err = git(["init"], output)
	if err:
		print("Repository could not be initialized.")
	else:
		print("Repository has been initialized.")
		err = commit("Initial commit.", output)
		if err:
			print("The initial commit has not succeed.")
		else:
			print("Made the initial commit successfully")
	

func _on_commit_button_pressed() -> void:
	var output = []
	var message = commitMessageNode.text
	if message == "":
		print("Please, write a message for the commit")
	else :
		commit(message, output)
