class_name Vec extends Object
# shortcuts like in shader language



# 3D to wall
static func xy(input:Vector3): return Vector2(input.x,input.y)
# 3D to 2D surface
static func xz(input:Vector3): return Vector2(input.x,input.z)


static func yx(input:Vector3): return Vector2(input.y,input.x)
static func yz(input:Vector3): return Vector2(input.y,input.z)
static func zx(input:Vector3): return Vector2(input.z,input.x)
static func zy(input:Vector3): return Vector2(input.z,input.y)


static func xx(input:Vector3): return Vector2(input.x,input.x)
static func zz(input:Vector3): return Vector2(input.z,input.z)
static func yy(input:Vector3): return Vector2(input.y,input.y)
