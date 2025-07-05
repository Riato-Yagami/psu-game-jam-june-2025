extends Node

func sleep(s: float) -> bool:
	await get_tree().create_timer(s).timeout
	return true
