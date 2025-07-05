extends Node
class_name MeshParent

var meshes : Array[MeshInstance3D]

func _ready() -> void:
	var meshes_parent = find_children("*","MeshInstance3D") as Array[MeshInstance3D]
	for m in meshes_parent: meshes.push_back(m)

func modulate(color : Color , time = 0) -> void :
	for m in meshes :
		m.mesh.surface_get_material(0).albedo_color = color
	if(time>0):
		await SleepManager.sleep(time)
		modulate(Color.WHITE)
