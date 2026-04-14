class_name GoldenSeq extends RefCounted
## golden ratio conjugate = phi - 1
const GOLDEN_RATIO_CONJUGATE: float = 0.6180339887498948
## sqrt(2) - 1
const ALPHA_SILVER: float = 0.4142135623730950


const KRO_2D_ALPHA: Vector2 = Vector2(0.7548776662466927, 0.5698402909980532)

#https://extremelearning.com.au/unreasonable-effectiveness-of-quasirandom-sequences/
const KRO_2D_ALPHA_X: float = 0.7548776662466927
const KRO_2D_ALPHA_Y: float = 0.5698402909980532

## return [0,1] golden ratio sequnce
static func rand(index : int ,phase : float = 0., alpha: float = GOLDEN_RATIO_CONJUGATE)-> float:
	return MathUtils.frac_1d(phase + float(index) *alpha)
## return [-1,1] golden ratio sequnce
static func rand_signed(index : int ,phase : float = 0., alpha: float = GOLDEN_RATIO_CONJUGATE) ->float:
	return MathUtils.frac_1d(phase + float(index) *alpha) * 2. -1.
## return [from,to] golden ratio sequnce
static func rand_range(index : int ,from : float, to :float , phase : float = 0., alpha: float = GOLDEN_RATIO_CONJUGATE) -> float:
	return lerpf(from,to,rand(index,phase,alpha))
## return [center * (1. - max_range_ratio),center * (1. + max_range_ratio)] golden ratio sequnce, max_range_ratio indicate offset ratio around center
static func rand_around(index : int ,center : float =1., max_range_ratio :float = 0., phase : float = 0., alpha: float = GOLDEN_RATIO_CONJUGATE) -> float:
	return lerpf(center * (1. - max_range_ratio) ,center * (1. + max_range_ratio),rand(index,phase,alpha))

## return [0,1] golden ratio sequnce vector2
static func rand_2d(index : int ,phase : Vector2 = Vector2.ZERO, alpha: Vector2 = KRO_2D_ALPHA)->Vector2:
	return MathUtils.frac_2d(phase + float(index) * alpha)

	
## get a random angle between [-max_rand_degree,max_rand_degree]
static func get_rand_angle(max_rand_degree : float, index : int ,phase : float = 0., alpha: float = GOLDEN_RATIO_CONJUGATE)->float:
	var max_angle_offset: float = deg_to_rad(max_rand_degree)
	return rand_signed(index,phase,alpha) * max_angle_offset
	
