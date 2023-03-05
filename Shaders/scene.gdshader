shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;

uniform float time = 0.0;
uniform bool is_active = true;

// https://www.shadertoy.com/view/ldjGzV

float get_noise(vec2 p) {
	float s = texture(screen_texture, vec2(1.0, 2.0 * cos(time)) * time * 8.0 + p * 1.0).x;
	s *= s;
	return s;
}

float ramp(float y, float start, float end) {
	float inside = step(start, y) - step(end, y);
	float fact = (y - start) / (end - start) * inside;
	return (1.0 - fact) * inside;
}

vec4 get_stripes(vec2 uv) {
	float noise = get_noise(uv * vec2(0.5, 1.0) + vec2(1.0, 3.0)) * 2.5;
	return vec4(ramp(mod(uv.y * 4.0 + time / 2.0 + sin(time + sin(time * 0.63)), 1.0), 0.5, 0.6) * noise);
}

vec4 vignette(vec2 uv) {
	float vigAmt = 3.0 + 0.3 * sin(time + 5.0 * cos(time * 5.0));
	return vec4(1.0 - vigAmt * (uv.y - 0.5) * (uv.y - 0.5)) * (1.0 - vigAmt * (uv.x - 0.5) * (uv.x - 0.5));
}

float onOff(float a, float b, float c) {
	return step(c, sin(time + a * cos(time * b)));
}

vec4 get_color(vec2 uv) {
	vec2 look = uv;
	float window = 1.0/(1.0 + 20.0 * (look.y-mod(time/4.,1.))*(look.y-mod(time/4.,1.)));
	look.x = look.x + sin(look.y*10. + time)/50. * onOff(9.,4.,.3) * (1.+cos(time*80.))*window;
	float vShift = 0.4 * onOff(2.,3.,.9)*(sin(time)*sin(time*20.) + 
										 (0.5 + 0.1*sin(time*200.)*cos(time)));
	look.y = mix(mod(look.y + vShift, 1.), uv.y, 0.98);
	
	vec4 video = texture(screen_texture, mix(uv, look, 0.06));	
	
	return video;
}

void fragment() {
	if (!is_active) {
		COLOR = texture(screen_texture, SCREEN_UV);
	}
	else {
		
		vec2 uv = SCREEN_UV;
		
		// Distorsión "circular"
		uv -= vec2(.5,.5);
		uv = uv * 1.2 * (1./1.2 + 1. * uv.x * uv.x * uv.y * uv.y);
		uv += vec2(.5,.5);
		
		COLOR = get_color(uv);
		
		// Rayas horizontales
		COLOR += get_stripes(uv * 2.0) * 0.75;
		// Color
		COLOR += vignette(uv) * 0.25;
		
		
		COLOR *= (12.0 + mod(uv.y * 30.0 + time, 1.0)) / 13.0;
	}
	
	COLOR.g *= 1.25;
}
