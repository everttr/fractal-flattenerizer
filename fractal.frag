#version 330 compatibility

// Globals
uniform int		uType;
uniform float	uScale;
uniform float	uW;
uniform int		uOrder;
uniform float	uZx;
uniform float	uZy;
uniform float	uZz;
uniform float	uZw;
uniform int		uIterCount;
uniform float	uFogStart;
uniform float	uFogEnd;
uniform vec4	uColor1;
uniform vec4	uColor2;

// Inputs
in vec3		gWC;	// world coords
in vec2		gST;	// texture coords
in float	gDepth;	// depth from camera

// Constants
const float DIVERGENCE_CUTOFF = 2.0;

// Globals
vec4 C;

// Helper function
vec4
QuaternionSquare(vec4 v)
{
	// We love quaternions, don't we folks!
	return vec4(
		v.x * v.x - v.y * v.y - v.z * v.z - v.w * v.w,
		2.0 * v.x* v.y,
		2.0 * v.x * v.z,
		2.0 * v.x * v.w
	);
}

bool
Julia(vec4 z, vec4 c)
{
	// Equation: z[i] = z[i-1]^2 + c
	// not contained if diverges

	for (int i = 0; i < uIterCount; ++i)
	{
		z = QuaternionSquare(z) + c;
		if (length(z) > DIVERGENCE_CUTOFF)
			break;
	}
	
	// Check for divergence
	return length(z) <= DIVERGENCE_CUTOFF;
}

vec3
BulbSquare(vec3 v)
{
	// It's mostly to do with radial coords
	// (the order [uOrder] of the fractal is supposed to
	//  be an integer, but it still gives cool effects with
	//  decimal values, even if it makes the shape discontinuous)
	
	float r = length(v);
	// angle from horizon z=0
	float theta = atan(v.z / sqrt(v.x * v.x + v.y * v.y));
	// angle in XY-plane
	float phi = atan(v.y / v.x);
	
	float rToTheN = pow(r, uOrder);
	float cosTheta = cos(uOrder * theta);
	return vec3(
		rToTheN * cos(uOrder * phi) * cosTheta,
		rToTheN * sin(uOrder * phi) * cosTheta,
		rToTheN * sin(uOrder * theta)
	);
}

bool
MandelBulb(vec3 z, vec3 c)
{
	// Equation: z[i] = z[i-1]^2 + c
	// not contained if diverges

	for (int i = 0; i < uIterCount; ++i)
	{
		z = BulbSquare(z) + c;
		if (length(z) > DIVERGENCE_CUTOFF)
			break;
	}
	
	// Check for divergence
	return length(z) <= DIVERGENCE_CUTOFF;
}

void
main( )
{
	bool exclude;
	
	if (uType == 0)
		exclude = length(gWC) > uScale;
	else
	{
		vec4 constant = vec4(uZx, uZy, uZz, uZw);
		// 4D Mandelbrot
		if (uType == 1)
			exclude = !Julia(constant, vec4(gWC, uW) / uScale);
		// 4D Julia
		else if (uType == 2)
			exclude = !Julia(vec4(gWC, uW) / uScale, constant);
		// 3D Radial Mandelbulb
		else
			exclude = !MandelBulb(gWC / uScale, vec3(constant));
	}
	
	if (exclude)
		discard;
	
	float t = smoothstep(uFogStart, uFogEnd, gDepth);
    gl_FragColor = t * uColor1 + (1. - t) * uColor2;
}