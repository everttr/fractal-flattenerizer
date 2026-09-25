#version 330 compatibility
#extension GL_EXT_gpu_shader4: enable
#extension GL_EXT_geometry_shader4: enable

layout( triangles )  in;
//layout( points )  in;
layout( triangle_strip, max_vertices=128 )  out;

uniform int		uDepthRes;
uniform float	uDepth;
uniform float	uWidth;
uniform bool	uRotWithCam;

// Outputs to fragment shader
out vec3	gWC;	// world coords
out	vec2	gST;	// texture coords
out float	gDepth;	// depth from camera

// Globals
vec3 CENTER;
vec3 FORWARD;
vec3 UP;
vec3 RIGHT;

void
ProduceCorner(vec3 mc)
{
	//if (uRotWithCam)
	//{
	//	vec4 wc = vec4(mc, 1.);
	//	wc.z -= 5.0;
	//	gl_Position = gl_ProjectionMatrix * wc;
	//	gWC = vec3(gl_ModelViewMatrix * vec4(mc, 1.));
	//	//gl_Position = vec4(mc, 1.);
	//	//gWC = vec3(gl_ModelViewProjectionMatrix * vec4(mc, 1.));
	//	//gl_Position = gl_ProjectionMatrix * vec4(mc, 1.);
	//	//gWC = vec3(gl_ModelViewMatrix * vec4(mc, 1.));
	//}
	//else
	//{
	//	gl_Position = gl_ModelViewProjectionMatrix * vec4(mc, 1.);
	//	gWC = mc;
	//}
	
	gl_Position = gl_ModelViewProjectionMatrix * vec4(mc, 1.);
	gWC = mc;
	gDepth = gl_Position.z;
	EmitVertex();
}

void
ProduceQuad(float depth)
{
	vec3 v = CENTER;

	// Top left
	gST = vec2(0, 1);
	ProduceCorner(v - RIGHT * uWidth + UP * uWidth + FORWARD * depth);
	
	// Top right
	gST = vec2(1, 1);
	ProduceCorner(v + RIGHT * uWidth + UP * uWidth + FORWARD * depth);
	
	// Bottom left
	gST = vec2(0, 0);
	ProduceCorner(v - RIGHT * uWidth - UP * uWidth + FORWARD * depth);
	
	// Bottom right
	gST = vec2(1, 0);
	ProduceCorner(v + RIGHT * uWidth - UP * uWidth + FORWARD * depth);
	
	EndPrimitive();
}

void
main( )
{
	CENTER = (gl_PositionIn[0].xyz + gl_PositionIn[1].xyz + gl_PositionIn[2].xyz) / 3.;
	FORWARD = vec3(0., 0., 1.);
	UP = vec3(0., 1., 0.);
	RIGHT = vec3(1., 0., 0.);
	
	// re-orient basis vectors to face camera if needed
	if (uRotWithCam)
	{
		// I also translate & normalize them so only the
		// rotation is being re-oriented
		mat4 inv = inverse(gl_ModelViewMatrix);
		
		vec3 transformedCenter = vec3(inv * vec4(CENTER, 1.));

		FORWARD = vec3(inv * vec4(FORWARD + CENTER, 1.));
		FORWARD = FORWARD - transformedCenter;
		FORWARD /= length(FORWARD);

		UP =  vec3(inv * vec4(UP + CENTER, 1.));
		UP = UP - transformedCenter;
		UP /= length(UP);
		
		RIGHT = vec3(inv * vec4(RIGHT + CENTER, 1.));
		RIGHT = RIGHT - transformedCenter;
		RIGHT /= length(RIGHT);
	}
	
	float dz = 2.0 * uDepth / float(uDepthRes);

	for (int i = 0; i < uDepthRes; ++i)
	{
		float depth = dz * float(i) - uDepth;
		ProduceQuad(depth);
	}
}
