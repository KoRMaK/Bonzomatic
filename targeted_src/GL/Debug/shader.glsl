#version 410 core

uniform float fGlobalTime; // in seconds
uniform vec2 v2Resolution; // viewport resolution (in pixels)

uniform sampler1D texFFT; // towards 0.0 is bass / lower freq, towards 1.0 is higher / treble freq
uniform sampler1D texFFTSmoothed; // this one has longer falloff and less harsh transients
uniform sampler1D texFFTIntegrated; // this is continually increasing
uniform sampler2D texChecker;
uniform sampler2D texFuckedUp;
uniform sampler2D texNoise;
uniform sampler2D texTex1;
uniform sampler2D texTex2;
uniform sampler2D texTex3;
uniform sampler2D texTex4;

layout(location = 0) out vec4 out_color; // out_color must be written in order to see anything

vec4 plas( vec2 v, float time )
{
  float c = 0.5 + sin( v.x * 10.0 ) + cos( sin( time + v.y ) * 20.0 );
  return vec4( sin(c * 0.2 + cos(time)), c * 0.15, cos( c * 0.1 + time / .4 ) * .25, 1.0 );
}

float wrap_up(float value, float max)
{
  if(value > max)
  {
    value = -0.5 + (value - 1.0);
  }
  return value;
}

void main(void)
{
  vec2 uv = vec2((gl_FragCoord.x) / v2Resolution.x, gl_FragCoord.y / v2Resolution.y);
  //uv = vec2(0, 2.9);
  //uv.y *= -1;
  //uv *= -1; //whoa this makes a happy accident
  uv -= 0.5;
  //uv.y -= 0.5;
  //uv.x -= 0.7;
  uv /= vec2(v2Resolution.y / v2Resolution.x, 1);
  //uv.x -= 0.1; 

  vec2 tunnel_transformed_uv = uv;
  tunnel_transformed_uv.x = (atan(wrap_up(uv.x + 0.00, 1) / wrap_up(uv.y + 0, 1)) / 3.14);
  tunnel_transformed_uv.y = ((0.2 / length(uv)) * 1);
  tunnel_transformed_uv.y *= -1;
  tunnel_transformed_uv.x *= -1;


  //float f = texture( texChecker, _d ).t;// * 100;

  //tunnel_transformed_uv.x += sin( fGlobalTime ) * 0.1;
  tunnel_transformed_uv.y -= fGlobalTime * 0.15; //rate at which the thing moves forward

  tunnel_transformed_uv.x += 0.5;
  vec4 _tex_info = texture(texFuckedUp, tunnel_transformed_uv);
  //vec4 _t = plas( _m * 3.14, fGlobalTime ) / d;
  //_t = clamp( t, 0.0, 1.0 );
  out_color = _tex_info; // + _t; // + f 
}