Texture2D texChecker;
Texture2D texFuckedUp;
Texture2D texNoise;
Texture2D texPrevFrame;
Texture2D texTex1;
Texture2D texTex2;
Texture2D texTex3;
Texture2D texTex4;
Texture1D texFFT; // towards 0.0 is bass / lower freq, towards 1.0 is higher / treble freq
Texture1D texFFTSmoothed; // this one has longer falloff and less harsh transients
Texture1D texFFTIntegrated; // this is continually increasing
SamplerState smp;

cbuffer constants
{
  float fGlobalTime; // in seconds
  float2 v2Resolution; // viewport resolution (in pixels)
}

float4 plas( float2 v, float time )
{
  float c = 0.5 + sin( v.x * 10.0 ) + cos( sin( time + v.y ) * 20.0 );
  return float4( sin(c * 0.2 + cos(time)), c * 0.15, cos( c * 0.1 + time / .4 ) * .25, 1.0 );
}
float4 main( float4 position : SV_POSITION, float2 TexCoord : TEXCOORD ) : SV_TARGET
{
  
  float2 uv_uni = TexCoord;
  uv_uni.x *= -1;

  float2 uv = TexCoord;
  uv -= 0.5;
  uv /= float2(v2Resolution.y / v2Resolution.x, 1);


  float2 tunnel_transformed_uv;
  tunnel_transformed_uv.x = atan(uv.x / uv.y) / 3.14;
  tunnel_transformed_uv.y = 1 / length(uv) * .2;
  float d = tunnel_transformed_uv.y;

  float4 _tex_info_prev_frame = texPrevFrame.Sample(smp, uv_uni);


  float f = texFFT.Sample( smp, d ).r * 100;
  tunnel_transformed_uv.x += sin( fGlobalTime ) * 0.1;
  tunnel_transformed_uv.y += fGlobalTime * 0.25;

  int _beh = 0;
  float gtime = 0;
  gtime = fGlobalTime * 1.0;
  float _dec;
  //float fade = 1.0 - modf(gtime, _dec);
  float _f_dur = 7;
  float fade = _f_dur - (fmod(fGlobalTime, _f_dur));
  fade = fade / _f_dur;  

  float4 t = plas( tunnel_transformed_uv * 3.14, fGlobalTime ) / d;
  float4 _out = texChecker.Sample(smp, tunnel_transformed_uv);
  _out.r += (_tex_info_prev_frame.r * fade);
  _out.g += (_tex_info_prev_frame.g * fade);
  _out.b += (_tex_info_prev_frame.b * fade);
  //t = saturate( t );
  return _out; //f + t;
}