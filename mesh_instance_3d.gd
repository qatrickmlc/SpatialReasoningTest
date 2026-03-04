extends MeshInstance3D

@onready var shape_container: Node3D = $".."

var m := ArrayMesh.new();
var arr := [];
var cam := Camera3D.new()

var rand = RandomNumberGenerator.new();

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	rand.randomize();
	
	cam.position = Vector3(3, 3, 3)
	add_child(cam)
	cam.look_at(Vector3.ZERO)
	
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.environment.ambient_light_color = Color(1, 1, 1)
	env.environment.ambient_light_energy = 1.0
	add_child(env)
	
	var shadMat = ShaderMaterial.new();
	shadMat.shader = preload("uid://bxr3xnrbrxmnp");
	
	var size := Vector3.ONE;
	m.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, genCubeSurf(size));
	
	var material := StandardMaterial3D.new();
	material.vertex_color_use_as_albedo = true;
	material.next_pass = shadMat;
	m.surface_set_material(0,material);
	
	self.mesh = m;
	
	

func genCubeSurf(size: Vector3) -> Array:
	
	var hx := size.x * 0.5;
	var hy := size.y * 0.5;
	var hz := size.z * 0.5;
	
	var vertices := PackedVector3Array();
	var normals := PackedVector3Array();
	var uvs := PackedVector3Array();
	var indices := PackedInt32Array();
		
	
	#+z
	addFace(
		Vector3(-hx, -hy,  hz),
		Vector3( hx, -hy,  hz),
		Vector3( hx,  hy,  hz),
		Vector3(-hx,  hy,  hz),
		Vector3(0, 0, 1),
		vertices, normals, uvs, indices
	)
	
	#-z
	addFace(
		Vector3( -hx, hy,  -hz),
		Vector3( hx, hy, -hz),
		Vector3( hx,  -hy, -hz),
		Vector3( -hx,  -hy,  -hz),
		Vector3(0, 0, -1),
		vertices, normals, uvs, indices
	)
	
	#+x
	addFace(
		Vector3( hx, hy,  hz),
		Vector3( hx, -hy, hz),
		Vector3( hx, -hy, -hz),
		Vector3( hx,  hy,  -hz),
		Vector3(1, 0, 0),
		vertices, normals, uvs, indices
	)
	
	#-x
	addFace(
		Vector3( -hx, hy,  -hz),
		Vector3( -hx, -hy, -hz),
		Vector3( -hx, -hy, hz),
		Vector3( -hx,  hy,  hz),
		Vector3(-1, 0, 0),
		vertices, normals, uvs, indices
	)
	
	#+y
	addFace(
		Vector3(-hx,  hy,  hz),
		Vector3( hx,  hy,  hz),
		Vector3( hx,  hy, -hz),
		Vector3(-hx,  hy, -hz),
		Vector3(0, 1, 0),
		vertices, normals, uvs, indices
	)
	
	#-y
	addFace(
		Vector3(-hx,  -hy,  -hz),
		Vector3( hx,  -hy,  -hz),
		Vector3( hx,  -hy, hz),
		Vector3(-hx,  -hy, hz),
		Vector3(0, -1, 0),
		vertices, normals, uvs, indices
	)
	
	arr.resize(Mesh.ARRAY_MAX);
	arr[Mesh.ARRAY_VERTEX] = vertices;
	arr[Mesh.ARRAY_NORMAL] = normals;
	arr[Mesh.ARRAY_TEX_UV] = uvs;
	arr[Mesh.ARRAY_INDEX] = indices;
	arr[Mesh.ARRAY_COLOR] = PackedColorArray([
		Color.BLUE, Color.BLUE, Color.BLUE, Color.BLUE,
		Color.CYAN, Color.CYAN, Color.CYAN, Color.CYAN,
		Color.RED, Color.RED, Color.RED, Color.RED,
		Color.MAGENTA, Color.MAGENTA, Color.MAGENTA, Color.MAGENTA,
		Color.GREEN, Color.GREEN, Color.GREEN, Color.GREEN,
		Color.YELLOW, Color.YELLOW, Color.YELLOW, Color.YELLOW
	])
	
	return arr;

func addFace(a: Vector3, b: Vector3, c: Vector3, d: Vector3, n: Vector3, vertArr: PackedVector3Array, normArr: PackedVector3Array, uvArr: PackedVector3Array, indexArr: PackedInt32Array):
	var start := vertArr.size();
	
	vertArr.append_array([a,b,c,d]);
	normArr.append_array([n,n,n,n]);
	
	uvArr.append_array([
		Vector2(0,0),
		Vector2(1,0),
		Vector2(1,1),
		Vector2(0,1)
	]);
	
	indexArr.append_array([
		start + 0, start + 2, start + 1,
		start + 0, start + 3, start + 2
	])



func createCubeTrainOrigins(total_amount: int) -> PackedVector3Array :
	var dn: PackedVector3Array = [
		Vector3( 1, 0, 0 ), 	# +x
		Vector3( -1, 0, 0 ), 	# -x
		Vector3( 0, 1, 0 ),		# +y
		Vector3( 0, -1, 0 ),	# -y
		Vector3( 0, 0, 1 ),		# +z
		Vector3( 0, 0, -1 ),	# -z
	];
	
	var points := PackedVector3Array();
	
	var current := Vector3.ZERO;
	
	for i in range(total_amount):
		points.append(current);
		current += dn[rand.randi_range(0,5)];
	
	return points;
	

var timer := 0.0;
var interval := .027
var theta = 0.0;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	timer += delta
	if timer >= interval:
		cam.position = 2*Vector3(sin(deg_to_rad(theta)),cos(deg_to_rad(theta*0.25)),cos(deg_to_rad(theta)));
		cam.look_at(Vector3.ZERO);
		theta+=1;
		while theta >= 36000:
			theta=0;
		timer -= interval
		
		
