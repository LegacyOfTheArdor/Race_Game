extends Area3D

# Index of this checkpoint in the race order
@export var checkpoint_index: int

signal checkpoint_reached(car, index)

func _ready():
	# Connect built-in Area3D signal to our handler
	body_entered.connect(Callable(self, "_on_body_entered"))

# Called when a physics body enters this checkpoint
func _on_body_entered(body):
	print("checkpoint " + str(checkpoint_index) + " reached")
	# Only respond to Car nodes
	if body.is_in_group("racer"):
		# Emit signal to RaceManager
		emit_signal("checkpoint_reached", body, checkpoint_index)
