extends Node3D
class_name Line3D

@export var points: Array[Node3D]

var mesh_instance: MeshInstance3D
var immediate_mesh: ImmediateMesh

func _ready():
	mesh_instance = MeshInstance3D.new()
	immediate_mesh = ImmediateMesh.new()
	mesh_instance.mesh = immediate_mesh

	var material = ORMMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.RED
	mesh_instance.material_override = material

	add_child(mesh_instance)

func _process(delta: float) -> void:
	if points.size() >= 2:
		draw_line(points[0].position, points[1].position)

func draw_line(pos1: Vector3, pos2: Vector3):
	immediate_mesh.clear_surfaces()
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()
