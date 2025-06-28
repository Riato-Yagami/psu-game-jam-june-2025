extends Resource
class_name Dimensions

@export_category("unit : mm, texture 1mm = 1px")

#Cavity
@export var cavity_width : float
@export var cavity_depth : float
@export var cavity_height : float

#Exterior
@export var width : float
@export var depth : float
@export var height : float

#Door
@export var door_width : float

#Plate
@export var plate_diametre : float
var plate_radius : float :
	get : return plate_diametre / 2
