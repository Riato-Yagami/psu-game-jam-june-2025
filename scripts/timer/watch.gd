extends Resource
class_name Watch

var h : int
var m : int
var s : int
var ms : int

var ph : String : 
	get : return Parse.digit(h,2)
	
var pm : String : 
	get : return Parse.digit(m,2)
	
var ps : String : 
	get : return Parse.digit(s,2)
	
var pms : String :
	get : return Parse.digit(ms,3)
