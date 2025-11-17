
extends Node3D

@onready var checkpoints = $Track/CheckPoints      # All checkpoints
@onready var racers = $Racers.get_children()      # All racers

var total_laps: int = 3           # Total laps in the race
var race_started: bool = false    # Is the race currently running

var racer_progress = {}

func _ready():
	
	for racer in racers:
		racer_progress[racer] = { "lap": -1, "checkpoint": -1 }  # Start before first point and before the first lap
		racer.add_to_group("racer") 

	for point in checkpoints.get_children():
		point.connect("checkpoint_reached", Callable(self, "_on_checkpoint_reached"))

func start_race_countdown():
	await get_tree().create_timer(1).timeout
	print("race start")
	race_started = true


func _on_checkpoint_reached(racer, index):
	if not race_started:
		return 

	var progress = racer_progress[racer]
	var total_points = checkpoints.get_child_count()

	# Determine the next correct point in the sequence
	var next_index = (progress["checkpoint"] + 1) % total_points
	print("check point reached")
	
	# Only accept the checkpoint if it's in the correct order
	if index == next_index:
		progress["checkpoint"] = index

		# Completed a lap if the racer passes the first point (index 0)
		if index == 0:
			progress["lap"] += 1
			print("%s completed lap %d" % [racer.name, progress["lap"]])

			# Racer finished the race
			if progress["lap"] >= total_laps:
				_on_racer_finished(racer)


# Called when a racer finishes all laps
func _on_racer_finished(racer):
	print("%s finished the race!" % racer.name)
	# Optional: stop racer from moving if you have a controller script
	if "set_process" in racer:
		racer.set_process(false)
