@tool
class_name GitHub
extends Node

@onready var commitMessageNode = $PannelContainer/InfosContainer/CommitMessageContainer/CommitMessage

func git(args: Array, ou: Array):
	return OS.execute("git", args, ou)

func tree():
	var output = []
	var err = git(["status", "--porcelain"], output)
	print("output :")
	print(output)
	print("errors :")
	print(err)

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
		print("'.git' directory not found. Git repository is not initialized.")
		return true
	else:
		print("'.git' directory found. Git repository is already initialized.")
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
