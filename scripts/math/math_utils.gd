class_name MathUtils extends RefCounted

static func frac_1d(x: float) -> float:
	return x - floor(x)
static func frac_2d(value:Vector2)-> Vector2:
	return Vector2(frac_1d(value.x),frac_1d(value.y))
## default remap [-1,1] to [0,1]  
static func constant_bias_scale(x:float,bias:float = 1,scale:float = 0.5)->float:
	return (x + bias) * scale
static func hash_u32(x:int) -> int:
	var n := x
	n = int((n ^ 61) ^ (n >> 16))
	n *= 9
	n = n ^ (n >> 4)
	n *= 0x27d4eb2d
	n = n ^ (n >> 15)
	return n & 0x7fffffff

static func hash01(x:int) -> float:
	return float(hash_u32(x)) / 2147483647.0
